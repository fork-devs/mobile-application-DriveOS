import 'package:mobile_application_driveos/features/billing/domain/billing_domain.dart';

/// Use case that executes direct/Mercado Pago checkouts and payment sessions.
class ManageCheckouts {
  final BillingRepository _repository;

  /// Creates a [ManageCheckouts] use case.
  const ManageCheckouts(this._repository);

  /// Executes a direct checkout for [quoteId].
  Future<CheckoutResult> directCheckout({
    required String quoteId,
    required String type,
    required String customerDocumentType,
    required String customerDocumentNumber,
    required String customerName,
    required String method,
  }) {
    return _repository.directCheckout(
      quoteId: quoteId,
      type: type.trim().toUpperCase(),
      customerDocumentType: customerDocumentType.trim().toUpperCase(),
      customerDocumentNumber: customerDocumentNumber.trim(),
      customerName: customerName.trim(),
      method: method.trim().toUpperCase(),
    );
  }

  /// Executes a Mercado Pago checkout with a validated [paymentId].
  Future<CheckoutResult> mercadoPagoCheckout({
    required String quoteId,
    required String type,
    required String customerDocumentType,
    required String customerDocumentNumber,
    required String customerName,
    required String paymentId,
  }) {
    return _repository.mercadoPagoCheckout(
      quoteId: quoteId,
      type: type.trim().toUpperCase(),
      customerDocumentType: customerDocumentType.trim().toUpperCase(),
      customerDocumentNumber: customerDocumentNumber.trim(),
      customerName: customerName.trim(),
      paymentId: paymentId.trim(),
    );
  }

  /// Creates a payment session for [quoteId] or [invoiceId].
  Future<PaymentSession> createPaymentSession({
    String? quoteId,
    String? invoiceId,
    String provider = 'MERCADOPAGO',
  }) {
    return _repository.createPaymentSession(
      quoteId: quoteId,
      invoiceId: invoiceId,
      provider: provider.trim().toUpperCase(),
    );
  }
}

/// Use case that issues and manages billing vouchers and their payments.
class ManageVouchers {
  final BillingRepository _repository;

  /// Creates a [ManageVouchers] use case.
  const ManageVouchers(this._repository);

  /// Issues a voucher with an initial payment.
  Future<Voucher> create({
    required String quoteId,
    required String type,
    required String customerDocumentType,
    required String customerDocumentNumber,
    required String customerName,
    required String method,
  }) {
    return _repository.createVoucher(
      quoteId: quoteId,
      type: type.trim().toUpperCase(),
      customerDocumentType: customerDocumentType.trim().toUpperCase(),
      customerDocumentNumber: customerDocumentNumber.trim(),
      customerName: customerName.trim(),
      method: method.trim().toUpperCase(),
    );
  }

  /// Fetches a voucher by [voucherId].
  Future<Voucher> getById(String voucherId) =>
      _repository.getVoucherById(voucherId);

  /// Lists paginated vouchers.
  Future<List<Voucher>> list({int page = 0, int size = 20}) =>
      _repository.getVouchers(page: page, size: size);

  /// Adds a payment to [voucherId].
  Future<Voucher> addPayment({
    required String voucherId,
    required double amount,
    required String method,
    String? idempotencyKey,
  }) {
    return _repository.addVoucherPayment(
      voucherId: voucherId,
      amount: amount,
      method: method.trim().toUpperCase(),
      idempotencyKey: idempotencyKey,
    );
  }

  /// Deletes [paymentId] from [voucherId].
  Future<void> deletePayment({
    required String voucherId,
    required String paymentId,
  }) {
    return _repository.deleteVoucherPayment(
      voucherId: voucherId,
      paymentId: paymentId,
    );
  }
}
