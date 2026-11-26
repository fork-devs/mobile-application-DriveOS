import 'package:mobile_application_driveos/features/fleet/domain/fleet_domain.dart';

/// Use case that manages customer affiliations to workshop branches.
class ManageCustomerRegistrations {
  final FleetRepository _repository;

  /// Creates a [ManageCustomerRegistrations] use case.
  const ManageCustomerRegistrations(this._repository);

  /// Links [customerId] to [branchId].
  Future<CustomerRegistration> register({
    required String branchId,
    required String customerId,
  }) {
    return _repository.createCustomerRegistration(
      branchId: branchId,
      customerId: customerId,
    );
  }

  /// Lists customer registrations with optional filters.
  Future<List<CustomerRegistration>> list({
    String? branchId,
    String? customerId,
    String? status,
  }) {
    return _repository.getCustomerRegistrations(
      branchId: branchId,
      customerId: customerId,
      status: status,
    );
  }

  /// Updates [registrationId] to [status].
  Future<CustomerRegistration> updateStatus({
    required String registrationId,
    required String status,
  }) {
    return _repository.updateCustomerRegistration(
      registrationId: registrationId,
      status: status.trim().toUpperCase(),
    );
  }

  /// Removes [registrationId].
  Future<void> delete(String registrationId) =>
      _repository.deleteCustomerRegistration(registrationId);
}

/// Use case that manages employee branch registrations and career history.
class ManageEmployeeRegistrations {
  final FleetRepository _repository;

  /// Creates a [ManageEmployeeRegistrations] use case.
  const ManageEmployeeRegistrations(this._repository);

  /// Directly registers [employeeId] to [branchId].
  Future<EmployeeRegistration> register({
    required String employeeId,
    required String branchId,
    required String speciality,
    required String specialityName,
    required double salary,
    required String role,
  }) {
    return _repository.createEmployeeRegistration(
      employeeId: employeeId,
      branchId: branchId,
      speciality: speciality.trim(),
      specialityName: specialityName.trim(),
      salary: salary,
      role: role.trim().toUpperCase(),
    );
  }

  /// Submits a join request for [employeeId] to [branchId].
  Future<EmployeeRegistration> requestJoin({
    required String employeeId,
    required String branchId,
    required String speciality,
    required String specialityName,
    required double salary,
  }) {
    return _repository.requestJoinBranch(
      employeeId: employeeId,
      branchId: branchId,
      speciality: speciality.trim(),
      specialityName: specialityName.trim(),
      salary: salary,
    );
  }

  /// Approves [registrationId].
  Future<EmployeeRegistration> approve(String registrationId) =>
      _repository.approveEmployeeRegistration(registrationId);

  /// Rejects [registrationId] with an optional [reason].
  Future<EmployeeRegistration> reject(
    String registrationId, {
    String? reason,
  }) {
    return _repository.rejectEmployeeRegistration(
      registrationId: registrationId,
      reason: reason?.trim(),
    );
  }

  /// Lists employee registrations with optional filters.
  Future<List<EmployeeRegistration>> list({
    String? branchId,
    String? employeeId,
    String? status,
  }) {
    return _repository.getEmployeeRegistrations(
      branchId: branchId,
      employeeId: employeeId,
      status: status,
    );
  }

  /// Updates specialty and salary for [registrationId].
  Future<EmployeeRegistration> update({
    required String registrationId,
    required String speciality,
    required String specialityName,
    required double salary,
  }) {
    return _repository.updateEmployeeRegistration(
      registrationId: registrationId,
      speciality: speciality.trim(),
      specialityName: specialityName.trim(),
      salary: salary,
    );
  }

  /// Deletes [registrationId].
  Future<void> delete(String registrationId) =>
      _repository.deleteEmployeeRegistration(registrationId);

  /// Fetches career history for [employeeId] in [branchId].
  Future<List<StaffCareerHistoryEntry>> getCareerHistory({
    required String branchId,
    required String employeeId,
  }) {
    return _repository.getStaffCareerHistory(
      branchId: branchId,
      employeeId: employeeId,
    );
  }
}
