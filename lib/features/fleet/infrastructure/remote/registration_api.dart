import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/fleet/infrastructure/remote/dtos/fleet_dto.dart';

/// HTTP client for `erp-fleet-service` customer/employee registrations and
/// career history.
class RegistrationApi {
  final ApiClient _apiClient;

  /// Creates a [RegistrationApi] backed by [_apiClient].
  const RegistrationApi(this._apiClient);

  /// Links [customerId] to [branchId].
  Future<CustomerRegistrationDto> createCustomerRegistration({
    required String branchId,
    required String customerId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.customerRegistrations,
      body: {
        'branchId': branchId,
        'customerId': customerId,
      },
    );
    return CustomerRegistrationDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists customer registrations with optional filters.
  Future<List<CustomerRegistrationDto>> getCustomerRegistrations({
    String? branchId,
    String? customerId,
    String? status,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.customerRegistrations,
      queryParameters: {
        'branchId': ?branchId,
        'customerId': ?customerId,
        'status': ?status,
      },
    );
    final list = response as List<dynamic>;
    return list
        .map(
          (item) =>
              CustomerRegistrationDto.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Updates a customer registration's [status].
  Future<CustomerRegistrationDto> updateCustomerRegistration({
    required String registrationId,
    required String status,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.customerRegistrationById(registrationId),
      body: {'status': status},
    );
    return CustomerRegistrationDto.fromJson(response as Map<String, dynamic>);
  }

  /// Deletes a customer registration by [registrationId].
  Future<void> deleteCustomerRegistration(String registrationId) async {
    await _apiClient.delete(
      ApiConstants.customerRegistrationById(registrationId),
    );
  }

  /// Directly registers an employee to [branchId].
  Future<EmployeeRegistrationDto> createEmployeeRegistration({
    required String employeeId,
    required String branchId,
    required String speciality,
    required String specialityName,
    required double salary,
    required String role,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.employeeRegistrations,
      body: {
        'employeeId': employeeId,
        'branchId': branchId,
        'speciality': speciality,
        'specialityName': specialityName,
        'salary': salary,
        'role': role,
      },
    );
    return EmployeeRegistrationDto.fromJson(response as Map<String, dynamic>);
  }

  /// Submits an employee join request to [branchId].
  Future<EmployeeRegistrationDto> requestJoinBranch({
    required String employeeId,
    required String branchId,
    required String speciality,
    required String specialityName,
    required double salary,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.employeeRegistrationRequestJoin,
      body: {
        'employeeId': employeeId,
        'branchId': branchId,
        'speciality': speciality,
        'specialityName': specialityName,
        'salary': salary,
      },
    );
    return EmployeeRegistrationDto.fromJson(response as Map<String, dynamic>);
  }

  /// Approves [registrationId].
  Future<EmployeeRegistrationDto> approveEmployeeRegistration(
    String registrationId,
  ) async {
    final response = await _apiClient.post(
      ApiConstants.employeeRegistrationApprove(registrationId),
    );
    return EmployeeRegistrationDto.fromJson(response as Map<String, dynamic>);
  }

  /// Rejects [registrationId] with an optional [reason].
  Future<EmployeeRegistrationDto> rejectEmployeeRegistration({
    required String registrationId,
    String? reason,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.employeeRegistrationReject(registrationId),
      body: reason != null ? {'reason': reason} : null,
    );
    return EmployeeRegistrationDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists employee registrations with optional filters.
  Future<List<EmployeeRegistrationDto>> getEmployeeRegistrations({
    String? branchId,
    String? employeeId,
    String? status,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.employeeRegistrations,
      queryParameters: {
        'branchId': ?branchId,
        'employeeId': ?employeeId,
        'status': ?status,
      },
    );
    final list = response as List<dynamic>;
    return list
        .map(
          (item) =>
              EmployeeRegistrationDto.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Updates specialty and salary for [registrationId].
  Future<EmployeeRegistrationDto> updateEmployeeRegistration({
    required String registrationId,
    required String speciality,
    required String specialityName,
    required double salary,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.employeeRegistrationById(registrationId),
      body: {
        'speciality': speciality,
        'specialityName': specialityName,
        'salary': salary,
      },
    );
    return EmployeeRegistrationDto.fromJson(response as Map<String, dynamic>);
  }

  /// Deletes an employee registration by [registrationId].
  Future<void> deleteEmployeeRegistration(String registrationId) async {
    await _apiClient.delete(
      ApiConstants.employeeRegistrationById(registrationId),
    );
  }

  /// Fetches career history for [employeeId] in [branchId].
  Future<List<StaffCareerHistoryEntryDto>> getStaffCareerHistory({
    required String branchId,
    required String employeeId,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.branchEmployeeHistory(branchId, employeeId),
    );
    final list = response as List<dynamic>;
    return list
        .map(
          (item) => StaffCareerHistoryEntryDto.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}
