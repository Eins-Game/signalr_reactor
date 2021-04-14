// Just a shim
class ReactorEmittedEvent<T> {
  ReactorEmittedEvent(this.eventName, this.value);

  String eventName;
  T value;
}
