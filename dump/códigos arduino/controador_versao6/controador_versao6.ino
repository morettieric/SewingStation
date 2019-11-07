/* Na ersão anterior eram utilziados dois temporizadores adicionais, um para cada encoder. Chegou-se à conclusão que a qualidade da medição não melhorava. Ao invés, optou-se pela utilização
   de um filtro passa-baixo aplicado aos dados provenientes de cada contador associado a cada um dos encoders. Os resultados melhoraram e permitiram a utilização do PWM para controlar o
   variador de frequência (em vez de ter que usar a DAC).
*/
//revisando o código do pid discreto
//- timer0 is been used for the software Sketch timing functions, such as delay(), millis() and micros() ==> if you change timer0 registers, you influence the Arduino timing function.
//
//- timer0  = Pins 5, 6
//- timer1  = Pins 9, 10
//- timer2 = Pins 11, 3
//
//Timer0 and timer2 are 8bit timers and timer1 is a 16bit timer

#define LED 13                // Luz piloto que indica o período de amostragem
#define CFW10 11              // Ligada à entrada analógica do CFW10
#define Scarro 1.55           // Sensibilidade da velocidade em função da frequencia
#define Stecido 3.42          // Sensibilidade da velocidade em função da frequencia
#define SPscale 0.6           // Fator de ajuste do set-point 

volatile bool sample;         // Flag que ativa nova amostragem
volatile int  cartPulses = 0; // Conta o numero de transições observadas em cada 100ms para o carrinho
volatile int swingPulses = 0; // Conta o numero de transições observadas em cada 100ms para a máquina de costura

double x1_k = 0.0, x1_k_1 = 0.0, x1_k_2 = 0.0; // Variáveis de estado para o filtro passa-baixo para a medição da velocidade do
double y1_k = 0.0, y1_k_1 = 0.0, y1_k_2 = 0.0; // carro

double x2_k = 0.0, x2_k_1 = 0.0, x2_k_2 = 0.0; // Variáveis de estado para o filtro passa-baixo para a medição da velocidade do
double y2_k = 0.0, y2_k_1 = 0.0, y2_k_2 = 0.0; // máquina de costura

double Vcarro  = 0.0;  // Velocidade do carro em m/h
double Vtecido = 0.0;  // Velocidade do tecido em m/h
double Setpoint = 0.0;       // Setpoint em m/h
double u_k = 0.0;      // Sinal de controlo aplicado no instante k
double u_k_1 = 0.0;    // Sinal de controlo aplicado no instante k-1
double e_k = 0.0;      // Sinal de erro calculado no instante k
double e_k_1 = 0.0;    // Sinal de erro calculado no instante k-1

//constantes utilizadas na f.t. do controlador

double a=3.146609305516898;  
double b=-1.960657370036687; 
double c=1;

double x, x1, x2, x3, y, y1,y2 = 0;
//............................

/************************************************************
          CONFIG TIMER 1 (sampling period)
*************************************************************/
void ConfigTimer1(void)
{
  //----------------------- Configure TIMER 1
  TCCR1A = 0x00;
  // Timer mode with 256 prescaler (62500 Hz)
  TCCR1B = (1 << CS12);
  // 100 ms => (2^16-1) - 16e6/256*0.1
  TCNT1  = 59285;
  // Enable timer1 overflow interrupt
  TIMSK1 = (1 << TOIE1) ;
}
/************************************************************
          Config INT 0
*************************************************************/
void ConfigInt0(void)
{
  DDRD  &= ~(1 << PD2); // PD2 as input
  PORTD |= (1 << PD2); //Turn On the Pull-up
  EICRA |= (1 << ISC00); //Any logical change on INT0 generates
  EIMSK |= (1 << INT0); //an interrupt request
}
/************************************************************
          Config INT 1
*************************************************************/
void ConfigInt1(void)
{
  DDRD  &= ~(1 << PD3); // PD2 as input
  PORTD |= (1 << PD3); //Turn On the Pull-up
  EICRA |= (1 << ISC10); //Any logical change on INT1 generates
  EIMSK |= (1 << INT1); //an interrupt request
}
/************************************************************
          TIMER 1 ISR
*************************************************************/
ISR (TIMER1_OVF_vect)
{
  sample = true;
  TCNT1 = 59285;    // for 100ms@16MHz
}
/************************************************************
          INT0 ISR
*************************************************************/
ISR (INT0_vect)
{
  cartPulses++;
}
/************************************************************
          INT1 ISR
*************************************************************/
ISR (INT1_vect)
{
  swingPulses++;
}
/************************************************************
          MAIN
*************************************************************/
void setup() {
  cli();
  Serial.begin(250000);
  ConfigTimer1();
  ConfigInt0();
  ConfigInt1();
  pinMode(LED, OUTPUT);
  pinMode(CFW10, OUTPUT);
  pinMode(7  , OUTPUT);
  sei();
  analogWrite(CFW10, 100);

}

