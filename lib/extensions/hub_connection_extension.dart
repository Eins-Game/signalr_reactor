import 'package:signalr_core/signalr_core.dart';
import 'package:signalr_reactor/components/reactor_listener.dart';

extension HubConnectionExtension on HubConnection {
  ReactorListener convertToReactor(String emitMethodName) => ReactorListener(connection: this, emitMethodName: emitMethodName);
}
