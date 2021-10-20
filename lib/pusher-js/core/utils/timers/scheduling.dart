@JS()
library core.utils.timers.scheduling;

import "package:js/js.dart";

typedef num Scheduler(TimedCallback, number);
typedef void Canceller(number); /*export type Delay = number;*/
