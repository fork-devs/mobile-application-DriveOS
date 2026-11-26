import 'package:mobile_application_driveos/features/fleet/domain/fleet_domain.dart';

/// Wire DTO representing an `AppointmentResponse` from `erp-fleet-service`.
class AppointmentDto {
  /// The appointment identifier.
  final String id;

  /// The branch identifier.
  final String branchId;

  /// The customer identifier.
  final String customerId;

  /// The vehicle identifier.
  final String vehicleId;

  /// Scheduled start timestamp.
  final DateTime scheduledStart;

  /// Scheduled end timestamp.
  final DateTime scheduledEnd;

  /// Appointment status.
  final String status;

  /// Optional notes.
  final String? notes;

  /// Optional cancellation reason.
  final String? cancellationReason;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Last update timestamp.
  final DateTime? updatedAt;

  /// Creates an [AppointmentDto].
  const AppointmentDto({
    required this.id,
    required this.branchId,
    required this.customerId,
    required this.vehicleId,
    required this.scheduledStart,
    required this.scheduledEnd,
    required this.status,
    this.notes,
    this.cancellationReason,
    this.createdAt,
    this.updatedAt,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory AppointmentDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'branchId': final String branchId,
      'customerId': final String customerId,
      'vehicleId': final String vehicleId,
      'scheduledStart': final String startRaw,
      'scheduledEnd': final String endRaw,
    }) {
      return AppointmentDto(
        id: id,
        branchId: branchId,
        customerId: customerId,
        vehicleId: vehicleId,
        scheduledStart: DateTime.tryParse(startRaw) ?? DateTime.now(),
        scheduledEnd: DateTime.tryParse(endRaw) ?? DateTime.now(),
        status: json['status']?.toString() ?? 'SCHEDULED',
        notes: json['notes']?.toString(),
        cancellationReason: json['cancellationReason']?.toString(),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString())
            : null,
      );
    }
    throw const FormatException('Invalid or incomplete Appointment JSON.');
  }

  /// Converts this DTO into an [Appointment] domain entity.
  Appointment toDomain() => Appointment(
        id: id,
        branchId: branchId,
        customerId: customerId,
        vehicleId: vehicleId,
        scheduledStart: scheduledStart,
        scheduledEnd: scheduledEnd,
        status: status,
        notes: notes,
        cancellationReason: cancellationReason,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

/// Wire DTO representing a `CustomerResponse` from `erp-fleet-service`.
class CustomerDto {
  /// Customer identifier.
  final String id;

  /// Tenant identifier.
  final String tenantId;

  /// Customer full name.
  final String fullName;

  /// Email address.
  final String email;

  /// Phone number.
  final String phone;

  /// Document type.
  final String docType;

  /// Document number.
  final String docNumber;

  /// Identity validation status.
  final String validationStatus;

  /// Account status.
  final String status;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [CustomerDto].
  const CustomerDto({
    required this.id,
    required this.tenantId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.docType,
    required this.docNumber,
    required this.validationStatus,
    required this.status,
    this.createdAt,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'tenantId': final String tenantId,
      'fullName': final String fullName,
    }) {
      return CustomerDto(
        id: id,
        tenantId: tenantId,
        fullName: fullName,
        email: json['email']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        docType: json['docType']?.toString() ?? 'DNI',
        docNumber: json['docNumber']?.toString() ?? '',
        validationStatus: json['validationStatus']?.toString() ?? 'PENDING',
        status: json['status']?.toString() ?? 'ACTIVE',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );
    }
    throw const FormatException('Invalid or incomplete Customer JSON.');
  }

  /// Converts this DTO into a [Customer] domain entity.
  Customer toDomain() => Customer(
        id: id,
        tenantId: tenantId,
        fullName: fullName,
        email: email,
        phone: phone,
        docType: docType,
        docNumber: docNumber,
        validationStatus: validationStatus,
        status: status,
        createdAt: createdAt,
      );
}

/// Wire DTO representing a `VehicleResponse` from `erp-fleet-service`.
class VehicleDto {
  /// Vehicle identifier.
  final String id;

  /// Tenant identifier.
  final String tenantId;

  /// Owner customer identifier.
  final String customerId;

  /// License plate.
  final String plate;

  /// Manufacturer brand.
  final String brand;

  /// Model name.
  final String model;

  /// Manufacturing year.
  final int year;

  /// Vehicle Identification Number.
  final String vin;

  /// Validation status.
  final String validationStatus;

  /// Vehicle status.
  final String status;

  /// Optional vehicle image URL.
  final String? imageUrl;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [VehicleDto].
  const VehicleDto({
    required this.id,
    required this.tenantId,
    required this.customerId,
    required this.plate,
    required this.brand,
    required this.model,
    required this.year,
    required this.vin,
    required this.validationStatus,
    required this.status,
    this.imageUrl,
    this.createdAt,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory VehicleDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'tenantId': final String tenantId,
      'customerId': final String customerId,
      'plate': final String plate,
    }) {
      return VehicleDto(
        id: id,
        tenantId: tenantId,
        customerId: customerId,
        plate: plate,
        brand: json['brand']?.toString() ?? '',
        model: json['model']?.toString() ?? '',
        year: (json['year'] as num?)?.toInt() ?? 0,
        vin: json['vin']?.toString() ?? '',
        validationStatus: json['validationStatus']?.toString() ?? 'PENDING',
        status: json['status']?.toString() ?? 'ACTIVE',
        imageUrl: json['imageUrl']?.toString(),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );
    }
    throw const FormatException('Invalid or incomplete Vehicle JSON.');
  }

  /// Converts this DTO into a [Vehicle] domain entity.
  Vehicle toDomain() => Vehicle(
        id: id,
        tenantId: tenantId,
        customerId: customerId,
        plate: plate,
        brand: brand,
        model: model,
        year: year,
        vin: vin,
        validationStatus: validationStatus,
        status: status,
        imageUrl: imageUrl,
        createdAt: createdAt,
      );
}

