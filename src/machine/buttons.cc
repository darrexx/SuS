#include "buttons.h"
#include <msp430.h> // definiert Acronyme (Digital I/O Registers)

Buttons buttons; // Globales Buttons-Objekt

// Hier muesst ihr selbst Code ergaenzen

void Buttons::enable(uint8_t button_bitmap) {
	// P2 als Input konfigurieren:
	P2DIR &= 0b11101000;
	P2OUT &= 0b11101000;
	P2REN |= (Buttons::UP + Buttons::DOWN + Buttons::STAR + Buttons::HASH);

}

uint8_t Buttons::read() {
	return 1;
}

bool Buttons::pressed(uint8_t button_bitmap) {

	return true;
}
