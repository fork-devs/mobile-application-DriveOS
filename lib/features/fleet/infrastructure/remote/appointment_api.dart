import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/fleet/infrastructure/remote/dtos/fleet_dto.dart';

/// HTTP client for `erp-fleet-service` appointment endpoints.
class AppointmentApi {
  final ApiClient _apiClient;

  /// Creates an [AppointmentApi] backed by [_apiClient].
  const AppointmentApi(this._apiClient);

  /// Creates a new appointment.
  Future<AppointmentDto> createAppointment({
    required String branchId,
    required String customerId,
    required String vehicleId,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    String? notes,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.appointments,
      body: {
        'branchId': branchId,
        'customerId': customerId,
        'vehicleId': vehicleId,
        'scheduledStart': scheduledStart.toUtc().toIso8601String(),
        'scheduledEnd': scheduledEnd.toUtc().toIso8601String(),
        'notes': ?notes,
      },
    );
    return AppointmentDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists appointments filtered optionally by branch, customer, vehicle, or
  /// status.
  Future<List<AppointmentDto>> getAppointments({
    String? branchId,
    String? customerId,
    String? vehicleId,
    String? status,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.appointments,
      queryParameters: {
        'branchId': ?branchId,
        'customerId': ?customerId,
        'vehicleId': ?vehicleId,
        'status': ?status,
      },
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => AppointmentDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetches a single appointment by [appointmentId].
  Future<AppointmentDto> getAppointmentById(String appointmentId) async {
    final response = await _apiClient.get(
      ApiConstants.appointmentById(appointmentId),
    );
    return AppointmentDto.fromJson(response as Map<String, dynamic>);
  }

  /// Updates an existing appointment.
  Future<AppointmentDto> updateAppointment({
    required String appointmentId,
    required String branchId,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    String? notes,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.appointmentById(appointmentId),
      body: {
        'branchId': branchId,
        'scheduledStart': scheduledStart.toUtc().toIso8601String(),
        'scheduledEnd': scheduledEnd.toUtc().toIso8601String(),
        'notes': ?notes,
      },
    );
    return AppointmentDto.fromJson(response as Map<String, dynamic>);
  }

  /// Confirms [appointmentId].
  Future<AppointmentDto> confirmAppointment(String appointmentId) async {
    final response = await _apiClient.post(
      ApiConstants.appointmentConfirm(appointmentId),
    );
    return AppointmentDto.fromJson(response as Map<String, dynamic>);
  }

  /// Records check-in for [appointmentId].
  Future<AppointmentDto> checkInAppointment(String appointmentId) async {
    final response = await _apiClient.post(
      ApiConstants.appointmentCheckIn(appointmentId),
    );
    return AppointmentDto.fromJson(response as Map<String, dynamic>);
  }

  /// Completes [appointmentId].
  Future<AppointmentDto> completeAppointment(String appointmentId) async {
    final response = await _apiClient.post(
      ApiConstants.appointmentComplete(appointmentId),
    );
    return AppointmentDto.fromJson(response as Map<String, dynamic>);
  }

  /// Cancels [appointmentId] with an optional [reason].
  Future<AppointmentDto> cancelAppointment({
    required String appointmentId,
    String? reason,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.appointmentCancel(appointmentId),
      body: reason != null ? {'reason': reason} : null,
    );
    return AppointmentDto.fromJson(response as Map<String, dynamic>);
  }

  /// Deletes [appointmentId].
  Future<void> deleteAppointment(String appointmentId) async {
    await _apiClient.delete(ApiConstants.appointmentById(appointmentId));
  }
}
