import 'package:mobile_application_driveos/features/billing/domain/billing_domain.dart';
import 'package:mobile_application_driveos/features/billing/infrastructure/remote/billing_api.dart';

/// Concrete [BillingRepository] backed by `erp-billing-service` APIs.
class BillingRepositoryImpl implements BillingRepository {
  final BillingApi _billingApi;

  /// Creates a [BillingRepositoryImpl].
  const BillingRepositoryImpl({required this._billingApi});

  @override
  Future<Quote> createQuote({
    required String workOrderId,
    required String branchId,
    double discountPercentage = 0.0,
    String? notes,
  }) async {
    final dto = await _billingApi.createQuote(
      workOrderId: workOrderId,
      branchId: branchId,
      discountPercentage: discountPercentage,
      notes: notes,
    );
    return dto.toDomain();
  }

  @override
  Future<List<Quote>> getMyQuotes() async {
    final dtos = await _billingApi.getMyQuotes();
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Quote> getQuoteById(String quoteId) async {
    final dto = await _billingApi.getQuoteById(quoteId);
    return dto.toDomain();
  }

  @override
  Future<List<Quote>> getQuotesByBranch({
    required String branchId,
    String? status,
  }) async {
    final dtos = await _billingApi.getQuotesByBranch(
      branchId: branchId,
      status: status,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Quote> updateQuote({
    required String quoteId,
    required double discountPercentage,
    String? notes,
  }) async {
    final dto = await _billingApi.updateQuote(
      quoteId: quoteId,
      discountPercentage: discountPercentage,
      notes: notes,
    );
    return dto.toDomain();
  }

  @override
  Future<Quote> syncQuote(String quoteId) async {
    final dto = await _billingApi.syncQuote(quoteId);
    return dto.toDomain();
  }

  @override
  Future<Quote> approveQuote(String quoteId) async {
    final dto = await _billingApi.approveQuote(quoteId);
    return dto.toDomain();
  }

  @override
  Future<Quote> cancelQuote(String quoteId) async {
    final dto = await _billingApi.cancelQuote(quoteId);
    return dto.toDomain();
  }

  @override
  Future<CheckoutResult> directCheckout({
    required String quoteId,
    required String type,
    required String customerDocumentType,
    required String customerDocumentNumber,
    required String customerName,
    required String method,
  }) async {
    final dto = await _billingApi.directCheckout(
      quoteId: quoteId,
      type: type,
      customerDocumentType: customerDocumentType,
      customerDocumentNumber: customerDocumentNumber,
      customerName: customerName,
      method: method,
    );
    return dto.toDomain();
  }

  @override
  Future<CheckoutResult> mercadoPagoCheckout({
    required String quoteId,
    required String type,
    required String customerDocumentType,
    required String customerDocumentNumber,
    required String customerName,
    required String paymentId,
  }) async {
    final dto = await _billingApi.mercadoPagoCheckout(
      quoteId: quoteId,
      type: type,
      customerDocumentType: customerDocumentType,
      customerDocumentNumber: customerDocumentNumber,
      customerName: customerName,
      paymentId: paymentId,
    );
    return dto.toDomain();
  }

  @override
  Future<PaymentSession> createPaymentSession({
    String? quoteId,
    String? invoiceId,
    String provider = 'MERCADOPAGO',
  }) async {
    final dto = await _billingApi.createPaymentSession(
      quoteId: quoteId,
      invoiceId: invoiceId,
      provider: provider,
    );
    return dto.toDomain();
  }

  @override
  Future<Voucher> createVoucher({
    required String quoteId,
    required String type,
    required String customerDocumentType,
    required String customerDocumentNumber,
    required String customerName,
    required String method,
  }) async {
    final dto = await _billingApi.createVoucher(
      quoteId: quoteId,
      type: type,
      customerDocumentType: customerDocumentType,
      customerDocumentNumber: customerDocumentNumber,
      customerName: customerName,
      method: method,
    );
    return dto.toDomain();
  }

  @override
  Future<Voucher> getVoucherById(String voucherId) async {
    final dto = await _billingApi.getVoucherById(voucherId);
    return dto.toDomain();
  }

  @override
  Future<List<Voucher>> getVouchers({int page = 0, int size = 20}) async {
    final dtos = await _billingApi.getVouchers(page: page, size: size);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Voucher> addVoucherPayment({
    required String voucherId,
    required double amount,
    required String method,
    String? idempotencyKey,
  }) async {
    final dto = await _billingApi.addVoucherPayment(
      voucherId: voucherId,
      amount: amount,
      method: method,
      idempotencyKey: idempotencyKey,
    );
    return dto.toDomain();
  }

  @override
  Future<void> deleteVoucherPayment({
    required String voucherId,
    required String paymentId,
  }) =>
      _billingApi.deleteVoucherPayment(
        voucherId: voucherId,
        paymentId: paymentId,
      );
}
