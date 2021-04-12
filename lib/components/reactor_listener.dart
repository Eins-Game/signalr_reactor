
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_reactor/components/reactor_event.dart';
import 'package:signalr_reactor/model/reactor_emitted_event.dart';

class ReactorListener<T> extends ChangeNotifier {
  ReactorListener({@required this.connection, @required this.emitMethodName}) {
    connection.start();
  }

  final HubConnection connection;
  final String emitMethodName;
  
  ValueChanged<ReactorEmittedEvent> onUpdate;

  List<ReactorEvent> _registeredEvents = [];
  var logger = Logger();
  
  void registerEvent(ReactorEvent event) {
    _registeredEvents.add(event);

    this.connection.on(event.eventName, (message) {
      _updateEvent(event.eventName, json.decode(message.first));
    });
  }

  void removeEvent(ReactorEvent event) {
    for (var registeredEvent in _registeredEvents) {
      if (registeredEvent.eventName == event.eventName) {
        _registeredEvents.remove(registeredEvent);
      }
    }

    this.connection.off(event.eventName);
  }

  Future<void> _updateEvent(String key, T updatedValue) async {
    _registeredEvents.forEach((element) async {
      if (element.eventName == key) {
        await element.update(updatedValue);

        if (this.onUpdate != null) {
          this.onUpdate.call(ReactorEmittedEvent(element.eventName, updatedValue));
        } else {
          logger.w("No onUpdate function registered, event thrown away.");
        }

        notifyListeners();
      }
    });
  }

  Future<void> emitEvent(dynamic value) async {
    await connection.invoke(emitMethodName, args: [value]);
  }

  Future<T> getValueOfEvent(String key) async {
    var data;

    for (var event in _registeredEvents) {
      if (event.eventName == key) {
        data = await event.getData();
      }
    }

    return data;
  }
  
}
