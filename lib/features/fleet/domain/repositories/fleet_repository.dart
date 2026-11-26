import 'package:mobile_application_driveos/features/fleet/domain/model/entities/appointment.dart';
import 'package:mobile_application_driveos/features/fleet/domain/model/entities/customer.dart';
import 'package:mobile_application_driveos/features/fleet/domain/model/entities/registrations.dart';
import 'package:mobile_application_driveos/features/fleet/domain/model/entities/vehicle.dart';

/// Output port defining fleet, appointment, customer, vehicle, and
/// registration operations.
abstract interface class FleetRepository {
  // Appointments
  /// Schedules a new appointment.
  Future<Appointment> createAppointment({
    required String branchId,
    required String customerId,
    required String vehicleId,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    String? notes,
  });

  /// Lists appointments filtered optionally by branch, customer, vehicle, or
  /// status.
  Future<List<Appointment>> getAppointments({
    String? branchId,
    String? customerId,
    String? vehicleId,
    String? status,
  });

  /// Fetches a single appointment by [appointmentId].
  Future<Appointment> getAppointmentById(String appointmentId);

  /// Updates an existing appointment's branch, schedule, or notes.
  Future<Appointment> updateAppointment({
    required String appointmentId,
    required String branchId,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
    String? notes,
  });

  /// Confirms an appointment by [appointmentId].
  Future<Appointment> confirmAppointment(String appointmentId);

  /// Records customer/vehicle check-in for [appointmentId].
  Future<Appointment> checkInAppointment(String appointmentId);

  /// Marks [appointmentId] as completed.
  Future<Appointment> completeAppointment(String appointmentId);

  /// Cancels [appointmentId] with an optional [reason].
  Future<Appointment> cancelAppointment({
    required String appointmentId,
    String? reason,
  });

  /// Deletes an appointment by [appointmentId].
  Future<void> deleteAppointment(String appointmentId);

  // Customers
  /// Registers a new customer within the active tenant.
  Future<Customer> createCustomer({
    required String fullName,
    required String email,
    required String phone,
    required String docType,
    required String docNumber,
  });

  /// Fetches a customer by [customerId].
  Future<Customer> getCustomerById(String customerId);

  /// Lists all customers in the active tenant.
  Future<List<Customer>> getCustomers();

  /// Updates a customer's contact details.
  Future<Customer> updateCustomer({
    required String customerId,
    required String fullName,
    required String email,
    required String phone,
  });

  /// Deletes a customer by [customerId].
  Future<void> deleteCustomer(String customerId);

  /// Triggers identity revalidation for [customerId].
  Future<void> validateCustomer(String customerId);

  /// Lists vehicles belonging to [customerId] via the customer resource.
  Future<List<Vehicle>> getCustomerVehicles(String customerId);

  // Vehicles
  /// Registers a new vehicle for [customerId].
  Future<Vehicle> createVehicle({
    required String customerId,
    required String plate,
    required String brand,
    required String model,
    required int year,
    required String vin,
  });

  /// Fetches a vehicle by [vehicleId].
  Future<Vehicle> getVehicleById(String vehicleId);

  /// Lists all vehicles in the active tenant.
  Future<List<Vehicle>> getVehicles();

  /// Lists vehicles owned by [customerId].
  Future<List<Vehicle>> getVehiclesByCustomer(String customerId);

  /// Updates vehicle metadata for [vehicleId].
  Future<Vehicle> updateVehicle({
    required String vehicleId,
    required String brand,
    required String model,
    required int year,
    required String vin,
  });

  /// Deletes a vehicle by [vehicleId].
  Future<void> deleteVehicle(String vehicleId);

  /// Triggers plate/VIN revalidation for [vehicleId].
  Future<void> validateVehicle(String vehicleId);

  /// Uploads a photo at [filePath] for [vehicleId].
  Future<Vehicle> uploadVehicleImage({
    required String vehicleId,
    required String filePath,
  });

  // Customer Registrations
  /// Links [customerId] to [branchId].
  Future<CustomerRegistration> createCustomerRegistration({
    required String branchId,
    required String customerId,
  });

  /// Lists customer-branch registrations filtered optionally.
  Future<List<CustomerRegistration>> getCustomerRegistrations({
    String? branchId,
    String? customerId,
    String? status,
  });

  /// Updates a customer registration's [status].
  Future<CustomerRegistration> updateCustomerRegistration({
    required String registrationId,
    required String status,
  });

  /// Deletes a customer registration by [registrationId].
  Future<void> deleteCustomerRegistration(String registrationId);

  // Employee Registrations & Career History
  /// Directly assigns an employee to [branchId].
  Future<EmployeeRegistration> createEmployeeRegistration({
    required String employeeId,
    required String branchId,
    required String speciality,
    required String specialityName,
    required double salary,
    required String role,
  });

  /// Submits a join request for [employeeId] to [branchId].
  Future<EmployeeRegistration> requestJoinBranch({
    required String employeeId,
    required String branchId,
    required String speciality,
    required String specialityName,
    required double salary,
  });

  /// Approves a pending employee registration by [registrationId].
  Future<EmployeeRegistration> approveEmployeeRegistration(
    String registrationId,
  );

  /// Rejects a pending employee registration by [registrationId].
  Future<EmployeeRegistration> rejectEmployeeRegistration({
    required String registrationId,
    String? reason,
  });

  /// Lists employee registrations filtered optionally.
  Future<List<EmployeeRegistration>> getEmployeeRegistrations({
    String? branchId,
    String? employeeId,
    String? status,
  });

  /// Updates specialty or salary for an employee registration.
  Future<EmployeeRegistration> updateEmployeeRegistration({
    required String registrationId,
    required String speciality,
    required String specialityName,
    required double salary,
  });

  /// Deletes an employee registration by [registrationId].
  Future<void> deleteEmployeeRegistration(String registrationId);

  /// Returns career history entries for [employeeId] in [branchId].
  Future<List<StaffCareerHistoryEntry>> getStaffCareerHistory({
    required String branchId,
    required String employeeId,
  });
}
