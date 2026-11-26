import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';

/// Use case that manages supplemental part approvals and vehicle evidence
/// timelines for work orders.
class ManageEvidencesAndSupplements {
  final OperationsRepository _repository;

  /// Creates a [ManageEvidencesAndSupplements] use case.
  const ManageEvidencesAndSupplements(this._repository);

  /// Sends pending supervisor-checked supplements on [orderId] to the customer.
  Future<List<TaskProduct>> sendSupplementsToCustomer(String orderId) =>
      _repository.sendSupplementsToCustomer(orderId);

  /// Approves pending supplements on [orderId].
  Future<List<TaskProduct>> approveSupplements(String orderId) =>
      _repository.approveSupplements(orderId);

  /// Rejects pending supplements on [orderId].
  Future<List<TaskProduct>> rejectSupplements(String orderId) =>
      _repository.rejectSupplements(orderId);

  /// Uploads an immutable vehicle evidence photo to [orderId].
  Future<WorkOrderEvidence> uploadEvidence({
    required String orderId,
    required String filePath,
    String stage = 'RECEPTION',
    String? caption,
  }) {
    return _repository.uploadWorkOrderEvidence(
      orderId: orderId,
      filePath: filePath,
      stage: stage.trim().toUpperCase(),
      caption: caption?.trim(),
    );
  }

  /// Lists the chronological evidence timeline for [orderId].
  Future<List<WorkOrderEvidence>> listEvidences(String orderId) =>
      _repository.getWorkOrderEvidences(orderId);
}
