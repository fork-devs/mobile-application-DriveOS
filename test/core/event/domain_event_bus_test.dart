import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event.dart';
import 'package:mobile_application_driveos/core/infrastructure/event/stream_domain_event_bus.dart';

void main() {
  group('StreamDomainEventBus', () {
    test('delivers typed domain events to matching subscribers', () async {
      final bus = StreamDomainEventBus();
      final received = <ActiveBranchChangedEvent>[];

      final subscription = bus.on<ActiveBranchChangedEvent>().listen(
            received.add,
          );

      bus.emit(
        UserLoggedInEvent(
          userId: 'u-1',
          tenantId: 't-1',
          email: 'admin@driveos.pe',
          fullName: 'Test Admin',
          roles: ['WORKSHOP_ADMIN'],
        ),
      );
      bus.emit(
        ActiveBranchChangedEvent(
          branchId: 'b-1',
          branchName: 'Main Branch',
        ),
      );

      await Future<void>.delayed(Duration.zero);

      expect(received, hasLength(1));
      expect(received.first.branchId, 'b-1');
      expect(received.first.branchName, 'Main Branch');

      await subscription.cancel();
      await bus.dispose();
    });

    test('ignores emitted events after dispose', () async {
      final bus = StreamDomainEventBus();
      await bus.dispose();

      expect(
        () => bus.emit(SessionExpiredEvent()),
        returnsNormally,
      );
    });
  });
}
