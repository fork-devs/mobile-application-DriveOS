import 'package:mobile_application_driveos/core/network/api_client.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/features/fleet/infrastructure/remote/dtos/fleet_dto.dart';

/// HTTP client for `erp-fleet-service` customer and vehicle endpoints.
class CustomerVehicleApi {
  final ApiClient _apiClient;

  /// Creates a [CustomerVehicleApi] backed by [_apiClient].
  const CustomerVehicleApi(this._apiClient);

  /// Registers a new customer.
  Future<CustomerDto> createCustomer({
    required String fullName,
    required String email,
    required String phone,
    required String docType,
    required String docNumber,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.customers,
      body: {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'docType': docType,
        'docNumber': docNumber,
      },
    );
    return CustomerDto.fromJson(response as Map<String, dynamic>);
  }

  /// Fetches a customer by [customerId].
  Future<CustomerDto> getCustomerById(String customerId) async {
    final response = await _apiClient.get(
      ApiConstants.customerById(customerId),
    );
    return CustomerDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists all customers in the active tenant.
  Future<List<CustomerDto>> getCustomers() async {
    final response = await _apiClient.get(ApiConstants.customers);
    final list = response as List<dynamic>;
    return list
        .map((item) => CustomerDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Updates [customerId].
  Future<CustomerDto> updateCustomer({
    required String customerId,
    required String fullName,
    required String email,
    required String phone,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.customerById(customerId),
      body: {
        'fullName': fullName,
        'email': email,
        'phone': phone,
      },
    );
    return CustomerDto.fromJson(response as Map<String, dynamic>);
  }

  /// Deletes [customerId].
  Future<void> deleteCustomer(String customerId) async {
    await _apiClient.delete(ApiConstants.customerById(customerId));
  }

  /// Triggers identity revalidation for [customerId].
  Future<void> validateCustomer(String customerId) async {
    await _apiClient.post(ApiConstants.customerValidate(customerId));
  }

  /// Lists vehicles belonging to [customerId].
  Future<List<VehicleDto>> getCustomerVehicles(String customerId) async {
    final response = await _apiClient.get(
      ApiConstants.customerVehicles(customerId),
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => VehicleDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Registers a new vehicle.
  Future<VehicleDto> createVehicle({
    required String customerId,
    required String plate,
    required String brand,
    required String model,
    required int year,
    required String vin,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.vehicles,
      body: {
        'customerId': customerId,
        'plate': plate,
        'brand': brand,
        'model': model,
        'year': year,
        'vin': vin,
      },
    );
    return VehicleDto.fromJson(response as Map<String, dynamic>);
  }

  /// Fetches a vehicle by [vehicleId].
  Future<VehicleDto> getVehicleById(String vehicleId) async {
    final response = await _apiClient.get(ApiConstants.vehicleById(vehicleId));
    return VehicleDto.fromJson(response as Map<String, dynamic>);
  }

  /// Lists all vehicles in the active tenant.
  Future<List<VehicleDto>> getVehicles() async {
    final response = await _apiClient.get(ApiConstants.vehicles);
    final list = response as List<dynamic>;
    return list
        .map((item) => VehicleDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Lists vehicles owned by [customerId].
  Future<List<VehicleDto>> getVehiclesByCustomer(String customerId) async {
    final response = await _apiClient.get(
      ApiConstants.vehiclesByCustomer(customerId),
    );
    final list = response as List<dynamic>;
    return list
        .map((item) => VehicleDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Updates [vehicleId].
  Future<VehicleDto> updateVehicle({
    required String vehicleId,
    required String brand,
    required String model,
    required int year,
    required String vin,
  }) async {
    final response = await _apiClient.put(
      ApiConstants.vehicleById(vehicleId),
      body: {
        'brand': brand,
        'model': model,
        'year': year,
        'vin': vin,
      },
    );
    return VehicleDto.fromJson(response as Map<String, dynamic>);
  }

  /// Deletes [vehicleId].
  Future<void> deleteVehicle(String vehicleId) async {
    await _apiClient.delete(ApiConstants.vehicleById(vehicleId));
  }

  /// Triggers plate/VIN revalidation for [vehicleId].
  Future<void> validateVehicle(String vehicleId) async {
    await _apiClient.post(ApiConstants.vehicleValidate(vehicleId));
  }

  /// Uploads a photo at [filePath] for [vehicleId].
  Future<VehicleDto> uploadVehicleImage({
    required String vehicleId,
    required String filePath,
  }) async {
    final response = await _apiClient.multipartPost(
      ApiConstants.vehicleImage(vehicleId),
      filePath: filePath,
    );
    return VehicleDto.fromJson(response as Map<String, dynamic>);
  }
}
