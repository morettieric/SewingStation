/*----------------------------------------------
      Mede velocidade de rotaÃ§Ã£o do carro em m/s
   e mede a velocidade de deslocamento do tecido
      O codificador associado ao motor serÃ¡ ligado
   no porto 2 do Arduino (pino 4 do ATMEGA328) e
   o codificador da mÃ¡quina liga no porto 3 (pino
   5 do microcontrolador). Ao primeiro serÃ¡ as-
   -sociado o INT0 e ao segundo o INT1.
      Executando o Serial Monitor (250k de baud
   rate) deve ser possÃ­vel ver os dois valores de
   forma independente.
*/
#include <avr/io.h>
#include <avr/interrupt.h>
#define _DISABLE_ARDUINO_TIMER0_INTERRUPT_HANDLER_
#include <wiring.c>
// LED para depuraÃ§Ã£o
#define LED 13
// Variables
volatile bool sample = false;
volatile byte periodoA = 0;
volatile byte overrunA = 0;
volatile byte lastperiodoA = 0;
volatile byte lastoverrunA = 0;
volatile int  pulsesA = 0;

volatile byte periodoB = 0;
volatile byte overrunB = 0;
volatile byte lastperiodoB = 0;
volatile byte lastoverrunB = 0;
volatile int  pulsesB = 0;

//------------------------Amostragem ISR
ISR (TIMER1_OVF_vect)    // Timer1 ISR
{
  sample = true;
  TCNT1 = 59285;    // para 100ms@16MHz
}
//------------------Counta Pulsos ISR (A)
void EncoderIntA()
{
  pulsesA++;
  if (digitalRead(2)) {
    TCNT2  = 0;
    overrunA = 0;
    periodoA = 0;
  }
  else {
    periodoA = TCNT2;
    lastperiodoA = periodoA;
    lastoverrunA = overrunA;
  }
}
ISR (TIMER2_OVF_vect)    // Timer2 ISR
{
  overrunA++;
}
//------------------Counta Pulsos ISR (B
void EncoderIntB()
{
  pulsesB++;
  if (digitalRead(3)) {
    TCNT0  = 0;
    overrunB = 0;
    periodoB = 0;
  }
  else {
    periodoB = TCNT0;
    lastperiodoB = periodoB;
    lastoverrunB = overrunB;
  }
}
ISR (TIMeR0_OVF_vect)    // Timer0 ISR
{
  overrunB++;
}

//-------------------------------Setup
void setup() {
  //--------------------Configure Port
  Serial.begin(250000);
  //-------------------------Debug LED
  pinMode(LED, OUTPUT);
  pinMode(11, OUTPUT);
  analogWrite(11, 125);
  // Disable interrupts
  cli();
  //----------------------- Configura TIMER 1
  //(ResponsÃ¡vel pelo processo de amsotragem)
  TCCR1A = 0x00;
  // Timer com 256 prescaler (62500 Hz)
  TCCR1B = (1 << CS12);
  // 100 ms => (2^16-1) - 16e6/256*0.1
  TCNT1  = 59285;
  // Habilita timer1 overflow interrupt
  TIMSK1 = (1 << TOIE1) ;
  //----------------------- Configura TIMER 2
  //(responsÃ¡vel pelo codificador do motor)
  TCCR2A = 0x00;
  // Timer com prescaler = 256 (62500 Hz)
  TCCR2B = (1 << CS22) | (1 << CS21);
  // Habilita timer2 overflow interrupt
  TIMSK2 = (1 << TOIE2) ;
  //----------------------- Configura TIMER 0
  //(responsÃ¡vel pelo codificador da mÃ¡quina)
  TCCR0A = 0x00;
  // Timer com prescaler = 256 (62500 Hz)
  TCCR0B = (1 << CS02);
  // Habilita timer2 overflow interrupt
  TIMSK0 = (1 << TOIE0) ;

  // ---------------------- Configura INT0
  attachInterrupt(digitalPinToInterrupt(2), EncoderIntA, CHANGE);
  // ---------------------- Configura INT1
  attachInterrupt(digitalPinToInterrupt(3), EncoderIntB, CHANGE);
  sei();
}
//-------------------------------Main
void loop() {
  double frequenciaA = 0;
  double frequenciaB = 0;
  double y, y1, y2, y3, x1, x2, x3 = 0;
  if (sample) {
    cli();
    digitalWrite(LED, !digitalRead(LED));
    //-------------------------------------------------------------
    double totalperiodA = (double) 256.0 * lastoverrunA + lastperiodoA;
    if (totalperiodA == 0.0) {
      frequenciaA = 0.0;
    }
    else {
      // Cada tick Ã© 1/62500 segundos. 63% ciclo de trabalho considerado
      frequenciaA = 39375.0 / totalperiodA;
      if (frequenciaA > 50.0) {
        frequenciaA = (double)5.0 * pulsesA;
      }
    }
    lastoverrunA = 0;
    lastperiodoA = 0;
    pulsesA = 0;
    //-------------------------------------------------------------
    double totalperiodB = (double) 256.0 * lastoverrunB + lastperiodoB;
    if (totalperiodB == 0.0) {
      frequenciaB = 0.0;
    }
    else {
      // Cada tick Ã© 1/62500 segundos. 63% ciclo de trabalho considerado
      frequenciaB = 39375.0 / totalperiodB;
      if (frequenciaB > 50.0) {
        frequenciaB = (double)5.0 * pulsesB;
      }
    }
    lastoverrunB = 0;
    lastperiodoB = 0;
    pulsesB = 0;
    //-------------------------------------------------------------
    Serial.print(frequenciaA);
    Serial.print("\t");
    Serial.print(frequenciaB);
    Serial.print("\t");
    Serial.println(y);


    sample = false;

    // Controlador------------------------
    
    
    static double a1 = 0.127419763779433;
    static double a2 = -0.249537770075301;
    static double a3 = 0.122267541459961;
    static double b1 = -2.738465357287645;
    static double b2 = 2.487912774401635;
    static double b3 = -0.749297881949897;
    y = a1 * x1 + a2 * x2 + a3 * x3 - b1 * y1 + b2 * y2 + b3 * y3;

    y1 = y;
    y2 = y1;
    y3 = y2;

    x1 = frequenciaA;
    x2 = x1;
    x3 = x2;
    analogWrite(11, 125);
    //------------------------------------
    sei();
  }
}
