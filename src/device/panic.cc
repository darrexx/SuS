/*****************************************************************************/
/* Betriebssysteme                                                           */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/*                                 P A N I C                                 */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/* Standard Unterbrechungsbehandlung.                                        */
/*****************************************************************************/
 
#include "guard/gate.h"
#include "machine/cpu.h"
#include "device/panic.h"

Panic panic;

void Panic::panic_hook(unsigned int type) {
  /* Wird via Aspekt mit Inhalt gefuellt da maschinenspezifisch*/
}

void Panic::panic(unsigned int type) {
  cpu.disable_int();

  panic_hook(type);

  cpu.halt();
}

bool Panic::prologue() {
  panic(PANIC_PROLOGUE);

  for (;;) ;

  /* gcc meckert sonst... */
  return false;
}
