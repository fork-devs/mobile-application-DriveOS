/// Represents a SUNAT RUC validation result.
class RucValidationResult {
  /// The 11-digit RUC number.
  final String ruc;

  /// Registered legal name.
  final String razonSocial;

  /// Taxpayer status (e.g. `ACTIVO`).
  final String estado;

  /// Taxpayer address condition (e.g. `HABIDO`).
  final String condicion;

  /// Fiscal street address.
  final String? direccionFiscal;

  /// Department name.
  final String? departamento;

  /// Province name.
  final String? provincia;

  /// District name.
  final String? distrito;

  /// UBIGEO code.
  final String? ubigeo;

  /// Whether the RUC is valid.
  final bool esValido;

  /// Whether this response was served from cache.
  final bool fromCache;

  /// Creates a [RucValidationResult].
  const RucValidationResult({
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
}

/// Represents a vehicle license plate validation result.
class PlateValidationResult {
  /// The license plate number.
  final String placa;

  /// Vehicle manufacturer brand.
  final String? marca;

  /// Vehicle model name.
  final String? modelo;

  /// Vehicle Identification Number (VIN).
  final String? vin;

  /// Engine serial number.
  final String? numeroMotor;

  /// Manufacturing year as string.
  final String? anioFabricacion;

  /// Vehicle color.
  final String? color;

  /// Fuel type.
  final String? combustible;

  /// Whether the plate is valid.
  final bool esValido;

  /// Whether this response was served from cache.
  final bool fromCache;

  /// Creates a [PlateValidationResult].
  const PlateValidationResult({
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
}

/// Represents a unified identity document lookup result (`DNI`, `CE`, `RUC`).
class DocumentLookupResult {
  /// Document type (`DNI`, `CE`, `RUC`).
  final String documentType;

  /// Document number.
  final String documentNumber;

  /// Resolved full name or legal name.
  final String fullName;

  /// Whether the document is valid.
  final bool valid;

  /// Whether this response was served from cache.
  final bool fromCache;

  /// Creates a [DocumentLookupResult].
  const DocumentLookupResult({
    required this.documentType,
    required this.documentNumber,
    required this.fullName,
    required this.valid,
    this.fromCache = false,
  });
}
