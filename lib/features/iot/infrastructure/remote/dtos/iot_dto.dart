import 'package:mobile_application_driveos/features/iot/domain/iot_domain.dart';

/// Wire DTO representing an OBD2 device from `erp-iot-ingestion`.
class Obd2DeviceDto {
  /// Device identifier.
  final String id;

  /// Branch identifier.
  final String branchId;

  /// MAC address.
  final String macAddress;

  /// Device status (`AVAILABLE` or `LINKED`).
  final String status;

  /// Creates an [Obd2DeviceDto].
  const Obd2DeviceDto({
    required this.id,
    required this.branchId,
    required this.macAddress,
    required this.status,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory Obd2DeviceDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'branchId': final String branchId,
      'macAddress': final String macAddress,
    }) {
      return Obd2DeviceDto(
        id: id,
        branchId: branchId,
        macAddress: macAddress,
        status: json['status']?.toString() ?? 'AVAILABLE',
      );
    }
    throw const FormatException('Invalid or incomplete Obd2Device JSON.');
  }

  /// Converts this DTO into an [Obd2Device] domain entity.
  Obd2Device toDomain() => Obd2Device(
        id: id,
        branchId: branchId,
        macAddress: macAddress,
        status: status,
      );
}

/// Wire DTO representing an OBD2 device registration.
class Obd2DeviceRegistrationDto {
  /// Registration identifier.
  final String id;

  /// Device identifier.
  final String obd2DeviceId;

  /// Branch identifier.
  final String branchId;

  /// Vehicle identifier.
  final String vehicleId;

  /// Registration status (`ACTIVE` or `INACTIVE`).
  final String status;

  /// Creation timestamp.
  final DateTime? createdAt;

  /// Creates an [Obd2DeviceRegistrationDto].
  const Obd2DeviceRegistrationDto({
    required this.id,
    required this.obd2DeviceId,
    required this.branchId,
    required this.vehicleId,
    required this.status,
    this.createdAt,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory Obd2DeviceRegistrationDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': final String id,
      'obd2DeviceId': final String obd2DeviceId,
      'branchId': final String branchId,
      'vehicleId': final String vehicleId,
    }) {
      return Obd2DeviceRegistrationDto(
        id: id,
        obd2DeviceId: obd2DeviceId,
        branchId: branchId,
        vehicleId: vehicleId,
        status: json['status']?.toString() ?? 'ACTIVE',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
      );
    }
    throw const FormatException(
      'Invalid or incomplete Obd2DeviceRegistration JSON.',
    );
  }

  /// Converts this DTO into an [Obd2DeviceRegistration] domain entity.
  Obd2DeviceRegistration toDomain() => Obd2DeviceRegistration(
        id: id,
        obd2DeviceId: obd2DeviceId,
        branchId: branchId,
        vehicleId: vehicleId,
        status: status,
        createdAt: createdAt,
      );
}

/// Wire DTO representing a [TelemetryLocation].
class TelemetryLocationDto {
  /// Latitude.
  final double latitude;

  /// Longitude.
  final double longitude;

  /// Altitude in meters.
  final double? altitude;

  /// Heading in degrees.
  final double? heading;

  /// Creates a [TelemetryLocationDto].
  const TelemetryLocationDto({
    required this.latitude,
    required this.longitude,
    this.altitude,
    this.heading,
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory TelemetryLocationDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'latitude': final num latitude,
      'longitude': final num longitude,
    }) {
      return TelemetryLocationDto(
        latitude: latitude.toDouble(),
        longitude: longitude.toDouble(),
        altitude: (json['altitude'] as num?)?.toDouble(),
        heading: (json['heading'] as num?)?.toDouble(),
      );
    }
    throw const FormatException(
      'Invalid or incomplete TelemetryLocation JSON.',
    );
  }

  /// Converts this DTO into a [TelemetryLocation] domain entity.
  TelemetryLocation toDomain() => TelemetryLocation(
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
        heading: heading,
      );
}

/// Wire DTO representing a [DtcAlert] from `erp-iot-processor`.
class DtcAlertDto {
  /// Alert identifier.
  final String id;

