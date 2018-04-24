/*
 * lcd.cc
 *
 * Objekt zur grundlegenden Ansteuerung des LCDs der Chronos-Uhr
 *
 * Kann im Augenblick nur initialisieren (im Konstruktor) und
 * alle Segmente ausschalten.
 */

#include <msp430.h>
#include "machine/lcd.h"

#define SEGMENT_A_U 16
#define SEGMENT_B_U 32
#define SEGMENT_C_U 64
#define SEGMENT_D_U 128
#define SEGMENT_E_U 4
#define SEGMENT_F_U 1
#define SEGMENT_G_U 2

#define SEGMENT_A_L 1
#define SEGMENT_B_L 2
#define SEGMENT_C_L 4
#define SEGMENT_D_L 8
#define SEGMENT_E_L 64
#define SEGMENT_F_L 16
#define SEGMENT_G_L 32




LCD lcd; // Globales LCD-Objekt

LCD::LCD() {
  // Display-Speicher loeschen
  LCDBMEMCTL |= LCDCLRBM | LCDCLRM;

  // LCD_FREQ = ACLK/16/8 = 256Hz
  // Framefrequenz = 256Hz/4 = 64Hz, LCD mux 4, LCD on
  LCDBCTL0 = LCDDIV_15 | LCDPRE__8 | LCD4MUX | LCDON;

  // Blinkfrequenz = ACLK/8/4096 = 1Hz
  LCDBBLKCTL = LCDBLKPRE0 | LCDBLKPRE1 |
               LCDBLKDIV0 | LCDBLKDIV1 | LCDBLKDIV2 | LCDBLKMOD0;

  // I/O to COM outputs
  P5SEL |= (BIT5 | BIT6 | BIT7);
  P5DIR |= (BIT5 | BIT6 | BIT7);

  // LCD-Ausgabe aktivieren
  LCDBPCTL0 = 0xFFFF;
  LCDBPCTL1 = 0xFF;
}

void LCD::clear() { LCDBMEMCTL |= LCDCLRBM | LCDCLRM; }


// Hier muesst ihr selbst Code ergaenzen, beispielsweise:
void LCD::show_number(long int number, bool upper_line) {
	if((upper_line && number >= 10000) || (!upper_line && number >= 100000)) {
		return;
	}
	int curr_pos = 1;
	while((upper_line && curr_pos <=5) || (!upper_line && curr_pos <= 6)) {
		this->show_digit(number % 10, curr_pos++, upper_line);
		number /= 10;
	}
}

