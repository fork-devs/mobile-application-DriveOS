import 'package:mobile_application_driveos/features/fleet/domain/fleet_domain.dart';
import 'package:mobile_application_driveos/features/fleet/infrastructure/remote/appointment_api.dart';
import 'package:mobile_application_driveos/features/fleet/infrastructure/remote/customer_vehicle_api.dart';
import 'package:mobile_application_driveos/features/fleet/infrastructure/remote/registration_api.dart';

/// Concrete [FleetRepository] backed by remote `erp-fleet-service` APIs.
class FleetRepositoryImpl implements FleetRepository {
  final AppointmentApi _appointmentApi;
  final CustomerVehicleApi _customerVehicleApi;
  final RegistrationApi _registrationApi;

  /// Creates a [FleetRepositoryImpl].
  const FleetRepositoryImpl({
    required this._appointmentApi,
    required this._customerVehicleApi,
    required this._registrationApi,
  });

  @override
  Future<Appointment> createAppointment({
    required String branchId,
    required String customerId,
    required String vehicleId,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    String? notes,
  }) async {
    final dto = await _appointmentApi.createAppointment(
      branchId: branchId,
      customerId: customerId,
      vehicleId: vehicleId,
      scheduledStart: scheduledStart,
      scheduledEnd: scheduledEnd,
      notes: notes,
    );
    return dto.toDomain();
  }

