/// Represents a line item inside a [Quote].
class QuoteItem {
  /// The quote item identifier.
  final String id;

  /// The item type (`SERVICE` or `PRODUCT`).
  final String type;

  /// The item display name.
  final String name;

  /// The quantity.
  final double quantity;

  /// The unit price.
  final double unitPrice;

  /// The computed line total.
  final double total;

  /// Creates a [QuoteItem].
  const QuoteItem({
    required this.id,
    required this.type,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
}

/// Represents a workshop quote generated for a work order.
class Quote {
  /// The unique quote identifier.
  final String id;

  /// The associated work order identifier.
  final String workOrderId;

  /// The workshop branch identifier.
  final String branchId;

  /// Subtotal before discount.
  final double subtotalAmount;

  /// Applied discount percentage (`0.0` to `100.0`).
  final double discountPercentage;

  /// Final total after discount.
  final double totalAmount;

  /// Quote lifecycle status (`PENDING`, `APPROVED`, `CANCELED`, etc.).
  final String status;

  /// Optional quote notes.
  final String? notes;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Approval timestamp, if approved.
  final DateTime? approvedAt;

  /// Cancellation timestamp, if canceled.
  final DateTime? canceledAt;

  /// Line items included in this quote.
  final List<QuoteItem> items;

  /// Creates a [Quote].
  const Quote({
    required this.id,
    required this.workOrderId,
    required this.branchId,
    required this.subtotalAmount,
    required this.discountPercentage,
    required this.totalAmount,
    required this.status,
    this.notes,
    this.createdAt,
    this.approvedAt,
    this.canceledAt,
    this.items = const [],
  });
}
