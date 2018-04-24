/*
 * lcd.h
 *
 * Objekt zur grundlegenden Ansteuerung des LCDs der Chronos-Uhr
 *
 * Kann im Augenblick nur initialisieren (im Konstruktor) und
 * alle Segmente ausschalten.
 */

#ifndef LCD_H
#define LCD_H

class LCD {
private:
  LCD(const LCD &copy); // Verhindere Kopieren

  // Hinweis: Speicherbereich des LCD-Controllers (Kap. 23 des slau259)
  enum { LCD_MEMORY_START = 0x0a00 + 0x20, /* LCDM1  */
         LCD_MEMORY_END   = 0x0a00 + 0x2d  /* LCDM14 */ };

public:
  LCD();

  // Alle Segmente ausschalten
  void clear();

  /*
   * Fuer die zu implementierenden Funktionen gelten folgende Konventionen:
   *
   * "upper_line" legt fest, ob die obere (upper_line=true) oder untere
   * (upper_line=false) Zeile des LCDs angesteuert werden soll.
   *
   * "pos" legt die Position innerhalb einer Zeile fest, von links nach rechts:
   * Die obere Zeile hat 4 Positionen:    1234
   * Die untere Zeile hat 5 Positionen:  12345
   *
   */
  
  // Zeigt eine einzelne Ziffer "digit" an
  void show_digit(unsigned int digit, unsigned int pos, bool upper_line=false);
  
  // Zeigt ein einzelnes Zeichen "letter" an
  void show_char(const char letter, unsigned int pos, bool upper_line=true);
  
  // Zeigt eine ganze Zahl "number" an
  void show_number(long int number, bool upper_line=false);
  
  // Zeigt den String "text" an
  void show_string(const char *text, bool upper_line=true);
};

extern LCD lcd;

#endif