  /// Vehicle identifier.
  final String vehicleId;

  /// DTC code.
  final String dtcCode;

  /// Severity level.
  final String severity;

  /// Optional short title.
  final String? title;

  /// Fault description.
  final String description;

  /// Timestamp.
  final DateTime? createdAt;

  /// Creates a [DtcAlertDto].
  const DtcAlertDto({
    required this.id,
    required this.vehicleId,
    required this.dtcCode,
    required this.severity,
    this.title,
    required this.description,
    this.createdAt,
  });

  /// Deserializes [json] supporting both `diagnostics` and `dtc-alerts`
  /// field conventions.
  factory DtcAlertDto.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString();
    final vehicleId =
        json['vehicle_id']?.toString() ?? json['vehicleId']?.toString();
    final code =
        json['dtc_code']?.toString() ??
        json['code']?.toString() ??
        json['dtcCode']?.toString();

    if (id != null && vehicleId != null && code != null) {
      final rawTime = json['created_at'] ?? json['timestamp'];
      return DtcAlertDto(
        id: id,
        vehicleId: vehicleId,
        dtcCode: code,
        severity: json['severity']?.toString() ?? 'WARNING',
        title: json['title']?.toString(),
        description: json['description']?.toString() ?? '',
        createdAt: rawTime != null ? DateTime.tryParse(rawTime.toString()) : null,
      );
    }
    throw const FormatException('Invalid or incomplete DtcAlert JSON.');
  }

  /// Converts this DTO into a [DtcAlert] domain entity.
  DtcAlert toDomain() => DtcAlert(
        id: id,
        vehicleId: vehicleId,
        dtcCode: dtcCode,
        severity: severity,
        title: title,
        description: description,
        createdAt: createdAt,
      );
}

/// Wire DTO representing a [TelemetrySnapshot] from `erp-iot-processor`.
class TelemetrySnapshotDto {
  /// Optional snapshot identifier.
  final String? id;

  /// Optional registration identifier.
  final String? registrationId;

  /// Optional branch identifier.
  final String? branchId;

  /// Optional device identifier.
  final String? deviceId;

  /// Vehicle identifier.
  final String vehicleId;

  /// Engine RPM.
  final int rpm;

  /// Coolant temperature in Celsius.
  final double coolantTempC;

  /// Speed in km/h.
  final double speedKmh;

  /// Optional odometer reading.
  final double? odometerKm;

  /// Fuel level percentage.
  final double fuelLevelPercent;

  /// Optional battery voltage.
  final double? batteryVoltage;

  /// Snapshot timestamp.
  final DateTime timestamp;

  /// Creates a [TelemetrySnapshotDto].
  const TelemetrySnapshotDto({
    this.id,
    this.registrationId,
    this.branchId,
    this.deviceId,
    required this.vehicleId,
    required this.rpm,
    required this.coolantTempC,
    required this.speedKmh,
    this.odometerKm,
    required this.fuelLevelPercent,
    this.batteryVoltage,
    required this.timestamp,
  });

  /// Deserializes [json] supporting both snake_case and camelCase endpoints.
  factory TelemetrySnapshotDto.fromJson(Map<String, dynamic> json) {
    final vehicleId =
        json['vehicle_id']?.toString() ?? json['vehicleId']?.toString();
    if (vehicleId == null || vehicleId.isEmpty) {
      throw const FormatException(
        'Invalid or incomplete TelemetrySnapshot JSON.',
      );
    }

    final rawTime = json['time'] ?? json['createdAt'];
    return TelemetrySnapshotDto(
      id: json['id']?.toString(),
      registrationId: json['obd2DeviceRegistrationId']?.toString(),
      branchId: json['branchId']?.toString(),
      deviceId: json['device_id']?.toString() ?? json['deviceId']?.toString(),
      vehicleId: vehicleId,
      rpm:
          (json['engine_rpm'] as num?)?.toInt() ??
          (json['rpm'] as num?)?.toInt() ??
          0,
      coolantTempC:
          (json['coolant_temp_c'] as num?)?.toDouble() ??
          (json['temperature'] as num?)?.toDouble() ??
          0.0,
      speedKmh:
          (json['speed_kmh'] as num?)?.toDouble() ??
          (json['speedKmh'] as num?)?.toDouble() ??
          0.0,
      odometerKm: (json['odometerKm'] as num?)?.toDouble(),
      fuelLevelPercent:
          (json['fuel_level_percent'] as num?)?.toDouble() ??
          (json['fuelLevelPercent'] as num?)?.toDouble() ??
          0.0,
      batteryVoltage:
          (json['battery_voltage'] as num?)?.toDouble() ??
          (json['batteryVoltage'] as num?)?.toDouble(),
      timestamp: rawTime != null
          ? (DateTime.tryParse(rawTime.toString()) ?? DateTime.now())
          : DateTime.now(),
    );
  }

