import 'package:mobile_application_driveos/features/core/domain/core_domain.dart';

/// Wire DTO representing a `WorkshopResponse` from `erp-tenant-service`.
class WorkshopDto {
  /// The workshop identifier.
  final String id;

  /// The owner profile identifier.
  final String ownerId;

  /// The legal business name.
  final String businessName;

  /// The commercial brand name.
  final String brandName;

  /// The tax identifier.
  final String taxId;

  /// The maintenance interval in kilometers.
  final int mileageIntervalConfig;

  /// Creates a [WorkshopDto].
  const WorkshopDto({
    required this.id,
    required this.ownerId,
    required this.businessName,
    required this.brandName,
    required this.taxId,
    required this.mileageIntervalConfig,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory WorkshopDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'ownerId': final String ownerId,
      'businessName': final String businessName,
      'brandName': final String brandName,
      'taxId': final String taxId,
    }) {
      return WorkshopDto(
        id: id,
        ownerId: ownerId,
        businessName: businessName,
        brandName: brandName,
        taxId: taxId,
        mileageIntervalConfig:
            (json['mileageIntervalConfig'] as num?)?.toInt() ?? 5000,
      );
    }
    throw const FormatException('Invalid or incomplete Workshop JSON.');
  }

  /// Converts this DTO into a [Workshop] domain entity.
  Workshop toDomain() => Workshop(
        id: id,
        ownerId: ownerId,
        businessName: businessName,
        brandName: brandName,
        taxId: taxId,
        mileageIntervalConfig: mileageIntervalConfig,
      );
}

/// Wire DTO representing a `BranchResponse` from `erp-tenant-service`.
class BranchDto {
  /// The branch identifier.
  final String id;

  /// The parent workshop identifier.
  final String workshopId;

  /// The branch code.
  final String code;

  /// The branch display name.
  final String name;

  /// The street address.
  final String address;

  /// The contact phone number.
  final String phone;

  /// The optional banner image URL.
  final String? bannerImageUrl;

  /// The optional latitude.
  final double? latitude;

  /// The optional longitude.
  final double? longitude;

  /// Creates a [BranchDto].
  const BranchDto({
    required this.id,
    required this.workshopId,
    required this.code,
    required this.name,
    required this.address,
    required this.phone,
    this.bannerImageUrl,
    this.latitude,
    this.longitude,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory BranchDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'workshopId': final String workshopId,
      'name': final String name,
    }) {
      return BranchDto(
        id: id,
        workshopId: workshopId,
        code: json['code']?.toString() ?? '',
        name: name,
        address: json['address']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        bannerImageUrl: json['bannerImageUrl']?.toString(),
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
      );
    }
    throw const FormatException('Invalid or incomplete Branch JSON.');
  }

  /// Converts this DTO into a [Branch] domain entity.
  Branch toDomain() => Branch(
        id: id,
        workshopId: workshopId,
        code: code,
        name: name,
        address: address,
        phone: phone,
        bannerImageUrl: bannerImageUrl,
        latitude: latitude,
        longitude: longitude,
      );
}

/// Wire DTO representing a `PlanResponse` from `erp-tenant-service`.
class SubscriptionPlanDto {
  /// The plan identifier.
  final String id;

  /// The plan code.
  final String code;

  /// Maximum allowed users.
  final int maxUsers;

  /// Maximum allowed vehicles.
  final int maxVehicles;

  /// Maximum IoT messages per day.
  final int maxIotMsgPerDay;

  /// Monthly subscription price.
  final double priceMonthly;

