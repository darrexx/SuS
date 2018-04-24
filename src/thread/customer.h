/*****************************************************************************/
/* Betriebssysteme                                                           */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/*                         C U S T O M E R                                   */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/* Ein Thread, der auf ein Ereignis warten kann.                             */
/*****************************************************************************/

#ifndef __customer_include__
#define __customer_include__

#include "meeting/waitingroom.h"
#include "thread/entrant.h"

class Customer : public Entrant {
private:
  Customer (const Customer &copy); // Verhindere Kopieren

  Waitingroom *myroom;
public:
  Customer(void *tos) : Entrant(tos), myroom(0) {}
  void waiting_in(Waitingroom *w) {
    myroom = w;
  }

  Waitingroom* waiting_in() {
    return myroom;
  }
};

#endif
