/// Represents a payment entry recorded against a [Voucher].
class VoucherPayment {
  /// The payment identifier.
  final String id;

  /// The paid amount.
  final double amount;

  /// The payment method or provider (`CASH`, `CARD`, `YAPE`, `MERCADOPAGO`).
  final String method;

  /// Payment status, if provided.
  final String? status;

  /// Timestamp when the payment was recorded.
  final DateTime? paidAt;

  /// Creates a [VoucherPayment].
  const VoucherPayment({
    required this.id,
    required this.amount,
    required this.method,
    this.status,
    this.paidAt,
  });
}

/// Represents a billing voucher (`BOLETA` or `FACTURA`) with payment balance.
class Voucher {
  /// The unique voucher identifier.
  final String id;

  /// The associated quote identifier.
  final String quoteId;

  /// The voucher type (`BOLETA` or `FACTURA`).
  final String type;

  /// Customer identity document type (`DNI`, `RUC`, etc.).
  final String customerDocumentType;

  /// Customer identity document number.
  final String customerDocumentNumber;

  /// Customer display name or legal name.
  final String customerName;

  /// Total billed amount.
  final double totalAmount;

  /// Voucher payment status (`PAID`, `PARTIAL`, `PENDING`, etc.).
  final String status;

  /// Fiscal series (e.g. `B001`).
  final String? series;

  /// Fiscal correlative number.
  final String? correlative;

  /// Formatted fiscal number (e.g. `B001-000042`).
  final String? fiscalNumber;

  /// Optional PDF download URL.
  final String? pdfUrl;

  /// Payments recorded against this voucher.
  final List<VoucherPayment> payments;

  /// Total amount paid so far.
  final double totalPaid;

  /// Remaining unpaid balance.
  final double balance;

  /// Creates a [Voucher].
  const Voucher({
    required this.id,
    required this.quoteId,
    required this.type,
    required this.customerDocumentType,
    required this.customerDocumentNumber,
    required this.customerName,
    required this.totalAmount,
    required this.status,
    this.series,
    this.correlative,
    this.fiscalNumber,
    this.pdfUrl,
    this.payments = const [],
    this.totalPaid = 0.0,
    this.balance = 0.0,
  });
}

/// Represents the result of a direct or Mercado Pago checkout.
class CheckoutResult {
  /// The generated voucher/checkout identifier.
  final String id;

  /// The quote identifier.
  final String quoteId;

  /// The associated work order identifier.
  final String? workOrderId;

  /// The voucher type (`BOLETA` or `FACTURA`).
  final String voucherType;

  /// Fiscal series.
  final String? series;

  /// Fiscal correlative.
  final int? correlativo;

  /// Customer document number.
  final String customerDocument;

  /// Customer display name.
  final String customerName;

  /// Total billed amount.
  final double totalAmount;

  /// Checkout status (`PAID`, etc.).
  final String status;

  /// Total amount paid.
  final double totalPaid;

  /// Optional PDF URL.
  final String? pdfUrl;

  /// Payment details, if returned.
  final VoucherPayment? payment;

  /// Creates a [CheckoutResult].
  const CheckoutResult({
    required this.id,
    required this.quoteId,
    this.workOrderId,
    required this.voucherType,
    this.series,
    this.correlativo,
    required this.customerDocument,
    required this.customerName,
    required this.totalAmount,
    required this.status,
    required this.totalPaid,
    this.pdfUrl,
    this.payment,
  });
}

/// Represents a Mercado Pago checkout preference or payment session.
class PaymentSession {
  /// The session or preference identifier.
  final String sessionId;

  /// The payment provider (`MERCADOPAGO`).
  final String provider;

  /// Optional associated quote identifier.
  final String? quoteId;

  /// Optional associated invoice identifier.
  final String? invoiceId;

  /// Session status (`CREATED`, etc.).
  final String status;

  /// The checkout redirect URL.
  final String checkoutUrl;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [PaymentSession].
  const PaymentSession({
    required this.sessionId,
    required this.provider,
    this.quoteId,
    this.invoiceId,
    required this.status,
    required this.checkoutUrl,
    this.createdAt,
  });
}
