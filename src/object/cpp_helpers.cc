#include "device/panic.h"

extern "C" void __cxa_pure_virtual(void);

void operator delete(void *ptr) throw() {}
void operator delete(void*, unsigned int) throw() {}

void __cxa_pure_virtual(void) {
  panic.panic(PANIC_PUREVIRTUAL);
}
