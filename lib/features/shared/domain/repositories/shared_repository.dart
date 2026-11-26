import 'package:mobile_application_driveos/features/shared/domain/model/entities/identity_validation.dart';
import 'package:mobile_application_driveos/features/shared/domain/model/entities/media_and_health.dart';

/// Output port defining identity validation, media upload, and health check
/// operations against `erp-integration-hub`.
abstract interface class SharedRepository {
  /// Validates a Peruvian RUC number against SUNAT.
  Future<RucValidationResult> validateRuc(String ruc);

  /// Validates a vehicle license plate number.
  Future<PlateValidationResult> validatePlate(String plate);

  /// Performs a unified identity lookup for [documentType] and
  /// [documentNumber] (`DNI`, `CE`, or `RUC`).
  Future<DocumentLookupResult> lookupDocument({
    required String documentType,
    required String documentNumber,
  });

  /// Uploads a media file at [filePath] to Cloudflare R2.
  Future<MediaUploadResult> uploadMedia({
    required String filePath,
    String folder = 'uploads',
    String? workOrderId,
    String? stage,
  });

  /// Checks the health status of the integration hub service.
  Future<ServiceHealthStatus> checkHealth();
}