/// Wire DTO representing a `CustomerRegistrationResponse`.
class CustomerRegistrationDto {
  /// Registration identifier.
  final String id;

  /// Branch identifier.
  final String branchId;

  /// Customer identifier.
  final String customerId;

  /// Affiliation status.
  final String status;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [CustomerRegistrationDto].
  const CustomerRegistrationDto({
    required this.id,
    required this.branchId,
    required this.customerId,
    required this.status,
    this.createdAt,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory CustomerRegistrationDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'branchId': final String branchId,
      'customerId': final String customerId,
    }) {
      return CustomerRegistrationDto(
        id: id,
        branchId: branchId,
        customerId: customerId,
        status: json['status']?.toString() ?? 'ACTIVE',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );
    }
    throw const FormatException(
      'Invalid or incomplete CustomerRegistration JSON.',
    );
  }

  /// Converts this DTO into a [CustomerRegistration] domain entity.
  CustomerRegistration toDomain() => CustomerRegistration(
        id: id,
        branchId: branchId,
        customerId: customerId,
        status: status,
        createdAt: createdAt,
      );
}

/// Wire DTO representing an `EmployeeRegistrationResponse`.
class EmployeeRegistrationDto {
  /// Registration identifier.
  final String id;

  /// Employee identifier.
  final String employeeId;

  /// Branch identifier.
  final String branchId;

  /// Specialty code.
  final String speciality;

  /// Specialty display name.
  final String specialityName;

  /// Monthly salary.
  final double salary;

  /// Assigned role code.
  final String role;

  /// Registration status.
  final String status;

  /// Optional rejection reason.
  final String? rejectionReason;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Approval timestamp.
  final DateTime? approvedAt;

  /// Creates an [EmployeeRegistrationDto].
  const EmployeeRegistrationDto({
    required this.id,
    required this.employeeId,
    required this.branchId,
    required this.speciality,
    required this.specialityName,
    required this.salary,
    required this.role,
    required this.status,
    this.rejectionReason,
    this.createdAt,
    this.approvedAt,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory EmployeeRegistrationDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'employeeId': final String employeeId,
      'branchId': final String branchId,
    }) {
      return EmployeeRegistrationDto(
        id: id,
        employeeId: employeeId,
        branchId: branchId,
        speciality: json['speciality']?.toString() ?? '',
        specialityName: json['specialityName']?.toString() ?? '',
        salary: (json['salary'] as num?)?.toDouble() ?? 0.0,
        role: json['role']?.toString() ?? 'TECHNICIAN',
        status: json['status']?.toString() ?? 'PENDING',
        rejectionReason: json['rejectionReason']?.toString(),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        approvedAt: json['approvedAt'] != null
            ? DateTime.tryParse(json['approvedAt'].toString())
            : null,
      );
    }
    throw const FormatException(
      'Invalid or incomplete EmployeeRegistration JSON.',
    );
  }

  /// Converts this DTO into an [EmployeeRegistration] domain entity.
  EmployeeRegistration toDomain() => EmployeeRegistration(
        id: id,
        employeeId: employeeId,
        branchId: branchId,
        speciality: speciality,
        specialityName: specialityName,
        salary: salary,
        role: role,
        status: status,
        rejectionReason: rejectionReason,
        createdAt: createdAt,
        approvedAt: approvedAt,
      );
}

/// Wire DTO representing a `StaffCareerHistoryEntry`.
class StaffCareerHistoryEntryDto {
  /// History entry identifier.
  final String id;

  /// Employee identifier.
  final String employeeId;

  /// Branch identifier.
  final String branchId;

  /// Specialty code.
  final String speciality;

  /// Specialty name.
  final String specialityName;

  /// Salary.
  final double salary;

  /// Role code.
  final String role;

  /// Status.
  final String status;

  /// Timestamp of the change.
  final DateTime changedAt;

  /// Optional reason for the change.
  final String? changeReason;

  /// Creates a [StaffCareerHistoryEntryDto].
  const StaffCareerHistoryEntryDto({
    required this.id,
    required this.employeeId,
    required this.branchId,
    required this.speciality,
    required this.specialityName,
    required this.salary,
    required this.role,
    required this.status,
    required this.changedAt,
    this.changeReason,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory StaffCareerHistoryEntryDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'employeeId': final String employeeId,
      'branchId': final String branchId,
      'changedAt': final String changedAtRaw,
    }) {
      return StaffCareerHistoryEntryDto(
        id: id,
        employeeId: employeeId,
        branchId: branchId,
        speciality: json['speciality']?.toString() ?? '',
        specialityName: json['specialityName']?.toString() ?? '',
        salary: (json['salary'] as num?)?.toDouble() ?? 0.0,
        role: json['role']?.toString() ?? 'TECHNICIAN',
        status: json['status']?.toString() ?? 'APPROVED',
        changedAt: DateTime.tryParse(changedAtRaw) ?? DateTime.now(),
        changeReason: json['changeReason']?.toString(),
      );
    }
    throw const FormatException(
      'Invalid or incomplete StaffCareerHistoryEntry JSON.',
    );
  }

  /// Converts this DTO into a [StaffCareerHistoryEntry] domain entity.
  StaffCareerHistoryEntry toDomain() => StaffCareerHistoryEntry(
        id: id,
        employeeId: employeeId,
        branchId: branchId,
        speciality: speciality,
        specialityName: specialityName,
        salary: salary,
        role: role,
        status: status,
        changedAt: changedAt,
        changeReason: changeReason,
      );
}
