import 'package:mobile_application_driveos/features/fleet/domain/fleet_domain.dart';

/// Use case that registers a new customer.
class CreateCustomer {
  final FleetRepository _repository;

  /// Creates a [CreateCustomer] use case.
  const CreateCustomer(this._repository);

  /// Registers a customer with their identity document details.
  Future<Customer> call({
    required String fullName,
    required String email,
    required String phone,
    required String docType,
    required String docNumber,
  }) {
    return _repository.createCustomer(
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
      docType: docType.trim().toUpperCase(),
      docNumber: docNumber.trim(),
    );
  }
}

/// Use case that retrieves customers or a single customer by identifier.
class GetCustomers {
  final FleetRepository _repository;

  /// Creates a [GetCustomers] use case.
  const GetCustomers(this._repository);

  /// Lists all customers in the active tenant.
  Future<List<Customer>> call() => _repository.getCustomers();

  /// Fetches a customer by [customerId].
  Future<Customer> byId(String customerId) =>
      _repository.getCustomerById(customerId);
}

/// Use case that updates, deletes, or revalidates a customer.
class ManageCustomer {
  final FleetRepository _repository;

  /// Creates a [ManageCustomer] use case.
  const ManageCustomer(this._repository);

  /// Updates contact details for [customerId].
  Future<Customer> update({
    required String customerId,
    required String fullName,
    required String email,
    required String phone,
  }) {
    return _repository.updateCustomer(
      customerId: customerId,
      fullName: fullName.trim(),
      email: email.trim(),
      phone: phone.trim(),
    );
  }

  /// Deletes [customerId].
  Future<void> delete(String customerId) =>
      _repository.deleteCustomer(customerId);

  /// Triggers identity revalidation for [customerId].
  Future<void> validate(String customerId) =>
      _repository.validateCustomer(customerId);
}