void loop() {
  // put your main code here, to run repeatedly:
  if (sample)
  {
    cli();
    digitalWrite(LED, !digitalRead(LED));
    /************************************************************
      // Filtro passa-baixo de 2ª ordem (Butterwrth com Wc = 0.2)
    *************************************************************/
    x1_k_2 = x1_k_1; // Atualiza variáveis de estado
    x1_k_1 = x1_k;   // Atualiza variáveis de estado
    x1_k   = (double) (5.0 * cartPulses);
    y1_k_2 = y1_k_1; // Atualiza variáveis de estado
    y1_k_1 = y1_k;   // Atualiza variáveis de estado
    y1_k = 0.0675 * x1_k + 0.135 * x1_k_1 + 0.0675 * x1_k_2 + 1.143 * y1_k_1 - 0.413 * y1_k_2;
    if (y1_k < 0) y1_k = 0;
    // y1_k é a frequência medida, em Hz, do carro
    /************************************************************
      // Filtro passa-baixo de 2ª ordem (Butterwrth com Wc = 0.2)
    *************************************************************/
    x2_k_2 = x2_k_1; // Atualiza variáveis de estado
    x2_k_1 = x2_k;   // Atualiza variáveis de estado
    x2_k   = (double) (5.0 * swingPulses);
    y2_k_2 = y2_k_1; // Atualiza variáveis de estado
    y2_k_1 = y2_k;   // Atualiza variáveis de estado
    y2_k = 0.0675 * x2_k + 0.135 * x2_k_1 + 0.0675 * x2_k_2 + 1.143 * y2_k_1 - 0.413 * y2_k_2;
    if (y2_k < 0) y2_k = 0;
    // y2_k é a frequência medida, em Hz, da máquina de costura
    /************************************************************
      // Controlador
    *************************************************************/
    //.................................................... Velocidade do carro
    Vcarro  = Scarro * y1_k;                // expressa em (m/h)
    //.................................................... Velocidade do tecido
    Vtecido = Stecido * y2_k;              // expressa em (m/h)
    //.................................................... Velocidade da máquina de costura (setpoint)
    Setpoint      = SPscale * Vtecido;
    //.................................................... Erro de setpoint atual
    x     = Setpoint - Vcarro;  // expressa em (m/h)
    //.................................................... Controlador PI
    //u_k = 0.3255 * e_k - 0.1724 * e_k_1 + u_k_1;
    y=a*x+b*x1+y1;
    if (y < 0) y = 0;
    else if (y > 255) y = 255;
    //.................................................... Aplica variável de controlo
    analogWrite(CFW10, (uint8_t)y);
    //.................................................... Atualiza variáveis de estado
    y1 = y;
    x1 = x;
    //.................................................... NOVA AMOSTRA
    Serial.print("Erro:\t");
    Serial.print(x);
    Serial.print("\tCarro:\t");
    Serial.print(Vcarro);
    Serial.print("\tTecido:\t");
    Serial.print(Vtecido);
    Serial.print("\tCtr:\t");
    Serial.println(y);
    digitalWrite(7, !digitalRead(7));

    cartPulses  = 0;
    swingPulses = 0;
    sample = false;
    sei();


  }



}
