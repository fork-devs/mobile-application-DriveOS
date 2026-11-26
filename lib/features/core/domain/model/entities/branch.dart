/// Represents a physical workshop branch location.
class Branch {
  /// The unique branch identifier.
  final String id;

  /// The parent workshop identifier.
  final String workshopId;

  /// The internal branch code (e.g. `SUC-01`).
  final String code;

  /// The branch display name.
  final String name;

  /// The street address of the branch.
  final String address;

  /// The branch contact phone number.
  final String phone;

  /// The optional banner image URL.
  final String? bannerImageUrl;

  /// The optional geographic latitude.
  final double? latitude;

  /// The optional geographic longitude.
  final double? longitude;

  /// Creates a [Branch].
  const Branch({
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
}

/// Represents a subscription plan available in DriveOS.
class SubscriptionPlan {
  /// The unique plan identifier.
  final String id;

  /// The plan code (e.g. `FREE`, `PRO`, `ENTERPRISE`).
  final String code;

  /// Maximum number of users permitted by the plan.
  final int maxUsers;

  /// Maximum number of vehicles permitted by the plan.
  final int maxVehicles;

  /// Maximum IoT telemetry messages per day.
  final int maxIotMsgPerDay;

  /// Monthly price in the platform currency.
  final double priceMonthly;

  /// Creates a [SubscriptionPlan].
  const SubscriptionPlan({
    required this.id,
    required this.code,
    required this.maxUsers,
    required this.maxVehicles,
    required this.maxIotMsgPerDay,
    required this.priceMonthly,
  });
}

/// Represents an active or historical subscription assigned to a [Branch].
class BranchSubscription {
  /// The subscription identifier.
  final String id;

  /// The subscribed branch identifier.
  final String branchId;

  /// The subscribed plan identifier.
  final String planId;

  /// The billing cycle (`MONTHLY` or `ANNUAL`).
  final String billingCycle;

  /// The subscription status (e.g. `ACTIVE`).
  final String status;

  /// The subscription start timestamp.
  final DateTime? startDate;

  /// The subscription end timestamp.
  final DateTime? endDate;

  /// Creates a [BranchSubscription].
  const BranchSubscription({
    required this.id,
    required this.branchId,
    required this.planId,
    required this.billingCycle,
    required this.status,
    this.startDate,
    this.endDate,
  });
}
