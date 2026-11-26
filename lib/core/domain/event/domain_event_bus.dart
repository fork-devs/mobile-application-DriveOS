import 'dart:async';

import 'package:mobile_application_driveos/core/domain/event/domain_event.dart';

/// Central in-memory event bus for cross-context [DomainEvent] communication.
///
/// Enables sibling bounded contexts to publish and subscribe to events without
/// direct compile-time coupling.
abstract interface class DomainEventBus {
  /// Publishes [event] to all active subscribers.
  void emit(DomainEvent event);

  /// Returns a broadcast [Stream] filtered for events of type [T].
  Stream<T> on<T extends DomainEvent>();

  /// Closes internal stream controllers and releases resources.
  Future<void> dispose();
}
