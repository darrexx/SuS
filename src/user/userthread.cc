#include "user/userthread.h"
#include <msp430.h>
#include "machine/system.h"
#include "machine/lcd.h"
#include "machine/buttons.h"

/* 512 Byte Stack */
DeclareThread(UserThread, userthread, 512);

void UserThread::action() {
  while (1) {
    /* Fuer 100ms schlafen legen, um Strom zu sparen */
    this->sleep(100);
  
    /* Watchdog anstossen */
    watchdog_reset();

    // Hier muesst ihr selbst Code ergaenzen
	P2DIR &= 0b11101000;
	P2OUT &= 0b11101000;
	P2REN |= (Buttons::UP + Buttons::DOWN + Buttons::STAR + Buttons::HASH);

    while(true) {
    	lcd.show_number((int)P2IN, false);
    }

    // lcd.show_digit(1, 1); // Beispielsweiser LCD-Zugriff
  }
  // Achtung: Die action()-Methode darf nicht zurueckkehren,
  //          daher die Endlosschleife!
}
