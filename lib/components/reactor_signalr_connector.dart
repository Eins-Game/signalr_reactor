import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_reactor/components/reactor_listener.dart';
import 'package:signalr_reactor/extensions/hub_connection_extension.dart';

class ReactorSignalrConnector extends HubConnectionBuilder {
  var logger = Logger();

  static ReactorSignalrConnector createConnector({@required String url, HttpConnectionOptions options}) {
    HttpConnectionOptions currentOptions = HttpConnectionOptions(
      logging: (level, message) => logger.d(message)
    );

    if (options != null) {
      currentOptions = options;
    }

    return HubConnectionBuilder().withUrl(url, currentOptions).withHubProtocol(JsonHubProtocol());
  }

  HubConnection connect() {
    return this.build();
  }

  ReactorListener<T> connectToReactorListener<T>(String emitMethodName) {
    return this.build().convertToReactor(emitMethodName);
  }
}
