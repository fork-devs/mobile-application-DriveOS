import 'package:mobile_application_driveos/features/billing/domain/model/entities/quote.dart';
import 'package:mobile_application_driveos/features/billing/domain/model/entities/voucher_and_checkout.dart';

/// Output port defining quote, checkout, voucher, and payment session
/// operations.
abstract interface class BillingRepository {
  // Quotes
  /// Creates a quote for [workOrderId] at [branchId].
  Future<Quote> createQuote({
    required String workOrderId,
    required String branchId,
    double discountPercentage = 0.0,
    String? notes,
  });

  /// Lists quotes belonging to the authenticated customer (`/me`).
  Future<List<Quote>> getMyQuotes();

  /// Fetches a quote by [quoteId].
  Future<Quote> getQuoteById(String quoteId);

  /// Lists quotes for [branchId], optionally filtered by [status].
  Future<List<Quote>> getQuotesByBranch({
    required String branchId,
    String? status,
  });

  /// Updates discount percentage and notes for [quoteId].
  Future<Quote> updateQuote({
    required String quoteId,
    required double discountPercentage,
    String? notes,
  });

  /// Synchronizes [quoteId] items and totals with its work order.
  Future<Quote> syncQuote(String quoteId);

  /// Approves [quoteId] for checkout.
  Future<Quote> approveQuote(String quoteId);

  /// Cancels [quoteId].
  Future<Quote> cancelQuote(String quoteId);

  // Checkouts & Payment Sessions
  /// Executes a direct checkout (`CASH`, `CARD`, etc.) for [quoteId].
  Future<CheckoutResult> directCheckout({
    required String quoteId,
    required String type,
    required String customerDocumentType,
    required String customerDocumentNumber,
    required String customerName,
    required String method,
  });

  /// Executes a Mercado Pago checkout using a validated [paymentId].
  Future<CheckoutResult> mercadoPagoCheckout({
    required String quoteId,
    required String type,
    required String customerDocumentType,
    required String customerDocumentNumber,
    required String customerName,
    required String paymentId,
  });

  /// Creates a payment session (e.g. `MERCADOPAGO`) for [quoteId] or
  /// [invoiceId].
  Future<PaymentSession> createPaymentSession({
    String? quoteId,
    String? invoiceId,
    String provider = 'MERCADOPAGO',
  });

  // Vouchers
  /// Issues a voucher with an initial payment.
  Future<Voucher> createVoucher({
    required String quoteId,
    required String type,
    required String customerDocumentType,
    required String customerDocumentNumber,
    required String customerName,
    required String method,
  });

  /// Fetches a voucher by [voucherId].
  Future<Voucher> getVoucherById(String voucherId);

  /// Lists paginated vouchers in the active tenant.
  Future<List<Voucher>> getVouchers({int page = 0, int size = 20});

  /// Adds a partial or full payment to [voucherId].
  Future<Voucher> addVoucherPayment({
    required String voucherId,
    required double amount,
    required String method,
    String? idempotencyKey,
  });

  /// Removes [paymentId] from [voucherId].
  Future<void> deleteVoucherPayment({
    required String voucherId,
    required String paymentId,
  });
}
