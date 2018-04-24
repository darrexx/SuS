/*****************************************************************************/
/* Betriebssysteme                                                           */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/*                              P L U G B O X                                */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/* Abstraktion einer Interruptvektortabelle. Damit kann man die Behandlungs- */
/* routine fuer jeden Hardware-, Softwareinterrupt und jede Prozessor-       */
/* exception festlegen.                                                      */
/*****************************************************************************/

#include "device/panic.h"
#include "guard/gate.h"
#include "device/plugbox.h"

Plugbox plugbox;

Plugbox::Plugbox() {
  unsigned int i;

  for (i=0; i<sizeof(gates)/sizeof(gates[0]); i++) {
    gates[i] = &panic;
  }
}

void Plugbox::assign(unsigned int slot, Gate &gate) {
  if (slot > sizeof(gates)/sizeof(gates[0]))
    return;

  gates[slot] = &gate;
}

Gate &Plugbox::report(unsigned int slot) {
  if (slot > sizeof(gates)/sizeof(gates[0]))
    return panic;

  return *gates[slot];
}
