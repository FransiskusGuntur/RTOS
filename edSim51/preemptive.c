#include <8051.h>
#include "preemptive.h"
/*
 * @@@ [2 pts] declare the static globals here using 
 *        __data __at (address) type name; syntax
 * manually allocate the addresses of these variables, for
 * - saved stack pointers (MAXTHREADS)
 * - current thread ID
 * - a bitmap for which thread ID is a valid thread; 
 *   maybe also a count, but strictly speaking not necessary
 * - plus any temporaries that you need.
 */

#define MAXTHREADS 4

__data __at (0x30) int SPthread_1;
__data __at (0x31) int SPthread_2;
__data __at (0x32) int SPthread_3;
__data __at (0x33) int SPthread_4;
__data __at (0x2A) int thread_mask;
__data __at (0x29) ThreadID curr_thread;
__data __at (0x20) ThreadID new_thread;
__data __at (0x21) ThreadID next_prod;

#define SAVESTATE { \
    __asm PUSH ACC __endasm; \
    __asm PUSH B __endasm; \
    __asm PUSH DPL __endasm; \
    __asm PUSH DPH __endasm; \
    __asm PUSH PSW __endasm; \
    switch (curr_thread) { \
        case '0': __asm MOV 0x30, SP __endasm; break; \
        case '1': __asm MOV 0x31, SP __endasm; break; \
        case '2': __asm MOV 0x32, SP __endasm; break; \
        case '3': __asm MOV 0x33, SP __endasm; break; \
    } \
}

#define RESTORESTATE { \
    switch (curr_thread) { \
        case '0': __asm MOV SP, 0x30 __endasm; break; \
        case '1': __asm MOV SP, 0x31 __endasm; break; \
        case '2': __asm MOV SP, 0x32 __endasm; break; \
        case '3': __asm MOV SP, 0x33 __endasm; break; \
    } \
    __asm POP PSW __endasm; \
    __asm POP DPH __endasm; \
    __asm POP DPL __endasm; \
    __asm POP B __endasm; \
    __asm POP ACC __endasm; \
}

extern void main(void);
/*
 * Bootstrap is jumped to by the startup code to make the thread for
 * main, and restore its context so the thread can run.
 */

void Bootstrap(void) {
    thread_mask = 0;
    SPthread_1 = 0x3F;
    SPthread_2 = 0x4F;
    SPthread_3 = 0x5F;
    SPthread_4 = 0x6F;

    TMOD = 0;
    IE = 0x82;
    TR0 = 1;

    next_prod = '1';
    curr_thread = ThreadCreate(main);
    RESTORESTATE;
}

//fairly switch between the 2 producer
//
void myTimer0Handler(void) {
    EA = 0;
    SAVESTATE;
    if (curr_thread != '0') {
        curr_thread = '0';
    } 
    /*
    else {
        curr_thread = next_prod;
        next_prod = (next_prod == '1') ? '2' : '1';
    }
        */

    else {
        curr_thread = next_prod;
        if(curr_thread == '1') {
            next_prod = '2';
        }
        else next_prod = '1';
    }
    RESTORESTATE;
    EA = 1;
    __asm RETI __endasm;
}





ThreadID ThreadCreate(FunctionPtr fp) {

     /*
         * @@@ [5 pts]
         *     otherwise, find a thread ID that is not in use,
         *     and grab it. (can check the bit mask for threads),
         * 
         * @@@ [18 pts] below
         *  a. update the bit mask 
         *     (and increment thread count, if you use a thread count, 
         *     but it is optional)
         *  b. calculate the starting stack location for new thread
         *  c. save the current SP in a temporary
         *     set SP to the starting location for the new thread
         *  d. push the return address fp (2-byte parameter to
         *     ThreadCreate) onto stack so it can be the return
         *     address to resume the thread. Note that in SDCC
         *     convention, 2-byte ptr is passed in DPTR.  but
         *     push instruction can only push it as two separate
         *     registers, DPL and DPH.
         *  e. we want to initialize the registers to 0, so we
         *     assign a register to 0 and push it four times
         *     for ACC, B, DPL, DPH.  Note: push #0 will not work
         *     because push takes only direct address as its operand,
         *     but it does not take an immediate (literal) operand.
         *  f. finally, we need to push PSW (processor status word)
         *     register, which consist of bits
         *     CY AC F0 RS1 RS0 OV UD P
         *     all bits can be initialized to zero, except <RS1:RS0>
         *     which selects the register bank.  
         *     Thread 0 uses bank 0, Thread 1 uses bank 1, etc.
         *     Setting the bits to 00B, 01B, 10B, 11B will select 
         *     the register bank so no need to push/pop registers
         *     R0-R7.  So, set PSW to 
         *     00000000B for thread 0, 00001000B for thread 1,
         *     00010000B for thread 2, 00011000B for thread 3.
         *  g. write the current stack pointer to the saved stack
         *     pointer array for this newly created thread ID
         *  h. set SP to the saved SP in step c.
         *  i. finally, return the newly created thread ID.
         */

    EA = 0;
    if (thread_mask == 0x0F) {
        return -1;
    }

    if (!(thread_mask & 0x01)) new_thread = '0';
    else if (!(thread_mask & 0x02)) new_thread = '1';
    else if (!(thread_mask & 0x04)) new_thread = '2';
    else new_thread = '3';

    thread_mask |= (1 << (new_thread - '0'));

    __data __at (0x24) int prevSP;
    prevSP = SP;

    if (new_thread == '0') SP = 0x3F;
    else if (new_thread == '1') SP = 0x4F;
    else if (new_thread == '2') SP = 0x5F;
    else if (new_thread == '3') SP = 0x6F;

    __asm MOV A, DPL __endasm;
    __asm PUSH ACC __endasm;
    __asm MOV A, DPH __endasm;
    __asm PUSH ACC __endasm;

    __asm MOV A, #0x00 __endasm;
    __asm PUSH ACC __endasm;
    __asm PUSH ACC __endasm;
    __asm PUSH ACC __endasm;
    __asm PUSH ACC __endasm;

    if (new_thread == '0') __asm MOV A, #0x00 __endasm;
    else if (new_thread == '1') __asm MOV A, #0x08 __endasm;
    else if (new_thread == '2') __asm MOV A, #0x10 __endasm;
    else __asm MOV A, #0x18 __endasm;

    __asm PUSH ACC __endasm;

    if (new_thread == '0') SPthread_1 = SP;
    else if (new_thread == '1') SPthread_2 = SP;
    else if (new_thread == '2') SPthread_3 = SP;
    else SPthread_4 = SP;

    SP = prevSP;
    EA = 1;
    return new_thread;
}

//NO NEED THREAD YIELD 


void ThreadExit(void) {
    // Clear current thread's bit in thread_mask
    //ANL 0x2A, #11111101
    thread_mask &= ~(1 << (curr_thread - '0'));

    // Find next runnable thread in round-robin order
    while (1) {
        curr_thread = (curr_thread - '0' + 1) % 4 + '0';

        if (thread_mask & (1 << (curr_thread - '0'))) {
            break;
        }
    }

    RESTORESTATE;
}
