import 'package:flutter/foundation.dart';

class ReactorEvent<T> {
  ReactorEvent({@required this.eventName, this.onDataChanged});

  String eventName;

  final ValueChanged<T> onDataChanged;

  T _data;

  Future<void> update(T value) async {
    _data = value;

  }

  Future<T> getData() async {
    return _data;
  }


}