  /// Converts this DTO into a [TelemetrySnapshot] domain entity.
  TelemetrySnapshot toDomain() => TelemetrySnapshot(
        id: id,
        registrationId: registrationId,
        branchId: branchId,
        deviceId: deviceId,
        vehicleId: vehicleId,
        rpm: rpm,
        coolantTempC: coolantTempC,
        speedKmh: speedKmh,
        odometerKm: odometerKm,
        fuelLevelPercent: fuelLevelPercent,
        batteryVoltage: batteryVoltage,
        timestamp: timestamp,
      );
}

/// Wire DTO representing a [VehicleDiagnostics] summary.
class VehicleDiagnosticsDto {
  /// Tenant identifier.
  final String tenantId;

  /// Vehicle identifier.
  final String vehicleId;

  /// Overall status (`HEALTHY`, `WARNING`, `CRITICAL`).
  final String overallStatus;

  /// Latest telemetry timestamp.
  final DateTime? lastTimestamp;

  /// Latest GPS location.
  final TelemetryLocationDto? lastLocation;

  /// Latest speed in km/h.
  final double? lastSpeedKmh;

  /// Latest engine RPM.
  final int? lastEngineRpm;

  /// Latest coolant temperature.
  final double? lastCoolantTempC;

  /// Latest battery voltage.
  final double? lastBatteryVoltage;

  /// Latest fuel level percentage.
  final double? lastFuelLevelPercent;

  /// Active DTC codes.
  final List<String> activeDtcs;

  /// Active alerts.
  final List<DtcAlertDto> activeAlerts;

  /// Recent alerts.
  final List<DtcAlertDto> recentAlerts;

  /// Creates a [VehicleDiagnosticsDto].
  const VehicleDiagnosticsDto({
    required this.tenantId,
    required this.vehicleId,
    required this.overallStatus,
    this.lastTimestamp,
    this.lastLocation,
    this.lastSpeedKmh,
    this.lastEngineRpm,
    this.lastCoolantTempC,
    this.lastBatteryVoltage,
    this.lastFuelLevelPercent,
    this.activeDtcs = const [],
    this.activeAlerts = const [],
    this.recentAlerts = const [],
  });

  /// Deserializes [json] using Dart 3 map pattern matching.
  factory VehicleDiagnosticsDto.fromJson(Map<String, dynamic> json) {
    if (json case {
      'tenant_id': final String tenantId,
      'vehicle_id': final String vehicleId,
    }) {
      final rawLocation = json['last_location'];
      final rawDtcs = json['active_dtcs'];
      final rawActiveAlerts = json['active_alerts'];
      final rawRecentAlerts = json['recent_alerts'];

      return VehicleDiagnosticsDto(
        tenantId: tenantId,
        vehicleId: vehicleId,
        overallStatus: json['overall_status']?.toString() ?? 'HEALTHY',
        lastTimestamp: json['last_timestamp'] != null
            ? DateTime.tryParse(json['last_timestamp'].toString())
            : null,
        lastLocation: rawLocation is Map<String, dynamic>
            ? TelemetryLocationDto.fromJson(rawLocation)
            : null,
        lastSpeedKmh: (json['last_speed_kmh'] as num?)?.toDouble(),
        lastEngineRpm: (json['last_engine_rpm'] as num?)?.toInt(),
        lastCoolantTempC: (json['last_coolant_temp_c'] as num?)?.toDouble(),
        lastBatteryVoltage: (json['last_battery_voltage'] as num?)?.toDouble(),
        lastFuelLevelPercent:
            (json['last_fuel_level_percent'] as num?)?.toDouble(),
        activeDtcs: rawDtcs is List
            ? rawDtcs.map((code) => code.toString()).toList()
            : const <String>[],
        activeAlerts: rawActiveAlerts is List
            ? rawActiveAlerts
                  .whereType<Map<String, dynamic>>()
                  .map(DtcAlertDto.fromJson)
                  .toList()
            : const <DtcAlertDto>[],
        recentAlerts: rawRecentAlerts is List
            ? rawRecentAlerts
                  .whereType<Map<String, dynamic>>()
                  .map(DtcAlertDto.fromJson)
                  .toList()
            : const <DtcAlertDto>[],
      );
    }
    throw const FormatException(
      'Invalid or incomplete VehicleDiagnostics JSON.',
    );
  }

