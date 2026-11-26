import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/shared/infrastructure/remote/dtos/shared_dto.dart';

/// HTTP client for `erp-integration-hub` identity validations, media uploads,
/// and service health checks.
class SharedApi {
  final ApiClient _apiClient;

  /// Creates a [SharedApi] backed by [_apiClient].
  const SharedApi(this._apiClient);

  /// Validates a Peruvian [ruc] against SUNAT.
  Future<RucValidationResultDto> validateRuc(String ruc) async {
    final response = await _apiClient.get(ApiConstants.validateRuc(ruc));
    return RucValidationResultDto.fromJson(response as Map<String, dynamic>);
  }

  /// Validates a vehicle license [plate].
  Future<PlateValidationResultDto> validatePlate(String plate) async {
    final response = await _apiClient.get(ApiConstants.validatePlate(plate));
    return PlateValidationResultDto.fromJson(
      response as Map<String, dynamic>,
    );
  }

  /// Performs a unified document lookup for [documentType] and
  /// [documentNumber].
  Future<DocumentLookupResultDto> lookupDocument({
    required String documentType,
    required String documentNumber,
  }) async {
    final response = await _apiClient.get(
      ApiConstants.identityLookup,
      queryParameters: {
        'documentType': documentType,
        'documentNumber': documentNumber,
      },
    );
    return DocumentLookupResultDto.fromJson(response as Map<String, dynamic>);
  }

  /// Uploads a media file at [filePath] to Cloudflare R2.
  Future<MediaUploadResultDto> uploadMedia({
    required String filePath,
    String folder = 'uploads',
    String? workOrderId,
    String? stage,
  }) async {
    final response = await _apiClient.multipartPost(
      ApiConstants.mediaUpload,
      filePath: filePath,
      fields: {
        'folder': folder,
        'workOrderId': ?workOrderId,
        'stage': ?stage,
      },
    );
    return MediaUploadResultDto.fromJson(response as Map<String, dynamic>);
  }

  /// Checks the health status of `erp-integration-hub`.
  Future<ServiceHealthStatusDto> checkHealth() async {
    final response = await _apiClient.get(ApiConstants.integrationHealth);
    return ServiceHealthStatusDto.fromJson(response as Map<String, dynamic>);
  }
}
