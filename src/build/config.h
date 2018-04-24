// autoconf.h generated from config
#ifndef AUTOCONF_H
#define AUTOCONF_H
// UART an Pin schalten?
//CONFIG_UART_DEBUG=y

// Log2 der UART-Buffer-Groesse
#define CONFIG_UART_BUF_SHIFT 6

// UART-Baudrate
#define CONFIG_UART_BAUDRATE 4800

// Deadlocks beim Schreiben erlauben
// (d.h. warten auf freien Platz im Puffer)
#define CONFIG_UART_CAN_DEADLOCK

// Ausgabe mit Polling statt ISR?
//CONFIG_UART_POLLED=y

// CPU-Frequenz in Hz
// Der FLL-Multiplikator wird aus diesem Wert berechnet
#define CONFIG_CPU_FREQUENCY 12000000

// Aspekte verwenden
#define CONFIG_ASPECTS
#endif
