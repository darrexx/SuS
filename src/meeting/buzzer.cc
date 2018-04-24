/*****************************************************************************/
/* Betriebssysteme                                                           */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/*                               B U Z Z E R                                 */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/* Mit Hilfe des "Weckers" koennen Prozesse eine bestimmte Zeit lang         */
/* schlafen und sich dann wecken lassen.                                     */
/*****************************************************************************/

#include "device/watch.h"
#include "meeting/buzzer.h"
#include "meeting/bellringer.h"
#include "syscall/guarded_organizer.h"

void Buzzer::clear() {
  bellringer.cancel(this);
  Waitingroom::clear();
}

void Buzzer::ring() {
  Customer *c;

  while ((c = static_cast<Customer *>(dequeue()))) {
    organizer.Organizer::wakeup(*c);
  }
}

void Buzzer::set(unsigned int ms) {
  buzzticks = watch.ms_to_ticks(ms);
}

void Buzzer::sleep() {
  Customer *me = (Customer *)organizer.Organizer::active();

  enqueue(me);
  bellringer.job(this, buzzticks);
  organizer.Organizer::block(*me, *this);
}

void Buzzer::remove(Customer *target) {
  Waitingroom::remove(target);
  if (head == NULL)
    bellringer.cancel(this);
}
