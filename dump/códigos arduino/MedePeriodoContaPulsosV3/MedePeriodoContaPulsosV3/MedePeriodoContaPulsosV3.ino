#include <avr/io.h>
#include <avr/interrupt.h>

// LED para depuração
#define LED 13
// Variables
volatile bool sample = false;
volatile byte periodo = 0;
volatile byte overrun = 0;
volatile byte lastperiodo = 0;
volatile byte lastoverrun = 0;
volatile int  pulses = 0;

//------------------------Amostragem ISR
ISR (TIMER1_OVF_vect)    // Timer1 ISR
{
  sample=true;  
  TCNT1 = 59285;    // para 100ms@16MHz
}
//--------------------Counta Pulsos ISR
void EncoderInt()
{
 pulses++;
  if (digitalRead(2)){
    TCNT2  = 0;
    overrun = 0;
    periodo = 0;
    }
  else{
    periodo = TCNT2;
    lastperiodo = periodo;
    lastoverrun = overrun;
    }
}
//------------------------Amostragem ISR
ISR (TIMER2_OVF_vect)    // Timer2 ISR
{
  overrun++;
}

//-------------------------------Setup
void setup() {
  //--------------------Configure Port
  Serial.begin(250000);
  //-------------------------Debug LED
  pinMode(LED, OUTPUT);
  // Disable interrupts
  cli(); 
  //----------------------- Configura TIMER 1
  TCCR1A = 0x00;
  // Timer com 256 prescaler (62500 Hz)
  TCCR1B = (1<<CS12);
  // 100 ms => (2^16-1) - 16e6/256*0.1
  TCNT1  = 59285;
  // Habilita timer1 overflow interrupt
  TIMSK1 = (1 << TOIE1) ;
  //----------------------- Configura TIMER 2
  TCCR2A = 0x00;
  // Timer com 256 prescaler (62500 Hz)
  TCCR2B = (1<<CS22)|(1<<CS21);
  // Habilita timer2 overflow interrupt
  TIMSK2 = (1 << TOIE2) ;
  // ---------------------- Configura INT0
  attachInterrupt(digitalPinToInterrupt(2),EncoderInt,CHANGE);
  sei();
}
//-------------------------------Main
void loop() {
  double frequencia = 0;
  if (sample){
      cli();
      digitalWrite(LED,!digitalRead(LED));
      double totalperiod = (double) 256.0*lastoverrun+lastperiodo;
      if(totalperiod==0.0){
        frequencia = 0.0;
      }
      else {
        // Cada tick é 1/62500 segundos. 63% ciclo de trabalho considerado
        frequencia = 39375.0/totalperiod;
        if(frequencia>50.0){
          frequencia = (double)5.0*pulses;
        }
      }
      lastoverrun=0;
      lastperiodo=0;
      Serial.println(frequencia);
      pulses = 0;
      sample=false;
      
      // Controlador------------------------
      

      //------------------------------------
      sei();
      }
}
