/*****************************************************************************/
/* Betriebssysteme                                                           */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/*                    G U A R D E D _ O R G A N I Z E R                      */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/* Systemaufrufschnittstelle zum Organizer.                                  */
/*****************************************************************************/

#include "guard/secure.h"
#include "syscall/guarded_organizer.h"

Guarded_Organizer organizer;

void Guarded_Organizer::ready(Thread &that) {
  Secure sec;

  Organizer::ready(that);
}

void Guarded_Organizer::exit() {
  Secure sec;

  Organizer::exit();
}

void Guarded_Organizer::kill(Thread &that) {
  Secure sec;

  Organizer::kill(that);
}

void Guarded_Organizer::resume() {
  Secure sec;

  Organizer::resume();
}
