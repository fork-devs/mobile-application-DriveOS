import 'package:mobile_application_driveos/features/core/domain/core_domain.dart';

/// Use case that retrieves the authenticated user's unified profile context.
class GetMyProfileContext {
  final CoreRepository _repository;

  /// Creates a [GetMyProfileContext] use case.
  const GetMyProfileContext(this._repository);

  /// Returns the current [UserProfileContext].
  Future<UserProfileContext> call() => _repository.getMyProfileContext();
}

/// Use case that updates the authenticated user's profile image URL.
class UpdateMyProfileImage {
  final CoreRepository _repository;

  /// Creates an [UpdateMyProfileImage] use case.
  const UpdateMyProfileImage(this._repository);

  /// Sets [profileImageUrl] for the authenticated user.
  Future<UserProfileContext> call(String profileImageUrl) =>
      _repository.updateMyProfileImage(profileImageUrl.trim());
}

/// Use case that uploads a binary profile image for the authenticated user.
class UploadMyProfileImage {
  final CoreRepository _repository;

  /// Creates an [UploadMyProfileImage] use case.
  const UploadMyProfileImage(this._repository);

  /// Uploads the image at [filePath].
  Future<UserProfileContext> call(String filePath) =>
      _repository.uploadMyProfileImage(filePath);
}

/// Use case that looks up a unified profile by document number.
class LookupProfileByDocument {
  final CoreRepository _repository;

  /// Creates a [LookupProfileByDocument] use case.
  const LookupProfileByDocument(this._repository);

  /// Looks up a profile matching [documentNumber].
  Future<UnifiedProfileLookup> call(String documentNumber) =>
      _repository.lookupProfileByDocument(documentNumber.trim());
}

/// Use case that creates an owner profile.
class CreateOwnerProfile {
  final CoreRepository _repository;

  /// Creates a [CreateOwnerProfile] use case.
  const CreateOwnerProfile(this._repository);

  /// Creates an [OwnerProfile] for [userId].
  Future<OwnerProfile> call({
    required String userId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  }) {
    return _repository.createOwnerProfile(
      userId: userId,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      documentType: documentType.trim().toUpperCase(),
      documentNumber: documentNumber.trim(),
      phone: phone.trim(),
    );
  }
}

/// Use case that updates an owner profile.
class UpdateOwnerProfile {
  final CoreRepository _repository;

  /// Creates an [UpdateOwnerProfile] use case.
  const UpdateOwnerProfile(this._repository);

  /// Updates the owner profile identified by [ownerId].
  Future<OwnerProfile> call({
    required String ownerId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  }) {
    return _repository.updateOwnerProfile(
      ownerId: ownerId,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      documentType: documentType.trim().toUpperCase(),
      documentNumber: documentNumber.trim(),
      phone: phone.trim(),
    );
  }
}

/// Use case that creates an employee profile.
class CreateEmployeeProfile {
  final CoreRepository _repository;

  /// Creates a [CreateEmployeeProfile] use case.
  const CreateEmployeeProfile(this._repository);

  /// Creates an [EmployeeProfile] for [userId].
  Future<EmployeeProfile> call({
    required String userId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  }) {
    return _repository.createEmployeeProfile(
      userId: userId,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      documentType: documentType.trim().toUpperCase(),
      documentNumber: documentNumber.trim(),
      phone: phone.trim(),
    );
  }
}

/// Use case that updates an employee profile.
class UpdateEmployeeProfile {
  final CoreRepository _repository;

  /// Creates an [UpdateEmployeeProfile] use case.
  const UpdateEmployeeProfile(this._repository);

  /// Updates the employee profile identified by [employeeId].
  Future<EmployeeProfile> call({
    required String employeeId,
    required String firstName,
    required String lastName,
    required String documentType,
    required String documentNumber,
    required String phone,
  }) {
    return _repository.updateEmployeeProfile(
      employeeId: employeeId,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      documentType: documentType.trim().toUpperCase(),
      documentNumber: documentNumber.trim(),
      phone: phone.trim(),
    );
  }
}
