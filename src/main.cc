/*
 * main.cc - Initialisierung und Threadstart
 *
 * Wenn alle Threads mit Aspekten eingebunden werden, sind
 * in dieser Datei keine Aenderungen notwendig. Wenn nicht,
 * sollten Threadanmeldungen in ready_threads() erfolgen.
 */

#include "device/watch.h"
#include "guard/guard.h"
#include "machine/cpu.h"
#include "machine/system.h"
#include "syscall/guarded_organizer.h"
#include "syscall/thread.h"

Watch watch(10000);


// Hier sollten die Includes der eigenen Thread-Headerfiles ergaenzt werden
#include "user/userthread.h"

/* Threads beim Scheduler anmelden */
static void ready_threads() {
  organizer.Organizer::ready(userthread);
}

int main() {
  // VCore und Takte konfigurieren
  system_init();

  // Threads aktivieren
  ready_threads();

  // Auf Epilogebene wechseln um ungestoert initialisieren zu koennen
  guard.enter();
  cpu.disable_int();

  // Timerinterrupts einschalten
  watch.windup();
  cpu.enable_int();

  // Scheduling starten
  organizer.Organizer::schedule();

  // Endlosschleife - wird nie erreicht, spart aber ein wenig Speicher
  while (1) ;
}
