import 'package:mobile_application_driveos/features/billing/domain/billing_domain.dart';

/// Wire DTO representing a `QuoteItemResponse`.
class QuoteItemDto {
  /// Item identifier.
  final String id;

  /// Item type (`SERVICE` or `PRODUCT`).
  final String type;

  /// Item name.
  final String name;

  /// Quantity.
  final double quantity;

  /// Unit price.
  final double unitPrice;

  /// Line total.
  final double total;

  /// Creates a [QuoteItemDto].
  const QuoteItemDto({
    required this.id,
    required this.type,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory QuoteItemDto.fromJson(Map<String, dynamic> json) {
    if (json case {'id': final String id, 'name': final String name}) {
      return QuoteItemDto(
        id: id,
        type: json['type']?.toString() ?? 'SERVICE',
        name: name,
        quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
        unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
        total: (json['total'] as num?)?.toDouble() ?? 0.0,
      );
    }
    throw const FormatException('Invalid or incomplete QuoteItem JSON.');
  }

  /// Converts this DTO into a [QuoteItem] domain entity.
  QuoteItem toDomain() => QuoteItem(
        id: id,
        type: type,
        name: name,
        quantity: quantity,
        unitPrice: unitPrice,
        total: total,
      );
}

/// Wire DTO representing a `QuoteResponse`.
class QuoteDto {
  /// Quote identifier.
  final String id;

  /// Work order identifier.
  final String workOrderId;

  /// Branch identifier.
  final String branchId;

  /// Subtotal before discount.
  final double subtotalAmount;

  /// Discount percentage.
  final double discountPercentage;

  /// Total amount.
  final double totalAmount;

  /// Quote status.
  final String status;

  /// Optional notes.
  final String? notes;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Approval timestamp.
  final DateTime? approvedAt;

  /// Cancellation timestamp.
  final DateTime? canceledAt;

  /// Line items.
  final List<QuoteItemDto> items;

  /// Creates a [QuoteDto].
  const QuoteDto({
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

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory QuoteDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'workOrderId': final String workOrderId,
      'branchId': final String branchId,
    }) {
      final rawItems = json['items'];
      final items = rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(QuoteItemDto.fromJson)
                .toList()
          : const <QuoteItemDto>[];

      return QuoteDto(
        id: id,
        workOrderId: workOrderId,
        branchId: branchId,
        subtotalAmount: (json['subtotalAmount'] as num?)?.toDouble() ?? 0.0,
        discountPercentage:
            (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
        totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
        status: json['status']?.toString() ?? 'PENDING',
        notes: json['notes']?.toString(),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        approvedAt: json['approvedAt'] != null
            ? DateTime.tryParse(json['approvedAt'].toString())
            : null,
        canceledAt: json['canceledAt'] != null
            ? DateTime.tryParse(json['canceledAt'].toString())
            : null,
        items: items,
      );
    }
    throw const FormatException('Invalid or incomplete Quote JSON.');
  }

  /// Converts this DTO into a [Quote] domain entity.
  Quote toDomain() => Quote(
        id: id,
        workOrderId: workOrderId,
        branchId: branchId,
        subtotalAmount: subtotalAmount,
        discountPercentage: discountPercentage,
        totalAmount: totalAmount,
        status: status,
        notes: notes,
        createdAt: createdAt,
        approvedAt: approvedAt,
        canceledAt: canceledAt,
        items: items.map((item) => item.toDomain()).toList(),
      );
}

/// Wire DTO representing a `VoucherPayment` entry.
class VoucherPaymentDto {
  /// Payment identifier.
  final String id;

  /// Paid amount.
  final double amount;

  /// Payment method or provider.
  final String method;

  /// Optional payment status.
  final String? status;

  /// Payment timestamp.
  final DateTime? paidAt;

  /// Creates a [VoucherPaymentDto].
  const VoucherPaymentDto({
    required this.id,
    required this.amount,
    required this.method,
    this.status,
    this.paidAt,
  });

  /// Deserializes [json] accepting either `method` or `provider`.
  factory VoucherPaymentDto.fromJson(Map<String, dynamic> json) {
    if (json case {'id': final String id}) {
      return VoucherPaymentDto(
        id: id,
        amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
        method:
            json['method']?.toString() ??
            json['provider']?.toString() ??
            'CASH',
        status: json['status']?.toString(),
        paidAt: json['paidAt'] != null
            ? DateTime.tryParse(json['paidAt'].toString())
            : null,
      );
    }
    throw const FormatException('Invalid or incomplete VoucherPayment JSON.');
  }

  /// Converts this DTO into a [VoucherPayment] domain entity.
  VoucherPayment toDomain() => VoucherPayment(
        id: id,
        amount: amount,
        method: method,
        status: status,
        paidAt: paidAt,
      );
}

/// Wire DTO representing a `VoucherResponse`.
class VoucherDto {
  /// Voucher identifier.
  final String id;

  /// Quote identifier.
  final String quoteId;

  /// Voucher type.
  final String type;

  /// Customer document type.
  final String customerDocumentType;

  /// Customer document number.
  final String customerDocumentNumber;

  /// Customer display name.
  final String customerName;

  /// Total amount.
  final double totalAmount;

  /// Status.
  final String status;

  /// Fiscal series.
  final String? series;

  /// Fiscal correlative.
  final String? correlative;

  /// Fiscal number.
  final String? fiscalNumber;

  /// PDF download URL.
  final String? pdfUrl;

  /// Payments.
  final List<VoucherPaymentDto> payments;

  /// Total paid.
  final double totalPaid;

  /// Remaining balance.
  final double balance;

  /// Creates a [VoucherDto].
  const VoucherDto({
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

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory VoucherDto.fromJson(Map<String, dynamic> json) {
    if (json case {'id': final String id, 'quoteId': final String quoteId}) {
      final rawPayments = json['payments'];
      final payments = rawPayments is List
          ? rawPayments
                .whereType<Map<String, dynamic>>()
                .map(VoucherPaymentDto.fromJson)
                .toList()
          : const <VoucherPaymentDto>[];

      return VoucherDto(
        id: id,
        quoteId: quoteId,
        type: json['type']?.toString() ?? 'BOLETA',
        customerDocumentType:
            json['customerDocumentType']?.toString() ?? 'DNI',
        customerDocumentNumber:
            json['customerDocumentNumber']?.toString() ?? '',
        customerName: json['customerName']?.toString() ?? '',
        totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
        status: json['status']?.toString() ?? 'PENDING',
        series: json['series']?.toString(),
        correlative: json['correlative']?.toString(),
        fiscalNumber: json['fiscalNumber']?.toString(),
        pdfUrl: json['pdfUrl']?.toString(),
        payments: payments,
        totalPaid: (json['totalPaid'] as num?)?.toDouble() ?? 0.0,
        balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      );
    }
    throw const FormatException('Invalid or incomplete Voucher JSON.');
  }

  /// Converts this DTO into a [Voucher] domain entity.
  Voucher toDomain() => Voucher(
        id: id,
        quoteId: quoteId,
        type: type,
        customerDocumentType: customerDocumentType,
        customerDocumentNumber: customerDocumentNumber,
        customerName: customerName,
        totalAmount: totalAmount,
        status: status,
        series: series,
        correlative: correlative,
        fiscalNumber: fiscalNumber,
        pdfUrl: pdfUrl,
        payments: payments.map((payment) => payment.toDomain()).toList(),
        totalPaid: totalPaid,
        balance: balance,
      );
}

/// Wire DTO representing a `CheckoutResponse`.
class CheckoutResultDto {
  /// Checkout/voucher identifier.
  final String id;

  /// Quote identifier.
  final String quoteId;

  /// Work order identifier.
  final String? workOrderId;

  /// Voucher type.
  final String voucherType;

  /// Fiscal series.
  final String? series;

  /// Fiscal correlative.
  final int? correlativo;

  /// Customer document number.
  final String customerDocument;

  /// Customer display name.
  final String customerName;

  /// Total amount.
  final double totalAmount;

  /// Status.
  final String status;

  /// Total paid.
  final double totalPaid;

  /// PDF URL.
  final String? pdfUrl;

  /// Payment details.
  final VoucherPaymentDto? payment;

  /// Creates a [CheckoutResultDto].
  const CheckoutResultDto({
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

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory CheckoutResultDto.fromJson(Map<String, dynamic> json) {
    if (json case {'id': final String id, 'quoteId': final String quoteId}) {
      final rawPayment = json['payment'];
      return CheckoutResultDto(
        id: id,
        quoteId: quoteId,
        workOrderId: json['workOrderId']?.toString(),
        voucherType: json['voucherType']?.toString() ?? 'BOLETA',
        series: json['series']?.toString(),
        correlativo: (json['correlativo'] as num?)?.toInt(),
        customerDocument: json['customerDocument']?.toString() ?? '',
        customerName: json['customerName']?.toString() ?? '',
        totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
        status: json['status']?.toString() ?? 'PAID',
        totalPaid: (json['totalPaid'] as num?)?.toDouble() ?? 0.0,
        pdfUrl: json['pdfUrl']?.toString(),
        payment: rawPayment is Map<String, dynamic>
            ? VoucherPaymentDto.fromJson(rawPayment)
            : null,
      );
    }
    throw const FormatException('Invalid or incomplete CheckoutResult JSON.');
  }

  /// Converts this DTO into a [CheckoutResult] domain entity.
  CheckoutResult toDomain() => CheckoutResult(
        id: id,
        quoteId: quoteId,
        workOrderId: workOrderId,
        voucherType: voucherType,
        series: series,
        correlativo: correlativo,
        customerDocument: customerDocument,
        customerName: customerName,
        totalAmount: totalAmount,
        status: status,
        totalPaid: totalPaid,
        pdfUrl: pdfUrl,
        payment: payment?.toDomain(),
      );
}

/// Wire DTO representing a `PaymentSessionResponse`.
class PaymentSessionDto {
  /// Session identifier.
  final String sessionId;

  /// Provider name.
  final String provider;

  /// Optional quote identifier.
  final String? quoteId;

  /// Optional invoice identifier.
  final String? invoiceId;

  /// Session status.
  final String status;

  /// Checkout redirect URL.
  final String checkoutUrl;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates a [PaymentSessionDto].
  const PaymentSessionDto({
    required this.sessionId,
    required this.provider,
    this.quoteId,
    this.invoiceId,
    required this.status,
    required this.checkoutUrl,
    this.createdAt,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory PaymentSessionDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'sessionId': final String sessionId,
      'checkoutUrl': final String checkoutUrl,
    }) {
      return PaymentSessionDto(
        sessionId: sessionId,
        provider: json['provider']?.toString() ?? 'MERCADOPAGO',
        quoteId: json['quoteId']?.toString(),
        invoiceId: json['invoiceId']?.toString(),
        status: json['status']?.toString() ?? 'CREATED',
        checkoutUrl: checkoutUrl,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );
    }
    throw const FormatException('Invalid or incomplete PaymentSession JSON.');
  }

  /// Converts this DTO into a [PaymentSession] domain entity.
  PaymentSession toDomain() => PaymentSession(
        sessionId: sessionId,
        provider: provider,
        quoteId: quoteId,
        invoiceId: invoiceId,
        status: status,
        checkoutUrl: checkoutUrl,
        createdAt: createdAt,
      );
}
