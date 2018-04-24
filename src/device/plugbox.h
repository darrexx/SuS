/*****************************************************************************/
/* Betriebssysteme                                                           */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/*                              P L U G B O X                                */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/* Abstraktion einer Interruptvektortabelle. Damit kann man die Adresse der  */
/* Behandlungsroutine fuer jeden Hardware-, Softwareinterrupt und jede       */
/* Prozessorexception festlegen.                                             */
/*****************************************************************************/

#ifndef __Plugbox_include__
#define __Plugbox_include__

#include "guard/gate.h"

class Plugbox {
public:
  /* Maschinenspezifische Vektorliste hier einbinden */
#  include "machine/plugbox_vectors.h"

private:
  Plugbox(const Plugbox &copy); // Verhindere Kopieren

  Gate *gates[PLUGBOX_VECTOR_COUNT];
public:

  Plugbox();
  void assign(unsigned int slot, Gate &gate);
  Gate &report(unsigned int slot);
};

extern Plugbox plugbox;

#endif
