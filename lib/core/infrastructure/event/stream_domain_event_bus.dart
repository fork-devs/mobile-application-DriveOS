import 'dart:async';

import 'package:mobile_application_driveos/core/domain/event/domain_event.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event_bus.dart';

/// In-memory implementation of [DomainEventBus] backed by a broadcast [Stream].
class StreamDomainEventBus implements DomainEventBus {
  final StreamController<DomainEvent> _controller;

  /// Creates a [StreamDomainEventBus] with an optional custom [controller].
  StreamDomainEventBus({StreamController<DomainEvent>? controller})
      : _controller = controller ?? StreamController<DomainEvent>.broadcast();

  @override
  void emit(DomainEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  @override
  Stream<T> on<T extends DomainEvent>() {
    return _controller.stream.where((event) => event is T).cast<T>();
  }

  @override
  Future<void> dispose() async {
    if (!_controller.isClosed) {
      await _controller.close();
    }
  }
}
