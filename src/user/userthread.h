#ifndef USERTHREAD_H
#define USERTHREAD_H

#include "syscall/thread.h"
#include "syscall/guarded_buzzer.h"

class UserThread : public Thread {
private:
  Guarded_Buzzer buzzer;

public:
  UserThread(void *tos) : Thread(tos) {}

  void action();

  // Diesen Thread fuer "ms" Millisekunden schlafen legen,
  // um Strom zu sparen.
  void sleep(unsigned int ms) {
    buzzer.set(ms);
    buzzer.sleep();
  }
};

extern UserThread userthread;

#endif

