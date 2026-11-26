import 'package:mobile_application_driveos/features/core/domain/core_domain.dart';

/// Use case that lists available subscription plans.
class GetPlans {
  final CoreRepository _repository;

  /// Creates a [GetPlans] use case.
  const GetPlans(this._repository);

  /// Returns all [SubscriptionPlan] options.
  Future<List<SubscriptionPlan>> call() => _repository.getPlans();
}

/// Use case that assigns a subscription plan to a branch.
class AssignBranchSubscription {
  final CoreRepository _repository;

  /// Creates an [AssignBranchSubscription] use case.
  const AssignBranchSubscription(this._repository);

  /// Assigns [planId] with [billingCycle] to [branchId].
  Future<BranchSubscription> call({
    required String branchId,
    required String planId,
    required String billingCycle,
  }) {
    return _repository.assignBranchSubscription(
      branchId: branchId,
      planId: planId,
      billingCycle: billingCycle.trim().toUpperCase(),
    );
  }
}

/// Use case that cancels a branch's active subscription.
class CancelBranchSubscription {
  final CoreRepository _repository;

  /// Creates a [CancelBranchSubscription] use case.
  const CancelBranchSubscription(this._repository);

  /// Cancels the subscription for [branchId].
  Future<void> call(String branchId) =>
      _repository.cancelBranchSubscription(branchId);
}
