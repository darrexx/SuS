/*****************************************************************************/
/* Betriebssysteme                                                           */
/*---------------------------------------------------------------------------*/
/*                                                                           */
/*                           S E M A P H O R E                               */
/*                                                                           */
/*---------------------------------------------------------------------------*/
/* Semaphore werden zur Synchronisation von Threads verwendet.               */
/*****************************************************************************/

#include "syscall/guarded_organizer.h"
#include "thread/customer.h"
#include "meeting/semaphore.h"

void Semaphore::p() {
  if (counter > 0) {
    counter--;
  } else {
    Customer *current = (Customer *)organizer.Organizer::active();

    enqueue(current);
    organizer.Organizer::block(*current, *this);
  }
}

void Semaphore::v() {
  Customer *queued = (Customer *)dequeue();

  if (queued != NULL) {
    organizer.Organizer::wakeup(*queued);
  } else {
    counter++;
  }
}

