import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/billing/infrastructure/remote/dtos/billing_dto.dart';

/// HTTP client for `erp-billing-service` quotes, checkouts, payment sessions,
/// and vouchers.
class BillingApi {
  final ApiClient _apiClient;

  /// Creates a [BillingApi] backed by [_apiClient].
  const BillingApi(this._apiClient);

  /// Creates a quote for [workOrderId] at [branchId].
  Future<QuoteDto> createQuote({
    required String workOrderId,
    required String branchId,
    double discountPercentage = 0.0,
    String? notes,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.quotes,
      body: {
        'workOrderId': workOrderId,
        'branchId': branchId,
        'discountPercentage': discountPercentage,
        'notes': ?notes,
      },
    );
    return QuoteDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists quotes belonging to the authenticated customer (`/me`).
  Future<List<QuoteDto>> getMyQuotes() async {
    final response = await _apiClient.get(ApiConstants.quotesMe);
    final list = response as List<dynamic>;
    return list
        .map((item) => QuoteDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetches a quote by [quoteId].
  Future<QuoteDto> getQuoteById(String quoteId) async {
    final response = await _apiClient.get(ApiConstants.quoteById(quoteId));
    return QuoteDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists quotes for [branchId], optionally filtered by [status].
  Future<List<QuoteDto>> getQuotesByBranch({
    required String branchId,
    String? status,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.quotes,
      queryParameters: {
        'branchId': branchId,
        'status': ?status,
      },
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => QuoteDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Updates discount percentage and notes for [quoteId].
  Future<QuoteDto> updateQuote({
    required String quoteId,
    required double discountPercentage,
    String? notes,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.quoteById(quoteId),
      body: {
        'discountPercentage': discountPercentage,
        'notes': ?notes,
      },
    );
    return QuoteDto.fromJson(response as Map<String, dynamic>);
  }

  /// Synchronizes [quoteId] with its work order.
  Future<QuoteDto> syncQuote(String quoteId) async {
    final response = await _apiClient.put(ApiConstants.quoteSync(quoteId));
    return QuoteDto.fromJson(response as Map<String, dynamic>);
  }

  /// Approves [quoteId].
  Future<QuoteDto> approveQuote(String quoteId) async {
    final response = await _apiClient.post(ApiConstants.quoteApprove(quoteId));
    return QuoteDto.fromJson(response as Map<String, dynamic>);
  }

  /// Cancels [quoteId].
  Future<QuoteDto> cancelQuote(String quoteId) async {
    final response = await _apiClient.post(ApiConstants.quoteCancel(quoteId));
    return QuoteDto.fromJson(response as Map<String, dynamic>);
  }

  /// Executes a direct checkout for [quoteId].
  Future<CheckoutResultDto> directCheckout({
    required String quoteId,
    required String type,
    required String customerDocumentType,
    required String customerDocumentNumber,
    required String customerName,
    required String method,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.checkouts,
      body: {
        'quoteId': quoteId,
        'type': type,
        'customerDocumentType': customerDocumentType,
        'customerDocumentNumber': customerDocumentNumber,
        'customerName': customerName,
        'method': method,
      },
    );
    return CheckoutResultDto.fromJson(response as Map<String, dynamic>);
  }

  /// Executes a Mercado Pago checkout for [quoteId].
  Future<CheckoutResultDto> mercadoPagoCheckout({
    required String quoteId,
    required String type,
    required String customerDocumentType,
    required String customerDocumentNumber,
    required String customerName,
    required String paymentId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.checkoutsMercadoPago,
      body: {
        'quoteId': quoteId,
        'type': type,
        'customerDocumentType': customerDocumentType,
        'customerDocumentNumber': customerDocumentNumber,
        'customerName': customerName,
        'paymentId': paymentId,
      },
    );
    return CheckoutResultDto.fromJson(response as Map<String, dynamic>);
  }

  /// Creates a payment session for [quoteId] or [invoiceId].
  Future<PaymentSessionDto> createPaymentSession({
    String? quoteId,
    String? invoiceId,
    String provider = 'MERCADOPAGO',
  }) async {
    final response = await _apiClient.post(
      ApiConstants.paymentSessions,
      body: {
        'quoteId': ?quoteId,
        'invoiceId': ?invoiceId,
        'provider': provider,
      },
    );
    return PaymentSessionDto.fromJson(response as Map<String, dynamic>);
  }

  /// Issues a voucher with an initial payment.
  Future<VoucherDto> createVoucher({
    required String quoteId,
    required String type,
    required String customerDocumentType,
    required String customerDocumentNumber,
    required String customerName,
    required String method,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.vouchers,
      body: {
        'quoteId': quoteId,
        'type': type,
        'customerDocumentType': customerDocumentType,
        'customerDocumentNumber': customerDocumentNumber,
        'customerName': customerName,
        'method': method,
      },
    );
    return VoucherDto.fromJson(response as Map<String, dynamic>);
  }

  /// Fetches a voucher by [voucherId].
  Future<VoucherDto> getVoucherById(String voucherId) async {
    final response = await _apiClient.get(
      ApiConstants.voucherById(voucherId),
    );
    return VoucherDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists paginated vouchers.
  Future<List<VoucherDto>> getVouchers({int page = 0, int size = 20}) async {
    final response = await _apiClient.get(
      ApiConstants.vouchers,
      queryParameters: {
        'page': page.toString(),
        'size': size.toString(),
      },
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => VoucherDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Adds a payment to [voucherId].
  Future<VoucherDto> addVoucherPayment({
    required String voucherId,
    required double amount,
    required String method,
    String? idempotencyKey,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.voucherPayments(voucherId),
      headers: {
        'Idempotency-Key': ?idempotencyKey,
      },
      body: {
        'amount': amount,
        'method': method,
      },
    );
    return VoucherDto.fromJson(response as Map<String, dynamic>);
  }

  /// Removes [paymentId] from [voucherId].
  Future<void> deleteVoucherPayment({
    required String voucherId,
    required String paymentId,
  }) async {
    await _apiClient.delete(
      ApiConstants.voucherPaymentById(voucherId, paymentId),
    );
  }
}
