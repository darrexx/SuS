#ifndef BUTTONS_H
#define BUTTONS_H

#include <inttypes.h> // definiert uint8_t

// Hier muesst ihr selbst Code ergaenzen,
// bzw. die Methoden dieser Klasse implementieren.

class Buttons {
public:

  /* 
   * Die folgenden Konstanten definieren diejenigen Bits,
   * die den einzelnen Buttons zugeordnet sind.
   * Welche das genau sind, muesst ihr anhand des Daten-
   * blatts "eZ430-Chronos User's Guide (slau292)" herausfinden.
   */
  static const uint8_t UP = 0b00010000  /* = ... */ ; // Hier muesst ihr selbst Code ergaenzen
  static const uint8_t DOWN = 0b00000001/* = ... */ ; // Hier muesst ihr selbst Code ergaenzen
  static const uint8_t HASH = 0b00000010/* = ... */ ; // Hier muesst ihr selbst Code ergaenzen
  static const uint8_t STAR = 0b00000100/* = ... */ ; // Hier muesst ihr selbst Code ergaenzen

  /*
   * enable(btn): aktiviert den(die) gewuenschten Button(s)
   */
  void enable(uint8_t button_bitmap);

  /*
   * read(): liefert den aktuellen Buttonstatus aller Buttons
   *         in dem Rueckgabewert vom Typ "uint8_t"
   */
  uint8_t read();

  /*
   *  pressed(btn): liefert true, wenn der(die) gewuenschte(n) Button(s)
   *                gerade gedrueckt ist
   *                Beispielaufruf: pressed(Buttons::UP | Buttons::DOWN);
   *                -> liefert true, falls UP und DOWN gedrueckt sind
   */
  bool pressed(uint8_t button_bitmap);
};

extern Buttons buttons;

#endif /* BUTTONS_H */

