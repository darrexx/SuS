/*****************************************************************************/
/* Betriebssysteme                                                           */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/*                                   C P U                                   */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/* Implementierung einer Abstraktion fuer den Prozessor.                     */
/* Derzeit wird nur angeboten, Interrupts zuzulassen, zu verbieten oder den  */
/* Prozessor anzuhalten.                                                     */
/*****************************************************************************/

#ifndef __CPU_include__
#define __CPU_include__

#include <msp430.h>
#include <in430.h>
class CPU
 {
private:
    CPU(const CPU &copy); // Verhindere Kopieren
public:
   CPU() {}
    // Erlauben von (Hardware-)Interrupts
    inline void enable_int ()
     {
       __eint();
     }

    // Interrupts werden ignoriert/verboten
    inline void disable_int ()
     {
       __dint();
       asm volatile ("nop");
     }

    // Prozessor bis zum naechsten Interrupt anhalten
    inline void idle ()
      {
        __eint();
        asm volatile ("nop");
        //LPM4;
        LPM2;
        asm volatile ("nop"); // CPU-Erratum-Workaround
      }
      
    // Prozessor bis zum naechsten Interrupt anhalten und groﬂteil der Hardware abschalten
    inline void sleep ()
      {
        __eint();
        asm volatile ("nop");
        //LPM4;
        LPM3;
        asm volatile ("nop"); // CPU-Erratum-Workaround
      }

    // Prozessor anhalten
    inline void halt ()
      {
        __eint();
        asm volatile ("nop");
        LPM4;
        asm volatile ("nop"); // CPU-Erratum-Workaround
      }
 };

extern CPU cpu;

#endif
