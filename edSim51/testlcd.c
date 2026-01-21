/*
 *  testpreemptive.c  
 *  ---------------------------------------------------------------
 *  Producer-1 : buttons on P2  (uses buttonlib)
 *  Producer-2 : matrix keypad  (uses keylib)
 *  Consumer   : HD44780 LCD    (uses lcdlib)
 *
 *  Each producer writes one character into a 3-byte circular buffer.
 *  The consumer fetches a character and prints it on the LCD.
 */

#include <8051.h>
#include "preemptive.h"
#include "buttonlib.h"    /* AnyButtonPressed, ButtonToChar :contentReference[oaicite:0]{index=0} */
#include "keylib.h"       /* Init_Keypad, AnyKeyPressed, KeyToChar  :contentReference[oaicite:1]{index=1} */
#include "lcdlib.h"       /* LCD_* primitives                         :contentReference[oaicite:2]{index=2} */

 #define CNAME(s) _ ## s
#define LABELNAME(label) label ## $


void SemaphoreCreate(char *s, char n) {
   __critical {
      *s = n;
   }
}
/*------------------------------------------------------------------*/
/* *** shared objects  MANUALLY PLACED IN DATA MEMORY ***          */
/*------------------------------------------------------------------*/
__data __at (0x3D) char shared_buffer[3] = {' ',' ',' '};
__data __at (0x3A) char prod  = 0;        /* producer  index                */
__data __at (0x34) char cons = 0;        /* consumer  index                */
__data __at (0x29) ThreadID curr_thread;

__data __at (0x46) char mutex;           /* binary semaphore  mutual exe. */
__data __at (0x36) char empty;           /* counting sem  free slots      */
__data __at (0x37) char full;            /* counting sem  occupied slots  */

/*------------------------------------------------------------------*/
/* *** local scratch variables                                     */
/*------------------------------------------------------------------*/
__data __at (0x38) char key;                      
__data __at (0x39) char btn;  
__data __at (0x45) char c;  
    


/*------------------------------------------------------------------*/
/* *** Producer #1  front-panel push-buttons (port 2)             */
/*------------------------------------------------------------------*/
void Producer1(void)
{
    while (1) {
        while (!AnyButtonPressed()) ;   
        //need critical to avoid race conditions 
        __critical {        
        btn = ButtonToChar();   
        }        
                                                
        SemaphoreWait(empty);
        SemaphoreWait(mutex);
        EA=0;
        shared_buffer[prod] = btn;                         /* critical section        */
        EA=1;
        prod = (prod == 2) ? 0 : prod + 1;
        
        SemaphoreSignal(mutex);
        SemaphoreSignal(full);

        while (AnyButtonPressed()) ;             /* debounce  wait release */
    }
}
/*------------------------------------------------------------------*/
/* *** Producer #2   4x3 matrix keypad                             */
/*------------------------------------------------------------------*/
void Producer2(void)
{
    while (1) {
        while (!AnyKeyPressed()) ;               /* wait for key press      */
        __critical {
        key = KeyToChar();  
        }
        SemaphoreWait(empty);
        SemaphoreWait(mutex);
        EA=0;
        shared_buffer[prod] = key;                         /* critical section        */
        EA=1;
        prod = (prod == 2) ? 0 : prod + 1;

        SemaphoreSignal(mutex);
        SemaphoreSignal(full);

        while (AnyKeyPressed()) ;                /* wait for key release    */
    }
}

/*------------------------------------------------------------------*/
/* *** Consumer  print chars to the LCD                            */
/*------------------------------------------------------------------*/
void Consumer(void)
{
    c = 0;
    while (1) {
        SemaphoreWait(full);
        SemaphoreWait(mutex);
        EA = 0;
        c = shared_buffer[cons];  
        EA = 1;                  
        cons = (cons == 2) ? 0 : cons + 1;

        SemaphoreSignal(mutex);
        SemaphoreSignal(empty);

        LCD_write_char(c);
        while (!LCD_ready()) ;                   /* poll until LCD is free  */
    }
}

/*------------------------------------------------------------------*/
/* *** main thread  initialisation plus becoming Producer-1        */
/*------------------------------------------------------------------*/
void main(void)
{
    
    Init_Keypad();       /* enable AND-gate on P3.3, set P0 rows high */
    LCD_Init();          /* 4-bit mode, display on, cursor blinking   */

    SemaphoreCreate(&mutex, 1);
    SemaphoreCreate(&empty, 3);
    SemaphoreCreate(&full , 0);

    ThreadCreate(Consumer);
    ThreadCreate(Producer2);
    Producer1();
}


void _sdcc_gsinit_startup(void)
{
    __asm
        LJMP  _Bootstrap          ; 
    __endasm;
}

void _mcs51_genRAMCLEAR(void)   {}  /* SDCC must find these  */
void _mcs51_genXINIT(void)      {}
void _mcs51_genXRAMCLEAR(void)  {}

void timer0_ISR(void) __interrupt (1)
{
    __asm
        LJMP  _myTimer0Handler   ; 
    __endasm;
}
