import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';
import 'package:mobile_application_driveos/features/operations/infrastructure/remote/dtos/operations_dto.dart';

/// HTTP client for `erp-work-order-service` work orders, supplements, and
/// multimedia evidences.
class WorkOrderApi {
  final ApiClient _apiClient;

  /// Creates a [WorkOrderApi] backed by [_apiClient].
  const WorkOrderApi(this._apiClient);

  /// Opens a new work order.
  Future<WorkOrderDto> openWorkOrder({
    required String customerId,
    required String vehicleId,
    required String branchId,
    String? mechanicId,
    required String diagnosis,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.workOrders,
      body: {
        'customerId': customerId,
        'vehicleId': vehicleId,
        'branchId': branchId,
        'mechanicId': ?mechanicId,
        'diagnosis': diagnosis,
      },
    );
    return WorkOrderDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists work orders in the tenant, optionally filtered by [status].
  Future<List<WorkOrderDto>> getWorkOrders({String? status}) async {
    final response = await _apiClient.get(
      ApiConstants.workOrders,
      queryParameters: {'status': ?status},
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => WorkOrderDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Lists work orders belonging to the authenticated customer (`/me`).
  Future<List<WorkOrderDto>> getMyWorkOrders() async {
    final response = await _apiClient.get(ApiConstants.workOrdersMe);
    final list = response as List<dynamic>;
    return list
        .map((item) => WorkOrderDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetches work order details by [orderId].
  Future<WorkOrderDto> getWorkOrderById(String orderId) async {
    final response = await _apiClient.get(ApiConstants.workOrderById(orderId));
    return WorkOrderDto.fromJson(response as Map<String, dynamic>);
  }

  /// Updates diagnostic summary, diagnosis, or intake mileage.
  Future<WorkOrderDto> updateWorkOrder({
    required String orderId,
    String? diagnosticSummary,
    required String diagnosis,
    int? mileageIn,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.workOrderById(orderId),
      body: {
        'diagnosticSummary': ?diagnosticSummary,
        'diagnosis': diagnosis,
        'mileageIn': ?mileageIn,
      },
    );
    return WorkOrderDto.fromJson(response as Map<String, dynamic>);
  }

  /// Deletes [orderId].
  Future<void> deleteWorkOrder(String orderId) async {
    await _apiClient.delete(ApiConstants.workOrderById(orderId));
  }

  /// Adds spare parts and labor items to [orderId].
  Future<List<String>> addWorkOrderItems({
    required String orderId,
    required List<WorkOrderItem> items,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderItems(orderId),
      body: {
        'items': items
            .map(
              (item) => {
                'sparePartId': item.sparePartId,
                'quantity': item.quantity,
                'laborPrice': item.laborPrice,
              },
            )
            .toList(),
      },
    );
    final list = response as List<dynamic>;
    return list.map((item) => item.toString()).toList();
  }

  /// Transitions [orderId] to [destination].
  Future<WorkOrderTransitionResultDto> transitionWorkOrder({
    required String orderId,
    required String destination,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderTransition(orderId),
      body: {'destination': destination},
    );
    return WorkOrderTransitionResultDto.fromJson(
      response as Map<String, dynamic>,
    );
  }

  /// Marks [orderId] as completed.
  Future<WorkOrderTransitionResultDto> completeWorkOrder(String orderId) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderComplete(orderId),
    );
    return WorkOrderTransitionResultDto.fromJson(
      response as Map<String, dynamic>,
    );
  }

  /// Moves [orderId] to quoted status.
  Future<WorkOrderTransitionResultDto> quoteWorkOrder(String orderId) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderQuote(orderId),
    );
    return WorkOrderTransitionResultDto.fromJson(
      response as Map<String, dynamic>,
    );
  }

  /// Approves [orderId].
  Future<WorkOrderTransitionResultDto> approveWorkOrder(String orderId) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderApprove(orderId),
    );
    return WorkOrderTransitionResultDto.fromJson(
      response as Map<String, dynamic>,
    );
  }

  /// Rejects [orderId].
  Future<WorkOrderTransitionResultDto> rejectWorkOrder(String orderId) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderReject(orderId),
    );
    return WorkOrderTransitionResultDto.fromJson(
      response as Map<String, dynamic>,
    );
  }

  /// Cancels [orderId].
  Future<WorkOrderTransitionResultDto> cancelWorkOrder(String orderId) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderCancel(orderId),
    );
    return WorkOrderTransitionResultDto.fromJson(
      response as Map<String, dynamic>,
    );
  }

  /// Sends pending supervisor-checked supplements on [orderId] to the customer.
  Future<List<TaskProductDto>> sendSupplementsToCustomer(String orderId) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderSupplementsSend(orderId),
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => TaskProductDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Approves pending supplements on [orderId].
  Future<List<TaskProductDto>> approveSupplements(String orderId) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderSupplementsApprove(orderId),
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => TaskProductDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Rejects pending supplements on [orderId].
  Future<List<TaskProductDto>> rejectSupplements(String orderId) async {
    final response = await _apiClient.post(
      ApiConstants.workOrderSupplementsReject(orderId),
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => TaskProductDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Uploads an immutable vehicle evidence photo to [orderId].
  Future<WorkOrderEvidenceDto> uploadWorkOrderEvidence({
    required String orderId,
    required String filePath,
    String stage = 'RECEPTION',
    String? caption,
  }) async {
    final response = await _apiClient.multipartPost(
      ApiConstants.workOrderEvidences(orderId),
      filePath: filePath,
      fields: {
        'stage': stage,
        'caption': ?caption,
      },
    );
    return WorkOrderEvidenceDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists the chronological evidence timeline for [orderId].
  Future<List<WorkOrderEvidenceDto>> getWorkOrderEvidences(
    String orderId,
  ) async {
    final response = await _apiClient.get(
      ApiConstants.workOrderEvidences(orderId),
    );
    final list = response as List<dynamic>;
    return list
        .map(
          (item) => WorkOrderEvidenceDto.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }
}