void LCD::show_digit(unsigned int digit, unsigned int pos, bool upper_line) {
	char *LCD_BASE = (char *) 0x0a00;
	char *lcd;

	if((upper_line && (pos >=5 || pos == 0)) || (!upper_line && (pos >= 6 || pos ==0))) {
		/* Illegale Position */
		return;
	}

	switch(digit) {
			case 0:
				if(upper_line)  {
					pos = pos == 4 ? 5:pos;
					// Rest muss auch noch angepasst werden ...


					int offset= 0x20;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_A_U + SEGMENT_B_U + SEGMENT_C_U + SEGMENT_D_U + SEGMENT_E_U + SEGMENT_F_U;
				}
				else {
					int offset= 0x26;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_A_L + SEGMENT_B_L + SEGMENT_C_L + SEGMENT_D_L + SEGMENT_E_L + SEGMENT_F_L;
				}
				break;
			case 1:
				if(upper_line)  {
					pos = pos == 4 ? 5:pos;
					// Rest muss auch noch angepasst werden ...


					int offset= 0x20;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_B_U + SEGMENT_C_U;
				}
				else {
					int offset= 0x26;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_B_L + SEGMENT_C_L;
				}

				break;
			case 2:
				if(upper_line)  {
					pos = pos == 4 ? 5:pos;
					// Rest muss auch noch angepasst werden ...


					int offset= 0x20;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_A_U + SEGMENT_B_U + SEGMENT_D_U + SEGMENT_E_U + SEGMENT_G_U;
				}
				else {
					int offset= 0x26;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_A_L + SEGMENT_B_L + SEGMENT_D_L + SEGMENT_E_L + SEGMENT_G_L;
				}
				break;
			case 3:
				if(upper_line)  {
					pos = pos == 4 ? 5:pos;
					// Rest muss auch noch angepasst werden ...


					int offset= 0x20;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_A_U + SEGMENT_B_U + SEGMENT_C_U + SEGMENT_D_U + SEGMENT_G_U;
				}
				else {
					int offset= 0x26;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_A_L + SEGMENT_B_L + SEGMENT_C_L + SEGMENT_D_L + SEGMENT_G_L;
				}
				break;
			case 4:
				if(upper_line)  {
					pos = pos == 4 ? 5:pos;
					// Rest muss auch noch angepasst werden ...


					int offset= 0x20;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_B_U + SEGMENT_C_U + SEGMENT_F_U + SEGMENT_G_U;
				}
				else {
					int offset= 0x26;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_B_L + SEGMENT_C_L + SEGMENT_F_L + SEGMENT_G_L;
				}
				break;
			case 5:
				if(upper_line)  {
					pos = pos == 4 ? 5:pos;
					// Rest muss auch noch angepasst werden ...


					int offset= 0x20;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_A_U + SEGMENT_C_U + SEGMENT_D_U + SEGMENT_F_U + SEGMENT_G_U;
				}
				else {
					int offset= 0x26;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_A_L + SEGMENT_C_L + SEGMENT_D_L + SEGMENT_F_L + SEGMENT_G_L;
				}
				break;
			case 6:
				if(upper_line)  {
					pos = pos == 4 ? 5:pos;
					// Rest muss auch noch angepasst werden ...


					int offset= 0x20;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_A_U + SEGMENT_C_U + SEGMENT_D_U + SEGMENT_E_U + SEGMENT_F_U + SEGMENT_G_U;
				}
				else {
					int offset= 0x26;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_A_L + SEGMENT_C_L + SEGMENT_D_L + SEGMENT_E_L + SEGMENT_F_L + SEGMENT_G_L;
				}
				break;
			case 7:
				if(upper_line)  {
					pos = pos == 4 ? 5:pos;
					// Rest muss auch noch angepasst werden ...


					int offset= 0x20;
					lcd = LCD_BASE + offset + pos;
					*lcd =SEGMENT_A_U + SEGMENT_B_U + SEGMENT_C_U ;
				}
				else {
					int offset= 0x26;
					lcd = LCD_BASE + offset + pos;
					*lcd =SEGMENT_A_L + SEGMENT_B_L + SEGMENT_C_L ;
				}
				break;
			case 8:
				if(upper_line)  {
					pos = pos == 4 ? 5:pos;
					// Rest muss auch noch angepasst werden ...


					int offset= 0x20;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_A_U + SEGMENT_B_U + SEGMENT_C_U + SEGMENT_D_U + SEGMENT_E_U + SEGMENT_F_U + SEGMENT_G_U;
				}
				else {
					int offset= 0x26;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_A_L + SEGMENT_B_L + SEGMENT_C_L + SEGMENT_D_L + SEGMENT_E_L + SEGMENT_F_L + SEGMENT_G_L;
				}
				break;
			case 9:
				if(upper_line)  {
					pos = pos == 4 ? 5:pos;
					// Rest muss auch noch angepasst werden ...


					int offset= 0x20;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_A_U + SEGMENT_B_U + SEGMENT_C_U + SEGMENT_D_U + SEGMENT_F_U + SEGMENT_G_U;
				}
				else {
					int offset= 0x26;
					lcd = LCD_BASE + offset + pos;
					*lcd = SEGMENT_A_L + SEGMENT_B_L + SEGMENT_C_L + SEGMENT_D_L + SEGMENT_F_L + SEGMENT_G_L;
				}
				break;
	}
}

