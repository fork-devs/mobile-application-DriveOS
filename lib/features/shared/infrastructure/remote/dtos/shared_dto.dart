import 'package:mobile_application_driveos/features/shared/domain/shared_domain.dart';

/// Wire DTO representing a [RucValidationResult].
class RucValidationResultDto {
  /// RUC number.
  final String ruc;

  /// Legal business name.
  final String razonSocial;

  /// Taxpayer status.
  final String estado;

  /// Taxpayer condition.
  final String condicion;

  /// Fiscal address.
  final String? direccionFiscal;

  /// Department.
  final String? departamento;

  /// Province.
  final String? provincia;

  /// District.
  final String? distrito;

  /// UBIGEO code.
  final String? ubigeo;

  /// Whether valid.
  final bool esValido;

  /// Whether served from cache.
  final bool fromCache;

  /// Creates a [RucValidationResultDto].
  const RucValidationResultDto({
    required this.ruc,
    required this.razonSocial,
    required this.estado,
    required this.condicion,
    this.direccionFiscal,
    this.departamento,
    this.provincia,
    this.distrito,
    this.ubigeo,
    required this.esValido,
    this.fromCache = false,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory RucValidationResultDto.fromJson(Map<String, dynamic> json) {
    if (json case {'ruc': final String ruc}) {
      return RucValidationResultDto(
        ruc: ruc,
        razonSocial: json['razonSocial']?.toString() ?? '',
        estado: json['estado']?.toString() ?? '',
        condicion: json['condicion']?.toString() ?? '',
        direccionFiscal: json['direccionFiscal']?.toString(),
        departamento: json['departamento']?.toString(),
        provincia: json['provincia']?.toString(),
        distrito: json['distrito']?.toString(),
        ubigeo: json['ubigeo']?.toString(),
        esValido: json['esValido'] == true,
        fromCache: json['fromCache'] == true,
      );
    }
    throw const FormatException('Invalid or incomplete RUC validation JSON.');
  }

  /// Converts this DTO into a [RucValidationResult] domain entity.
  RucValidationResult toDomain() => RucValidationResult(
        ruc: ruc,
        razonSocial: razonSocial,
        estado: estado,
        condicion: condicion,
        direccionFiscal: direccionFiscal,
        departamento: departamento,
        provincia: provincia,
        distrito: distrito,
        ubigeo: ubigeo,
        esValido: esValido,
        fromCache: fromCache,
      );
}

/// Wire DTO representing a [PlateValidationResult].
class PlateValidationResultDto {
  /// License plate.
  final String placa;

  /// Brand.
  final String? marca;

  /// Model.
  final String? modelo;

  /// VIN.
  final String? vin;

  /// Engine serial number.
  final String? numeroMotor;

  /// Manufacturing year.
  final String? anioFabricacion;

  /// Color.
  final String? color;

  /// Fuel type.
  final String? combustible;

  /// Whether valid.
  final bool esValido;

  /// Whether served from cache.
  final bool fromCache;

  /// Creates a [PlateValidationResultDto].
  const PlateValidationResultDto({
    required this.placa,
    this.marca,
    this.modelo,
    this.vin,
    this.numeroMotor,
    this.anioFabricacion,
    this.color,
    this.combustible,
    required this.esValido,
    this.fromCache = false,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory PlateValidationResultDto.fromJson(Map<String, dynamic> json) {
    if (json case {'placa': final String placa}) {
      return PlateValidationResultDto(
        placa: placa,
        marca: json['marca']?.toString(),
        modelo: json['modelo']?.toString(),
        vin: json['vin']?.toString(),
        numeroMotor: json['numeroMotor']?.toString(),
        anioFabricacion: json['anioFabricacion']?.toString(),
        color: json['color']?.toString(),
        combustible: json['combustible']?.toString(),
        esValido: json['esValido'] == true,
        fromCache: json['fromCache'] == true,
      );
    }
    throw const FormatException('Invalid or incomplete Plate validation JSON.');
  }

  /// Converts this DTO into a [PlateValidationResult] domain entity.
  PlateValidationResult toDomain() => PlateValidationResult(
        placa: placa,
        marca: marca,
        modelo: modelo,
        vin: vin,
        numeroMotor: numeroMotor,
        anioFabricacion: anioFabricacion,
        color: color,
        combustible: combustible,
        esValido: esValido,
        fromCache: fromCache,
      );
}

/// Wire DTO representing a [DocumentLookupResult].
class DocumentLookupResultDto {
  /// Document type.
  final String documentType;

  /// Document number.
  final String documentNumber;

  /// Full name or legal name.
  final String fullName;

  /// Whether valid.
  final bool valid;

  /// Whether served from cache.
  final bool fromCache;

  /// Creates a [DocumentLookupResultDto].
  const DocumentLookupResultDto({
    required this.documentType,
    required this.documentNumber,
    required this.fullName,
    required this.valid,
    this.fromCache = false,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory DocumentLookupResultDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'documentType': final String documentType,
      'documentNumber': final String documentNumber,
    }) {
      return DocumentLookupResultDto(
        documentType: documentType,
        documentNumber: documentNumber,
        fullName: json['fullName']?.toString() ?? '',
        valid: json['valid'] == true,
        fromCache: json['fromCache'] == true,
      );
    }
    throw const FormatException('Invalid or incomplete DocumentLookup JSON.');
  }

  /// Converts this DTO into a [DocumentLookupResult] domain entity.
  DocumentLookupResult toDomain() => DocumentLookupResult(
        documentType: documentType,
        documentNumber: documentNumber,
        fullName: fullName,
        valid: valid,
        fromCache: fromCache,
      );
}

/// Wire DTO representing a [MediaUploadResult].
class MediaUploadResultDto {
  /// Media identifier.
  final String mediaId;

  /// Public URL.
  final String url;

  /// Object key.
  final String objectKey;

  /// Immutability flag.
  final bool immutable;

  /// Creates a [MediaUploadResultDto].
  const MediaUploadResultDto({
    required this.mediaId,
    required this.url,
    required this.objectKey,
    this.immutable = true,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory MediaUploadResultDto.fromJson(Map<String, dynamic> json) {
    if (json case {'mediaId': final String mediaId, 'url': final String url}) {
      return MediaUploadResultDto(
        mediaId: mediaId,
        url: url,
        objectKey: json['objectKey']?.toString() ?? '',
        immutable: json['immutable'] != false,
      );
    }
    throw const FormatException('Invalid or incomplete MediaUpload JSON.');
  }

  /// Converts this DTO into a [MediaUploadResult] domain entity.
  MediaUploadResult toDomain() => MediaUploadResult(
        mediaId: mediaId,
        url: url,
        objectKey: objectKey,
        immutable: immutable,
      );
}

/// Wire DTO representing a [ServiceHealthStatus].
class ServiceHealthStatusDto {
  /// Health status (`UP`, etc.).
  final String status;

  /// Optional application name.
  final String? app;

  /// Creates a [ServiceHealthStatusDto].
  const ServiceHealthStatusDto({
    required this.status,
    this.app,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory ServiceHealthStatusDto.fromJson(Map<String, dynamic> json) {
    if (json case {'status': final String status}) {
      return ServiceHealthStatusDto(
        status: status,
        app: json['app']?.toString(),
      );
    }
    throw const FormatException('Invalid or incomplete Health JSON.');
  }

  /// Converts this DTO into a [ServiceHealthStatus] domain entity.
  ServiceHealthStatus toDomain() => ServiceHealthStatus(
        status: status,
        app: app,
      );
}
