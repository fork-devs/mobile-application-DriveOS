import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/operations/infrastructure/remote/dtos/operations_dto.dart';

/// HTTP client for `erp-work-order-service` workshop service catalog endpoints.
class ServiceApi {
  final ApiClient _apiClient;

  /// Creates a [ServiceApi] backed by [_apiClient].
  const ServiceApi(this._apiClient);

  /// Creates a new service in the catalog for [branchId].
  Future<WorkshopServiceDto> createService({
    required String branchId,
    required String name,
    required double price,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.services,
      body: {
        'branchId': branchId,
        'name': name,
        'price': price,
      },
    );
    return WorkshopServiceDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists services offered by [branchId].
  Future<List<WorkshopServiceDto>> getServicesByBranch(String branchId) async {
    final response = await _apiClient.get(
      ApiConstants.services,
      queryParameters: {'branchId': branchId},
    );
    final list = response as List<dynamic>;
    return list
        .map(
          (item) => WorkshopServiceDto.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Updates an existing catalog service.
  Future<WorkshopServiceDto> updateService({
    required String serviceId,
    required String name,
    required double price,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.serviceById(serviceId),
      body: {
        'name': name,
        'price': price,
      },
    );
    return WorkshopServiceDto.fromJson(response as Map<String, dynamic>);
  }

  /// Deletes a catalog service by [serviceId].
  Future<void> deleteService(String serviceId) async {
    await _apiClient.delete(ApiConstants.serviceById(serviceId));
  }
}
