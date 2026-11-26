import 'package:mobile_application_driveos/features/shared/domain/shared_domain.dart';

/// Use case that validates Peruvian identity documents and vehicle plates.
class ManageIdentityValidations {
  final SharedRepository _repository;

  /// Creates a [ManageIdentityValidations] use case.
  const ManageIdentityValidations(this._repository);

  /// Validates a SUNAT [ruc] number.
  Future<RucValidationResult> validateRuc(String ruc) =>
      _repository.validateRuc(ruc.trim());

  /// Validates a vehicle license [plate].
  Future<PlateValidationResult> validatePlate(String plate) =>
      _repository.validatePlate(plate.trim().toUpperCase());

  /// Looks up an identity document by [documentType] (`DNI`, `CE`, `RUC`) and
  /// [documentNumber].
  Future<DocumentLookupResult> lookupDocument({
    required String documentType,
    required String documentNumber,
  }) {
    return _repository.lookupDocument(
      documentType: documentType.trim().toUpperCase(),
      documentNumber: documentNumber.trim(),
    );
  }
}

/// Use case that uploads media files to Cloudflare R2 and checks service
/// health.
class ManageMediaAndHealth {
  final SharedRepository _repository;

  /// Creates a [ManageMediaAndHealth] use case.
  const ManageMediaAndHealth(this._repository);

  /// Uploads [filePath] to Cloudflare R2 inside [folder].
  Future<MediaUploadResult> uploadMedia({
    required String filePath,
    String folder = 'uploads',
    String? workOrderId,
    String? stage,
  }) {
    return _repository.uploadMedia(
      filePath: filePath,
      folder: folder.trim(),
      workOrderId: workOrderId,
      stage: stage?.trim().toUpperCase(),
    );
  }

  /// Checks the health of `erp-integration-hub`.
  Future<ServiceHealthStatus> checkHealth() => _repository.checkHealth();
}
