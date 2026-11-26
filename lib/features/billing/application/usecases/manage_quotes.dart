import 'package:mobile_application_driveos/features/billing/domain/billing_domain.dart';

/// Use case that creates, queries, updates, syncs, approves, and cancels
/// workshop quotes.
class ManageQuotes {
  final BillingRepository _repository;

  /// Creates a [ManageQuotes] use case.
  const ManageQuotes(this._repository);

  /// Creates a quote for [workOrderId] at [branchId].
  Future<Quote> create({
    required String workOrderId,
    required String branchId,
    double discountPercentage = 0.0,
    String? notes,
  }) {
    return _repository.createQuote(
      workOrderId: workOrderId,
      branchId: branchId,
      discountPercentage: discountPercentage,
      notes: notes?.trim(),
    );
  }

  /// Lists quotes belonging to the authenticated customer.
  Future<List<Quote>> listMine() => _repository.getMyQuotes();

  /// Fetches a quote by [quoteId].
  Future<Quote> getById(String quoteId) => _repository.getQuoteById(quoteId);

  /// Lists quotes for [branchId], optionally filtered by [status].
  Future<List<Quote>> listByBranch({
    required String branchId,
    String? status,
  }) {
    return _repository.getQuotesByBranch(branchId: branchId, status: status);
  }

  /// Updates discount percentage and notes for [quoteId].
  Future<Quote> update({
    required String quoteId,
    required double discountPercentage,
    String? notes,
  }) {
    return _repository.updateQuote(
      quoteId: quoteId,
      discountPercentage: discountPercentage,
      notes: notes?.trim(),
    );
  }

  /// Synchronizes [quoteId] items and totals with its work order.
  Future<Quote> sync(String quoteId) => _repository.syncQuote(quoteId);

  /// Approves [quoteId] for checkout.
  Future<Quote> approve(String quoteId) => _repository.approveQuote(quoteId);

  /// Cancels [quoteId].
  Future<Quote> cancel(String quoteId) => _repository.cancelQuote(quoteId);
}
