
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_reactor/components/reactor_event.dart';
import 'package:signalr_reactor/model/reactor_emitted_event.dart';

class ReactorListener<T> extends ChangeNotifier {
  ReactorListener({@required this.connection, @required this.emitMethodName, @required this.onUpdate}) {
    connection.start();
  }

  final HubConnection connection;
  final String emitMethodName;
  ValueChanged<ReactorEmittedEvent> onUpdate;

  List<ReactorEvent> registeredEvents = [];
  
  void registerEvent(ReactorEvent event) {
    registeredEvents.add(event);

    this.connection.on(event.eventName, (message) {
      _updateEvent(event.eventName, json.decode(message.first));
    });
  }

  void removeEvent(ReactorEvent event) {
    for (var registeredEvent in registeredEvents) {
      if (registeredEvent.eventName == event.eventName) {
        registeredEvents.remove(registeredEvent);
      }
    }

    this.connection.off(event.eventName);
  }

  Future<void> _updateEvent(String key, T updatedValue) async {
    registeredEvents.forEach((element) async {
      if (element.eventName == key) {
        await element.update(updatedValue);
        this.onUpdate.call(ReactorEmittedEvent(element.eventName, updatedValue));
        notifyListeners();
      }
    });
  }

  Future<void> emitEvent(dynamic value) async {
    await connection.invoke(emitMethodName, args: [value]);
  }

  Future<T> getValueOfEvent(String key) async {
    var data;

    for (var event in registeredEvents) {
      if (event.eventName == key) {
        data = await event.getData();
      }
    }

    return data;
  }
  
}