  @override
  Future<List<Appointment>> getAppointments({
    String? branchId,
    String? customerId,
    String? vehicleId,
    String? status,
  }) async {
    final dtos = await _appointmentApi.getAppointments(
      branchId: branchId,
      customerId: customerId,
      vehicleId: vehicleId,
      status: status,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Appointment> getAppointmentById(String appointmentId) async {
    final dto = await _appointmentApi.getAppointmentById(appointmentId);
    return dto.toDomain();
  }

  @override
  Future<Appointment> updateAppointment({
    required String appointmentId,
    required String branchId,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    String? notes,
  }) async {
    final dto = await _appointmentApi.updateAppointment(
      appointmentId: appointmentId,
      branchId: branchId,
      scheduledStart: scheduledStart,
      scheduledEnd: scheduledEnd,
      notes: notes,
    );
    return dto.toDomain();
  }

  @override
  Future<Appointment> confirmAppointment(String appointmentId) async {
    final dto = await _appointmentApi.confirmAppointment(appointmentId);
    return dto.toDomain();
  }

  @override
  Future<Appointment> checkInAppointment(String appointmentId) async {
    final dto = await _appointmentApi.checkInAppointment(appointmentId);
    return dto.toDomain();
  }

  @override
  Future<Appointment> completeAppointment(String appointmentId) async {
    final dto = await _appointmentApi.completeAppointment(appointmentId);
    return dto.toDomain();
  }

  @override
  Future<Appointment> cancelAppointment({
    required String appointmentId,
    String? reason,
  }) async {
    final dto = await _appointmentApi.cancelAppointment(
      appointmentId: appointmentId,
      reason: reason,
    );
    return dto.toDomain();
  }

  @override
  Future<void> deleteAppointment(String appointmentId) =>
      _appointmentApi.deleteAppointment(appointmentId);

  @override
  Future<Customer> createCustomer({
    required String fullName,
    required String email,
    required String phone,
    required String docType,
    required String docNumber,
  }) async {
    final dto = await _customerVehicleApi.createCustomer(
      fullName: fullName,
      email: email,
      phone: phone,
      docType: docType,
      docNumber: docNumber,
    );
    return dto.toDomain();
  }

  @override
  Future<Customer> getCustomerById(String customerId) async {
    final dto = await _customerVehicleApi.getCustomerById(customerId);
    return dto.toDomain();
  }

  @override
  Future<List<Customer>> getCustomers() async {
    final dtos = await _customerVehicleApi.getCustomers();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Customer> updateCustomer({
    required String customerId,
    required String fullName,
    required String email,
    required String phone,
  }) async {
    final dto = await _customerVehicleApi.updateCustomer(
      customerId: customerId,
      fullName: fullName,
      email: email,
      phone: phone,
    );
    return dto.toDomain();
  }

  @override
  Future<void> deleteCustomer(String customerId) =>
      _customerVehicleApi.deleteCustomer(customerId);

  @override
  Future<void> validateCustomer(String customerId) =>
      _customerVehicleApi.validateCustomer(customerId);

  @override
  Future<List<Vehicle>> getCustomerVehicles(String customerId) async {
    final dtos = await _customerVehicleApi.getCustomerVehicles(customerId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Vehicle> createVehicle({
    required String customerId,
    required String plate,
    required String brand,
    required String model,
    required int year,
    required String vin,
  }) async {
    final dto = await _customerVehicleApi.createVehicle(
      customerId: customerId,
      plate: plate,
      brand: brand,
      model: model,
      year: year,
      vin: vin,
    );
    return dto.toDomain();
  }

  @override
  Future<Vehicle> getVehicleById(String vehicleId) async {
    final dto = await _customerVehicleApi.getVehicleById(vehicleId);
    return dto.toDomain();
  }

  @override
  Future<List<Vehicle>> getVehicles() async {
    final dtos = await _customerVehicleApi.getVehicles();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<Vehicle>> getVehiclesByCustomer(String customerId) async {
    final dtos = await _customerVehicleApi.getVehiclesByCustomer(customerId);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Vehicle> updateVehicle({
    required String vehicleId,
    required String brand,
    required String model,
    required int year,
    required String vin,
  }) async {
    final dto = await _customerVehicleApi.updateVehicle(
      vehicleId: vehicleId,
      brand: brand,
      model: model,
      year: year,
      vin: vin,
    );
    return dto.toDomain();
  }

  @override
  Future<void> deleteVehicle(String vehicleId) =>
      _customerVehicleApi.deleteVehicle(vehicleId);

  @override
  Future<void> validateVehicle(String vehicleId) =>
      _customerVehicleApi.validateVehicle(vehicleId);

  @override
  Future<Vehicle> uploadVehicleImage({
    required String vehicleId,
    required String filePath,
  }) async {
    final dto = await _customerVehicleApi.uploadVehicleImage(
      vehicleId: vehicleId,
      filePath: filePath,
    );
    return dto.toDomain();
  }

  @override
  Future<CustomerRegistration> createCustomerRegistration({
    required String branchId,
    required String customerId,
  }) async {
    final dto = await _registrationApi.createCustomerRegistration(
      branchId: branchId,
      customerId: customerId,
    );
    return dto.toDomain();
  }

  @override
  Future<List<CustomerRegistration>> getCustomerRegistrations({
    String? branchId,
    String? customerId,
    String? status,
  }) async {
    final dtos = await _registrationApi.getCustomerRegistrations(
      branchId: branchId,
      customerId: customerId,
      status: status,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<CustomerRegistration> updateCustomerRegistration({
    required String registrationId,
    required String status,
  }) async {
    final dto = await _registrationApi.updateCustomerRegistration(
      registrationId: registrationId,
      status: status,
    );
    return dto.toDomain();
  }

  @override
  Future<void> deleteCustomerRegistration(String registrationId) =>
      _registrationApi.deleteCustomerRegistration(registrationId);

  @override
  Future<EmployeeRegistration> createEmployeeRegistration({
    required String employeeId,
    required String branchId,
    required String speciality,
    required String specialityName,
    required double salary,
    required String role,
  }) async {
    final dto = await _registrationApi.createEmployeeRegistration(
      employeeId: employeeId,
      branchId: branchId,
      speciality: speciality,
      specialityName: specialityName,
      salary: salary,
      role: role,
    );
    return dto.toDomain();
  }

  @override
  Future<EmployeeRegistration> requestJoinBranch({
    required String employeeId,
    required String branchId,
    required String speciality,
    required String specialityName,
    required double salary,
  }) async {
    final dto = await _registrationApi.requestJoinBranch(
      employeeId: employeeId,
      branchId: branchId,
      speciality: speciality,
      specialityName: specialityName,
      salary: salary,
    );
    return dto.toDomain();
  }

  @override
  Future<EmployeeRegistration> approveEmployeeRegistration(
    String registrationId,
  ) async {
    final dto = await _registrationApi.approveEmployeeRegistration(
      registrationId,
    );
    return dto.toDomain();
  }

  @override
  Future<EmployeeRegistration> rejectEmployeeRegistration({
    required String registrationId,
    String? reason,
  }) async {
    final dto = await _registrationApi.rejectEmployeeRegistration(
      registrationId: registrationId,
      reason: reason,
    );
    return dto.toDomain();
  }

  @override
  Future<List<EmployeeRegistration>> getEmployeeRegistrations({
    String? branchId,
    String? employeeId,
    String? status,
  }) async {
    final dtos = await _registrationApi.getEmployeeRegistrations(
      branchId: branchId,
      employeeId: employeeId,
      status: status,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<EmployeeRegistration> updateEmployeeRegistration({
    required String registrationId,
    required String speciality,
    required String specialityName,
    required double salary,
  }) async {
    final dto = await _registrationApi.updateEmployeeRegistration(
      registrationId: registrationId,
      speciality: speciality,
      specialityName: specialityName,
      salary: salary,
    );
    return dto.toDomain();
  }

  @override
  Future<void> deleteEmployeeRegistration(String registrationId) =>
      _registrationApi.deleteEmployeeRegistration(registrationId);

  @override
  Future<List<StaffCareerHistoryEntry>> getStaffCareerHistory({
    required String branchId,
    required String employeeId,
  }) async {
    final dtos = await _registrationApi.getStaffCareerHistory(
      branchId: branchId,
      employeeId: employeeId,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
