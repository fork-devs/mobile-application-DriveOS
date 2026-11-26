/// Represents an automotive workshop entity owned by an [OwnerProfile].
class Workshop {
  /// The unique workshop identifier.
  final String id;

  /// The identifier of the owner profile.
  final String ownerId;

  /// The legal business name of the workshop.
  final String businessName;

  /// The commercial brand name displayed to customers.
  final String brandName;

  /// The tax identifier (e.g. Peruvian RUC).
  final String taxId;

  /// The default preventive maintenance interval in kilometers.
  final int mileageIntervalConfig;

  /// Creates a [Workshop].
  const Workshop({
    required this.id,
    required this.ownerId,
    required this.businessName,
    required this.brandName,
    required this.taxId,
    this.mileageIntervalConfig = 5000,
  });
}
