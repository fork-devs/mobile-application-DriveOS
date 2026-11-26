import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/core/infrastructure/remote/dtos/core_dto.dart';

/// HTTP client for `erp-tenant-service` workshop endpoints.
class WorkshopApi {
  final ApiClient _apiClient;

  /// Creates a [WorkshopApi] backed by [_apiClient].
  const WorkshopApi(this._apiClient);

  /// Lists workshops belonging to [ownerId].
  Future<List<WorkshopDto>> getWorkshopsByOwner(String ownerId) async {
    final response = await _apiClient.get(
      ApiConstants.workshops,
      queryParameters: {'ownerId': ownerId},
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => WorkshopDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Fetches a workshop by [workshopId].
  Future<WorkshopDto> getWorkshopById(String workshopId) async {
    final response = await _apiClient.get(
      ApiConstants.workshopById(workshopId),
    );
    return WorkshopDto.fromJson(response as Map<String, dynamic>);
  }

  /// Creates a new workshop.
  Future<WorkshopDto> createWorkshop({
    required String ownerId,
    required String businessName,
    required String brandName,
    required String taxId,
    int mileageIntervalConfig = 5000,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.workshops,
      body: {
        'ownerId': ownerId,
        'businessName': businessName,
        'brandName': brandName,
        'taxId': taxId,
        'mileageIntervalConfig': mileageIntervalConfig,
      },
    );
    return WorkshopDto.fromJson(response as Map<String, dynamic>);
  }

  /// Updates an existing workshop.
  Future<WorkshopDto> updateWorkshop({
    required String workshopId,
    required String businessName,
    required String brandName,
    required String taxId,
    int mileageIntervalConfig = 5000,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.workshopById(workshopId),
      body: {
        'businessName': businessName,
        'brandName': brandName,
        'taxId': taxId,
        'mileageIntervalConfig': mileageIntervalConfig,
      },
    );
    return WorkshopDto.fromJson(response as Map<String, dynamic>);
  }
}