  /// Creates a [SubscriptionPlanDto].
  const SubscriptionPlanDto({
    required this.id,
    required this.code,
    required this.maxUsers,
    required this.maxVehicles,
    required this.maxIotMsgPerDay,
    required this.priceMonthly,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory SubscriptionPlanDto.fromJson(Map<String, dynamic> json) {
    if (json case {'id': final String id, 'code': final String code}) {
      return SubscriptionPlanDto(
        id: id,
        code: code,
        maxUsers: (json['maxUsers'] as num?)?.toInt() ?? 0,
        maxVehicles: (json['maxVehicles'] as num?)?.toInt() ?? 0,
        maxIotMsgPerDay: (json['maxIotMsgPerDay'] as num?)?.toInt() ?? 0,
        priceMonthly: (json['priceMonthly'] as num?)?.toDouble() ?? 0.0,
      );
    }
    throw const FormatException('Invalid or incomplete Plan JSON.');
  }

  /// Converts this DTO into a [SubscriptionPlan] domain entity.
  SubscriptionPlan toDomain() => SubscriptionPlan(
        id: id,
        code: code,
        maxUsers: maxUsers,
        maxVehicles: maxVehicles,
        maxIotMsgPerDay: maxIotMsgPerDay,
        priceMonthly: priceMonthly,
      );
}

/// Wire DTO representing a branch subscription response.
class BranchSubscriptionDto {
  /// The subscription identifier.
  final String id;

  /// The branch identifier.
  final String branchId;

  /// The plan identifier.
  final String planId;

  /// The billing cycle (`MONTHLY` or `ANNUAL`).
  final String billingCycle;

  /// The subscription status.
  final String status;

  /// The start timestamp.
  final DateTime? startDate;

  /// The end timestamp.
  final DateTime? endDate;

  /// Creates a [BranchSubscriptionDto].
  const BranchSubscriptionDto({
    required this.id,
    required this.branchId,
    required this.planId,
    required this.billingCycle,
    required this.status,
    this.startDate,
    this.endDate,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory BranchSubscriptionDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'branchId': final String branchId,
      'planId': final String planId,
    }) {
      return BranchSubscriptionDto(
        id: id,
        branchId: branchId,
        planId: planId,
        billingCycle: json['billingCycle']?.toString() ?? 'MONTHLY',
        status: json['status']?.toString() ?? 'ACTIVE',
        startDate: json['startDate'] != null
            ? DateTime.tryParse(json['startDate'].toString())
            : null,
        endDate: json['endDate'] != null
            ? DateTime.tryParse(json['endDate'].toString())
            : null,
      );
    }
    throw const FormatException(
      'Invalid or incomplete BranchSubscription JSON.',
    );
  }

  /// Converts this DTO into a [BranchSubscription] domain entity.
  BranchSubscription toDomain() => BranchSubscription(
        id: id,
        branchId: branchId,
        planId: planId,
        billingCycle: billingCycle,
        status: status,
        startDate: startDate,
        endDate: endDate,
      );
}

/// Wire DTO representing an `OwnerProfileResponse`.
class OwnerProfileDto {
  /// The owner profile identifier.
  final String id;

  /// The associated IAM user identifier.
  final String? userId;

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// Document type.
  final String documentType;

  /// Document number.
  final String documentNumber;

  /// Phone number.
  final String phone;

  /// Optional profile image URL.
  final String? profileImageUrl;

  /// Creates an [OwnerProfileDto].
  const OwnerProfileDto({
    required this.id,
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.documentType,
    required this.documentNumber,
    required this.phone,
    this.profileImageUrl,
  });

  /// Deserializes [json] accepting either `id` or `ownerId`.
  factory OwnerProfileDto.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['ownerId']?.toString();
    if (id == null || id.isEmpty) {
      throw const FormatException('Invalid or incomplete OwnerProfile JSON.');
    }

    return OwnerProfileDto(
      id: id,
      userId: json['userId']?.toString(),
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      documentType: json['documentType']?.toString() ?? 'DNI',
      documentNumber: json['documentNumber']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      profileImageUrl: json['profileImageUrl']?.toString(),
    );
  }

  /// Converts this DTO into an [OwnerProfile] domain entity.
  OwnerProfile toDomain() => OwnerProfile(
        id: id,
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        documentType: documentType,
        documentNumber: documentNumber,
        phone: phone,
        profileImageUrl: profileImageUrl,
      );
}

/// Wire DTO representing an `EmployeeProfileResponse`.
class EmployeeProfileDto {
  /// The employee profile identifier.
  final String id;

  /// The associated IAM user identifier.
  final String? userId;

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// Document type.
  final String documentType;

  /// Document number.
  final String documentNumber;

  /// Phone number.
  final String phone;

  /// Optional profile image URL.
  final String? profileImageUrl;

  /// Creates an [EmployeeProfileDto].
  const EmployeeProfileDto({
    required this.id,
    this.userId,
    required this.firstName,
    required this.lastName,
    required this.documentType,
    required this.documentNumber,
    required this.phone,
    this.profileImageUrl,
  });

  /// Deserializes [json] accepting either `id` or `employeeId`.
  factory EmployeeProfileDto.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? json['employeeId']?.toString();
    if (id == null || id.isEmpty) {
      throw const FormatException(
        'Invalid or incomplete EmployeeProfile JSON.',
      );
    }

