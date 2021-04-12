import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:signalr_reactor/components/reactor_listener.dart';
import 'package:signalr_reactor/widget/reactor_widget_builder.dart';

class ReactorWidget<T> extends StatefulWidget {
  ReactorWidget({Key key, @required this.listener, @required this.builder, this.filterEvents}) : super(key: key);

  final ReactorListener<T> listener;
  final ReactorWidgetBuilder<T> builder;
  final List<String> filterEvents;

  @override
  _ReactorWidgetState<T> createState() => _ReactorWidgetState();
}

class _ReactorWidgetState<T> extends State<ReactorWidget> {

  T accessibleValue;

  var logger = Logger();

  @override
  void initState() {
    super.initState();

    if (widget.listener.onUpdate != null) {
      logger.w("Your onUpdate function will be overridden. For onChange listening, attach a listener to your ReactorListener.");
    }

    widget.listener.onUpdate = (emittedEvent) {
      if (widget.filterEvents != null) {
        widget.filterEvents.forEach((filter) {
          if (emittedEvent.eventName == filter) {
            setState(() {
              accessibleValue = emittedEvent.value;
            });
          }
        });
      } else {
        setState(() {
          accessibleValue = emittedEvent.value;
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, accessibleValue);
  }
}