  /// Converts this DTO into a [VehicleDiagnostics] domain entity.
  VehicleDiagnostics toDomain() => VehicleDiagnostics(
        tenantId: tenantId,
        vehicleId: vehicleId,
        overallStatus: overallStatus,
        lastTimestamp: lastTimestamp,
        lastLocation: lastLocation?.toDomain(),
        lastSpeedKmh: lastSpeedKmh,
        lastEngineRpm: lastEngineRpm,
        lastCoolantTempC: lastCoolantTempC,
        lastBatteryVoltage: lastBatteryVoltage,
        lastFuelLevelPercent: lastFuelLevelPercent,
        activeDtcs: activeDtcs,
        activeAlerts: activeAlerts.map((alert) => alert.toDomain()).toList(),
        recentAlerts: recentAlerts.map((alert) => alert.toDomain()).toList(),
      );
}

/// Wire DTO representing a [SimulatorStatus] response.
class SimulatorStatusDto {
  /// Whether the simulator is running.
  final bool isRunning;

  /// Active scenario.
  final String? scenario;

  /// Emission mode.
  final String? emissionMode;

  /// Branch identifier.
  final String? branchId;

  /// Total sent messages.
  final int totalSent;

  /// Total succeeded messages.
  final int totalSuccess;

  /// Total failed messages.
  final int totalFailed;

  /// Throughput in messages per second.
  final double currentThroughputMps;

  /// Last error message.
  final String? lastError;

  /// Creates a [SimulatorStatusDto].
  const SimulatorStatusDto({
    required this.isRunning,
    this.scenario,
    this.emissionMode,
    this.branchId,
    this.totalSent = 0,
    this.totalSuccess = 0,
    this.totalFailed = 0,
    this.currentThroughputMps = 0.0,
    this.lastError,
  });

  /// Deserializes [json] from `/simulator/start` or `/simulator/status`.
  factory SimulatorStatusDto.fromJson(Map<String, dynamic> json) {
    final running =
        json['is_running'] == true || json['status'] == 'started';
    return SimulatorStatusDto(
      isRunning: running,
      scenario: json['scenario']?.toString(),
      emissionMode: json['emission_mode']?.toString(),
      branchId: json['branch_id']?.toString(),
      totalSent: (json['total_sent'] as num?)?.toInt() ?? 0,
      totalSuccess: (json['total_success'] as num?)?.toInt() ?? 0,
      totalFailed: (json['total_failed'] as num?)?.toInt() ?? 0,
      currentThroughputMps:
          (json['current_throughput_mps'] as num?)?.toDouble() ?? 0.0,
      lastError: json['last_error']?.toString(),
    );
  }

  /// Converts this DTO into a [SimulatorStatus] domain entity.
  SimulatorStatus toDomain() => SimulatorStatus(
        isRunning: isRunning,
        scenario: scenario,
        emissionMode: emissionMode,
        branchId: branchId,
        totalSent: totalSent,
        totalSuccess: totalSuccess,
        totalFailed: totalFailed,
        currentThroughputMps: currentThroughputMps,
        lastError: lastError,
      );
}