void LCD::show_char(const char letter, unsigned int pos, bool upper_line) {
	char *LCD_BASE = (char *) 0x0a00;
	char *lcd;

	if((upper_line && (pos >=5 || pos == 0)) || (!upper_line && (pos >= 6 || pos ==0))) {
		/* Illegale Position */
		return;
	}
	switch(letter) {
	case 'a':
	case 'A':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_U + SEGMENT_B_U + SEGMENT_C_U + SEGMENT_E_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_L + SEGMENT_B_L + SEGMENT_C_L + SEGMENT_E_L + SEGMENT_F_L + SEGMENT_G_L;
		}
		break;
	case 'b':
	case 'B':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_C_U + SEGMENT_D_U + SEGMENT_E_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_C_L + SEGMENT_D_L +  SEGMENT_E_L + SEGMENT_F_L + SEGMENT_G_L;
		}
		break;
	case 'c':
	case 'C':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_U + SEGMENT_D_U + SEGMENT_E_U + SEGMENT_F_U ;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_L + SEGMENT_D_L +  SEGMENT_E_L + SEGMENT_F_L;
		}
		break;
	case 'd':
	case 'D':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd =  SEGMENT_B_U + SEGMENT_C_U + SEGMENT_D_U + SEGMENT_E_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_B_L + SEGMENT_C_L + SEGMENT_D_L +  SEGMENT_E_L + SEGMENT_G_L;
		}
		break;
	case 'e':
	case 'E':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_U + SEGMENT_D_U + SEGMENT_E_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_L + SEGMENT_D_L +  SEGMENT_E_L + SEGMENT_F_L + SEGMENT_G_L;
		}
		break;
	case 'f':
	case 'F':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_U +  SEGMENT_E_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_L + SEGMENT_E_L + SEGMENT_F_L + SEGMENT_G_L;
		}
		break;
	case 'g':
	case 'G':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_U + SEGMENT_C_U + SEGMENT_D_U + SEGMENT_E_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_L + SEGMENT_C_L + SEGMENT_D_L + SEGMENT_E_L + SEGMENT_F_L + SEGMENT_G_L;
		}
		break;

	case 'h':
	case 'H':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_B_U + SEGMENT_C_U + SEGMENT_E_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_B_L + SEGMENT_C_L + SEGMENT_E_L + SEGMENT_F_L + SEGMENT_G_L;
		}
		break;

	case 'i':
	case 'I':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_B_U + SEGMENT_C_U ;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_B_L + SEGMENT_C_L ;
		}
		break;

	case 'j':
	case 'J':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_U + SEGMENT_B_U + SEGMENT_C_U + SEGMENT_D_U + SEGMENT_E_U ;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_L + SEGMENT_B_L + SEGMENT_C_L + SEGMENT_D_L + SEGMENT_E_L;
		}
		break;

	case 'k':
	case 'K':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_U + SEGMENT_B_U + SEGMENT_C_U + SEGMENT_D_U + SEGMENT_E_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_L + SEGMENT_B_L + SEGMENT_C_L + SEGMENT_D_L + SEGMENT_E_L + SEGMENT_F_L + SEGMENT_G_L;
		}
		break;
	case 'l':
	case 'L':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd =SEGMENT_D_U + SEGMENT_E_U + SEGMENT_F_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_D_L + SEGMENT_E_L + SEGMENT_F_L;
		}
		break;
	case 'm':
	case 'M':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_U + SEGMENT_B_U + SEGMENT_C_U + SEGMENT_D_U + SEGMENT_E_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_L + SEGMENT_B_L + SEGMENT_C_L + SEGMENT_D_L + SEGMENT_E_L + SEGMENT_F_L + SEGMENT_G_L;
		}
		break;
	case 'n':
	case 'N':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_C_U + SEGMENT_E_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_C_L + SEGMENT_E_L  + SEGMENT_G_L;
		}
		break;
	case 'o':
	case 'O':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_C_U + SEGMENT_D_U + SEGMENT_E_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_C_L + SEGMENT_D_L + SEGMENT_E_L + SEGMENT_G_L;
		}
		break;
	case 'p':
	case 'P':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_U + SEGMENT_B_U + SEGMENT_E_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_L + SEGMENT_B_L + SEGMENT_E_L + SEGMENT_F_L + SEGMENT_G_L;
		}
		break;
	case 'q':
	case 'Q':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_U + SEGMENT_B_U + SEGMENT_C_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_L + SEGMENT_B_L + SEGMENT_C_L + SEGMENT_F_L + SEGMENT_G_L;
		}
		break;
	case 'r':
	case 'R':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_E_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd =SEGMENT_E_L + SEGMENT_G_L;
		}
		break;
	case 's':
	case 'S':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_U +  SEGMENT_C_U + SEGMENT_D_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_L +  SEGMENT_C_L + SEGMENT_D_L  + SEGMENT_F_L + SEGMENT_G_L;
		}
		break;
	case 't':
	case 'T':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_D_U + SEGMENT_E_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_D_L + SEGMENT_E_L + SEGMENT_F_L + SEGMENT_G_L;
		}
		break;
	case 'u':
	case 'U':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd =  SEGMENT_C_U + SEGMENT_D_U + SEGMENT_E_U ;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd =  SEGMENT_C_L + SEGMENT_D_L + SEGMENT_E_L;
		}
		break;
	case 'v':
	case 'V':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_C_U + SEGMENT_D_U + SEGMENT_E_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_C_L + SEGMENT_D_L + SEGMENT_E_L;
		}
		break;
	case 'w':
	case 'W':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_U + SEGMENT_B_U + SEGMENT_C_U + SEGMENT_D_U + SEGMENT_E_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_L + SEGMENT_B_L + SEGMENT_C_L + SEGMENT_D_L + SEGMENT_E_L + SEGMENT_F_L + SEGMENT_G_L;
		}
		break;
	case 'x':
	case 'X':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd =  SEGMENT_B_U + SEGMENT_C_U + SEGMENT_E_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd =SEGMENT_B_L + SEGMENT_C_L + SEGMENT_E_L + SEGMENT_F_L + SEGMENT_G_L;
		}
		break;
	case 'y':
	case 'Y':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_B_U + SEGMENT_C_U + SEGMENT_F_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd =  SEGMENT_B_L + SEGMENT_C_L +  SEGMENT_F_L + SEGMENT_G_L;
		}
		break;
	case 'z':
	case 'Z':
		if(upper_line)  {
			pos = pos == 4 ? 5:pos;

			int offset= 0x20;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_U + SEGMENT_B_U +  SEGMENT_D_U + SEGMENT_E_U + SEGMENT_G_U;
		}
		else {
			int offset= 0x26;
			lcd = LCD_BASE + offset + pos;
			*lcd = SEGMENT_A_L + SEGMENT_B_L + SEGMENT_D_L + SEGMENT_E_L + SEGMENT_G_L;
		}
		break;


	}
}