    return EmployeeProfileDto(
      id: id,
      userId: json['userId']?.toString(),
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      documentType: json['documentType']?.toString() ?? 'DNI',
      documentNumber: json['documentNumber']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      profileImageUrl: json['profileImageUrl']?.toString(),
    );
  }

  /// Converts this DTO into an [EmployeeProfile] domain entity.
  EmployeeProfile toDomain() => EmployeeProfile(
        id: id,
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        documentType: documentType,
        documentNumber: documentNumber,
        phone: phone,
        profileImageUrl: profileImageUrl,
      );
}

/// Wire DTO representing `UserProfileContextResponse` from `/profiles/me`.
class UserProfileContextDto {
  /// The authenticated user identifier.
  final String userId;

  /// The assigned role codes.
  final List<String> roles;

  /// Optional owner profile.
  final OwnerProfileDto? owner;

  /// Optional employee profile.
  final EmployeeProfileDto? employee;

  /// Optional customer payload.
  final Map<String, dynamic>? customer;

  /// Creates a [UserProfileContextDto].
  const UserProfileContextDto({
    required this.userId,
    required this.roles,
    this.owner,
    this.employee,
    this.customer,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory UserProfileContextDto.fromJson(Map<String, dynamic> json) {
    if (json case {'userId': final String userId}) {
      final rawRoles = json['roles'];
      final roles = rawRoles is List
          ? rawRoles.map((role) => role.toString()).toList()
          : const <String>[];

      final rawOwner = json['owner'];
      final rawEmployee = json['employee'];
      final rawCustomer = json['customer'];

      return UserProfileContextDto(
        userId: userId,
        roles: roles,
        owner: rawOwner is Map<String, dynamic>
            ? OwnerProfileDto.fromJson(rawOwner)
            : null,
        employee: rawEmployee is Map<String, dynamic>
            ? EmployeeProfileDto.fromJson(rawEmployee)
            : null,
        customer: rawCustomer is Map<String, dynamic> ? rawCustomer : null,
      );
    }
    throw const FormatException(
      'Invalid or incomplete UserProfileContext JSON.',
    );
  }

  /// Converts this DTO into a [UserProfileContext] domain entity.
  UserProfileContext toDomain() => UserProfileContext(
        userId: userId,
        roles: roles,
        owner: owner?.toDomain(),
        employee: employee?.toDomain(),
        customer: customer,
      );
}

/// Wire DTO representing a unified profile lookup response.
class UnifiedProfileLookupDto {
  /// The profile type (`OWNER` or `EMPLOYEE`).
  final String profileType;

  /// The associated IAM user identifier.
  final String userId;

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// Document type.
  final String documentType;

  /// Document number.
  final String documentNumber;

  /// Phone number.
  final String phone;

  /// Optional employee identifier.
  final String? employeeId;

  /// Optional owner identifier.
  final String? ownerId;

  /// Assigned role codes.
  final List<String> roles;

  /// Creates a [UnifiedProfileLookupDto].
  const UnifiedProfileLookupDto({
    required this.profileType,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.documentType,
    required this.documentNumber,
    required this.phone,
    this.employeeId,
    this.ownerId,
    required this.roles,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory UnifiedProfileLookupDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'profileType': final String profileType,
      'userId': final String userId,
      'documentNumber': final String documentNumber,
    }) {
      final rawRoles = json['roles'];
      final roles = rawRoles is List
          ? rawRoles.map((role) => role.toString()).toList()
          : const <String>[];

      return UnifiedProfileLookupDto(
        profileType: profileType,
        userId: userId,
        firstName: json['firstName']?.toString() ?? '',
        lastName: json['lastName']?.toString() ?? '',
        documentType: json['documentType']?.toString() ?? 'DNI',
        documentNumber: documentNumber,
        phone: json['phone']?.toString() ?? '',
        employeeId: json['employeeId']?.toString(),
        ownerId: json['ownerId']?.toString(),
        roles: roles,
      );
    }
    throw const FormatException(
      'Invalid or incomplete UnifiedProfileLookup JSON.',
    );
  }

  /// Converts this DTO into a [UnifiedProfileLookup] domain entity.
  UnifiedProfileLookup toDomain() => UnifiedProfileLookup(
        profileType: profileType,
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        documentType: documentType,
        documentNumber: documentNumber,
        phone: phone,
        employeeId: employeeId,
        ownerId: ownerId,
        roles: roles,
      );
}
