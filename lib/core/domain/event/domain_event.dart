import 'dart:math';

/// Base contract for all in-memory domain events across bounded contexts.
///
/// Declared as `sealed` to guarantee exhaustive `switch` pattern matching.
sealed class DomainEvent {
  /// The unique identifier of this event instance.
  final String eventId;

  /// The timestamp when this event occurred.
  final DateTime occurredOn;

  /// Creates a [DomainEvent] with an optional [eventId] and [occurredOn].
  DomainEvent({String? eventId, DateTime? occurredOn})
      : eventId = eventId ?? _generateEventId(),
        occurredOn = occurredOn ?? DateTime.now();

  static String _generateEventId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final random = Random().nextInt(10000);
    return 'evt-$timestamp-$random';
  }
}

/// Event dispatched when the user switches their active workshop branch.
///
/// Listening bounded contexts can re-scope their branch data without direct
/// compile-time coupling.
final class ActiveBranchChangedEvent extends DomainEvent {
  /// The identifier of the newly selected branch.
  final String branchId;

  /// The display name of the newly selected branch.
  final String branchName;

  /// Creates an [ActiveBranchChangedEvent].
  ActiveBranchChangedEvent({
    required this.branchId,
    required this.branchName,
    super.eventId,
    super.occurredOn,
  });

  @override
  String toString() =>
      'ActiveBranchChangedEvent(branchId: $branchId, branchName: $branchName)';
}

/// Event dispatched when a user establishes an authenticated session.
final class UserLoggedInEvent extends DomainEvent {
  /// The authenticated user identifier.
  final String userId;

  /// The tenant identifier associated with the session.
  final String tenantId;

  /// The authenticated user's email address.
  final String email;

  /// The authenticated user's full name.
  final String fullName;

  /// The roles assigned to the user.
  final List<String> roles;

  /// Creates a [UserLoggedInEvent].
  UserLoggedInEvent({
    required this.userId,
    required this.tenantId,
    required this.email,
    required this.fullName,
    required this.roles,
    super.eventId,
    super.occurredOn,
  });

  @override
  String toString() =>
      'UserLoggedInEvent(userId: $userId, tenantId: $tenantId, roles: $roles)';
}

/// Event dispatched when the current user explicitly signs out.
final class UserLoggedOutEvent extends DomainEvent {
  /// The identifier of the user who signed out, if available.
  final String? userId;

  /// An optional reason describing why the sign-out occurred.
  final String? reason;

  /// Creates a [UserLoggedOutEvent].
  UserLoggedOutEvent({
    this.userId,
    this.reason,
    super.eventId,
    super.occurredOn,
  });

  @override
  String toString() =>
      'UserLoggedOutEvent(userId: $userId, reason: $reason)';
}

/// Event dispatched when the session token expires or cannot be refreshed.
final class SessionExpiredEvent extends DomainEvent {
  /// A human-readable description of why the session expired.
  final String reason;

  /// Creates a [SessionExpiredEvent].
  SessionExpiredEvent({
    this.reason = 'Session token expired or authentication was revoked.',
    super.eventId,
    super.occurredOn,
  });

  @override
  String toString() => 'SessionExpiredEvent(reason: $reason)';
}
