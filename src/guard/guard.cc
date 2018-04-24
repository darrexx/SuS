/*****************************************************************************/
/* Betriebssysteme                                                           */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/*                                G U A R D                                  */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/* Mit Hilfe dieser Klasse koennen Aktivitaeten, die einen kritischen        */
/* Abschnitt betreffen, der mit einem Guard-Objekt geschuetzt ist, mit       */
/* Unterbrechungsbehandlungsroutinen synchronisiert werden, die ebenfalls    */
/* auf den kritischen Abschnitt zugreifen.                                   */
/*****************************************************************************/

#include <stddef.h>
#include "machine/cpu.h"
#include "guard/guard.h"

Guard guard;

Guard::Guard() {
}

void Guard::leave() {
  // Gequeuete Epiloge abarbeiten bevor Epilog-Level verlassen wird
  Gate *item;

  do {
    cpu.disable_int();
    item = static_cast<Gate*>(epilogqueue.dequeue());

    if (item != NULL) {
      item->queued(false);
      cpu.enable_int();
      item->epilogue();
    }
  } while (item != NULL);

  // Alle Epiloge abgearbeitet, Epilog-Level verlassen
  retne();
  cpu.enable_int();
}

void Guard::relay(Gate* item) {
  if (avail()) {
    // Nicht auf dem Epilog-Level, wechseln und sofort aufrufen
    enter();
    cpu.enable_int();
    item->epilogue();
    leave();
  } else {
    // Schon auf dem Epilog-Level, in Queue legen fuer spaetere Abarbeitung
    if (item->queued())
      return;

    item->queued(true);
    epilogqueue.enqueue(item);
  }
}
