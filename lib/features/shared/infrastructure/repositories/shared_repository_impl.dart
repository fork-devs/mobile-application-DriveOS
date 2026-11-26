import 'package:mobile_application_driveos/features/shared/domain/shared_domain.dart';
import 'package:mobile_application_driveos/features/shared/infrastructure/remote/shared_api.dart';

/// Concrete [SharedRepository] backed by `erp-integration-hub`.
class SharedRepositoryImpl implements SharedRepository {
  final SharedApi _sharedApi;

  /// Creates a [SharedRepositoryImpl].
  const SharedRepositoryImpl({required this._sharedApi});

  @override
  Future<RucValidationResult> validateRuc(String ruc) async {
    final dto = await _sharedApi.validateRuc(ruc);
    return dto.toDomain();
  }

  @override
  Future<PlateValidationResult> validatePlate(String plate) async {
    final dto = await _sharedApi.validatePlate(plate);
    return dto.toDomain();
  }

  @override
  Future<DocumentLookupResult> lookupDocument({
    required String documentType,
    required String documentNumber,
  }) async {
    final dto = await _sharedApi.lookupDocument(
      documentType: documentType,
      documentNumber: documentNumber,
    );
    return dto.toDomain();
  }

  @override
  Future<MediaUploadResult> uploadMedia({
    required String filePath,
    String folder = 'uploads',
    String? workOrderId,
    String? stage,
  }) async {
    final dto = await _sharedApi.uploadMedia(
      filePath: filePath,
      folder: folder,
      workOrderId: workOrderId,
      stage: stage,
    );
    return dto.toDomain();
  }

  @override
  Future<ServiceHealthStatus> checkHealth() async {
    final dto = await _sharedApi.checkHealth();
    return dto.toDomain();
  }
}
