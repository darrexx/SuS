#ifndef THREAD_H
#define THREAD_H

#include "thread/customer.h"

/* Fehler-vermeidender Wrapper zur Deklaration
 *
 * Verwendung:
 *
 * DeclareThread(Klassenname, Instanzname, Stackgroesse)
 *
 * Legt eine Instanz namens "Instanzname" der Klasse
 * "Klassenname" an, die als Stack ein Array des
 * Namens "Instanzname_stack" übergeben bekommt.
 */
#define DeclareThread(class,name,stacksize) \
  static char name##_stack[stacksize];      \
  class name(name##_stack + stacksize);

class Thread : public Customer {
private:
  Thread(const Thread &copy);

public:
  Thread(void *tos) : Customer(tos) {}
};

#endif
