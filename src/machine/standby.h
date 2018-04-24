#pragma once

#include "guard/gate.h"

class StandbyMode : public Gate {
private:
  StandbyMode(const StandbyMode &copy);
  // Solange schlafen, wie dieses flag nicht gesetzt ist
  volatile bool running;
public:
  StandbyMode();
  void activate();
  
  // check BSL button and reboot if running=true
  bool prologue();

  enum { LIGHT = (1<<3) };
};

extern StandbyMode standbyMode;

