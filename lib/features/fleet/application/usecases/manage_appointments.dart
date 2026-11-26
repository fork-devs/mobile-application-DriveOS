import 'package:mobile_application_driveos/features/fleet/domain/fleet_domain.dart';

/// Use case that schedules a new workshop appointment.
class CreateAppointment {
  final FleetRepository _repository;

  /// Creates a [CreateAppointment] use case.
  const CreateAppointment(this._repository);

  /// Schedules an appointment for [vehicleId] at [branchId].
  Future<Appointment> call({
    required String branchId,
    required String customerId,
    required String vehicleId,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    String? notes,
  }) {
    return _repository.createAppointment(
      branchId: branchId,
      customerId: customerId,
      vehicleId: vehicleId,
      scheduledStart: scheduledStart,
      scheduledEnd: scheduledEnd,
      notes: notes?.trim(),
    );
  }
}

/// Use case that lists appointments with optional filters.
class GetAppointments {
  final FleetRepository _repository;

  /// Creates a [GetAppointments] use case.
  const GetAppointments(this._repository);

  /// Returns appointments matching the supplied optional filters.
  Future<List<Appointment>> call({
    String? branchId,
    String? customerId,
    String? vehicleId,
    String? status,
  }) {
    return _repository.getAppointments(
      branchId: branchId,
      customerId: customerId,
      vehicleId: vehicleId,
      status: status,
    );
  }
}

/// Use case that retrieves a single appointment by identifier.
class GetAppointmentById {
  final FleetRepository _repository;

  /// Creates a [GetAppointmentById] use case.
  const GetAppointmentById(this._repository);

  /// Returns the [Appointment] matching [appointmentId].
  Future<Appointment> call(String appointmentId) =>
      _repository.getAppointmentById(appointmentId);
}

/// Use case that updates an appointment's branch, schedule, or notes.
class UpdateAppointment {
  final FleetRepository _repository;

  /// Creates an [UpdateAppointment] use case.
  const UpdateAppointment(this._repository);

  /// Updates [appointmentId] with the new schedule details.
  Future<Appointment> call({
    required String appointmentId,
    required String branchId,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    String? notes,
  }) {
    return _repository.updateAppointment(
      appointmentId: appointmentId,
      branchId: branchId,
      scheduledStart: scheduledStart,
      scheduledEnd: scheduledEnd,
      notes: notes?.trim(),
    );
  }
}

/// Use case that transitions an appointment through lifecycle states.
class ManageAppointmentLifecycle {
  final FleetRepository _repository;

  /// Creates a [ManageAppointmentLifecycle] use case.
  const ManageAppointmentLifecycle(this._repository);

  /// Confirms [appointmentId].
  Future<Appointment> confirm(String appointmentId) =>
      _repository.confirmAppointment(appointmentId);

  /// Records check-in for [appointmentId].
  Future<Appointment> checkIn(String appointmentId) =>
      _repository.checkInAppointment(appointmentId);

  /// Marks [appointmentId] as completed.
  Future<Appointment> complete(String appointmentId) =>
      _repository.completeAppointment(appointmentId);

  /// Cancels [appointmentId] with an optional [reason].
  Future<Appointment> cancel(String appointmentId, {String? reason}) =>
      _repository.cancelAppointment(
        appointmentId: appointmentId,
        reason: reason?.trim(),
      );

  /// Deletes [appointmentId].
  Future<void> delete(String appointmentId) =>
      _repository.deleteAppointment(appointmentId);
}
