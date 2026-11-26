import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event.dart';
import 'package:mobile_application_driveos/core/domain/event/domain_event_bus.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/network/api_constants.dart';
import 'package:mobile_application_driveos/core/network/app_exception.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';

/// Central HTTP client for DriveOS Mobile.
///
/// Injects the `Bearer` access token and `Accept-Language` header, coordinates
/// concurrent 401 token refreshes, and maps error responses to [AppException].
class ApiClient {
  /// The storage manager holding authentication tokens and tenant context.
  final SessionStorage sessionStorage;

  /// The optional domain event bus for broadcasting [SessionExpiredEvent].
  final DomainEventBus? eventBus;

  final http.Client _client;
  Future<bool>? _refreshFuture;

  /// Creates an [ApiClient] with the required [sessionStorage].
  ApiClient({
    required this.sessionStorage,
    this.eventBus,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<Map<String, String>> _buildHeaders([
    Map<String, String>? extraHeaders,
  ]) async {
    final token = await sessionStorage.getAccessToken();
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.acceptLanguageHeader: appLocaleNotifier.value.languageCode,
    };

    if (token != null && token.isNotEmpty) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    final baseUri = Uri.parse('${ApiConstants.baseUrl}$cleanPath');

    if (queryParameters == null || queryParameters.isEmpty) {
      return baseUri;
    }

    final queryMap = <String, String>{};
    queryParameters.forEach((key, value) {
      if (value != null) {
        queryMap[key] = value.toString();
      }
    });

    return baseUri.replace(queryParameters: queryMap);
  }

  bool _canRefreshForPath(String path) {
    return !path.startsWith(ApiConstants.authLogin) &&
        !path.startsWith(ApiConstants.authRefresh);
  }

  /// Coordinates concurrent 401 responses into a single refresh request.
  Future<bool> _refreshSessionTokens() {
    final inFlight = _refreshFuture;
    if (inFlight != null) return inFlight;

    final future = _performTokenRefresh().whenComplete(() {
      _refreshFuture = null;
    });
    _refreshFuture = future;
    return future;
  }

  Future<bool> _performTokenRefresh() async {
    try {
      final refreshToken = await sessionStorage.getRefreshToken();
      final tenantId = sessionStorage.tenantId;
      if (refreshToken == null ||
          refreshToken.trim().isEmpty ||
          tenantId == null ||
          tenantId.trim().isEmpty) {
        return false;
      }

      final uri = _buildUri(ApiConstants.authRefresh);
      final response = await _client
          .post(
            uri,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
            },
            body: jsonEncode({
              'refreshToken': refreshToken,
              'tenantId': tenantId,
            }),
          )
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return false;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return false;
      }

      final nextAccessToken = decoded['accessToken']?.toString();
      final nextRefreshToken = decoded['refreshToken']?.toString();
      if (nextAccessToken == null ||
          nextAccessToken.isEmpty ||
          nextRefreshToken == null ||
          nextRefreshToken.isEmpty) {
        return false;
      }

      await sessionStorage.updateTokens(
        accessToken: nextAccessToken,
        refreshToken: nextRefreshToken,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<dynamic> _executeWithRefresh(
    String path,
    Future<http.Response> Function() sendRequest,
  ) async {
    try {
      var response = await sendRequest().timeout(ApiConstants.requestTimeout);

      if (response.statusCode == 401 && _canRefreshForPath(path)) {
        final refreshed = await _refreshSessionTokens();
        if (refreshed) {
          response = await sendRequest().timeout(ApiConstants.requestTimeout);
        } else {
          await sessionStorage.clearSession();
          eventBus?.emit(
            SessionExpiredEvent(
              reason: 'Session token expired and refresh failed.',
            ),
          );
        }
      }

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw NetworkException(
        message: 'The server took too long to respond. Please try again.',
      );
    } on http.ClientException {
      throw NetworkException();
    }
  }

  /// Sends an HTTP GET request to [path].
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParameters);
    return _executeWithRefresh(path, () async {
      final requestHeaders = await _buildHeaders(headers);
      return _client.get(uri, headers: requestHeaders);
    });
  }

  /// Sends an HTTP POST request to [path] with an optional JSON [body].
  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParameters);
    return _executeWithRefresh(path, () async {
      final requestHeaders = await _buildHeaders(headers);
      return _client.post(
        uri,
        headers: requestHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
    });
  }

  /// Sends an HTTP PUT request to [path] with an optional JSON [body].
  Future<dynamic> put(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParameters);
    return _executeWithRefresh(path, () async {
      final requestHeaders = await _buildHeaders(headers);
      return _client.put(
        uri,
        headers: requestHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
    });
  }

  /// Sends an HTTP PATCH request to [path] with an optional JSON [body].
  Future<dynamic> patch(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParameters);
    return _executeWithRefresh(path, () async {
      final requestHeaders = await _buildHeaders(headers);
      return _client.patch(
        uri,
        headers: requestHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
    });
  }

  /// Sends an HTTP DELETE request to [path] with an optional JSON [body].
  Future<dynamic> delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParameters);
    return _executeWithRefresh(path, () async {
      final requestHeaders = await _buildHeaders(headers);
      return _client.delete(
        uri,
        headers: requestHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
    });
  }

  /// Uploads a file via `multipart/form-data` POST to [path].
  Future<dynamic> multipartPost(
    String path, {
    required String filePath,
    String fieldName = 'file',
    Map<String, String>? fields,
  }) async {
    final uri = _buildUri(path);
    return _executeWithRefresh(path, () async {
      final request = http.MultipartRequest('POST', uri);
      final token = await sessionStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
      }
      request.headers[HttpHeaders.acceptHeader] = 'application/json';

      if (fields != null) {
        request.fields.addAll(fields);
      }

      final file = File(filePath);
      final extension = filePath.split('.').last.toLowerCase();
      final subtype = switch (extension) {
        'png' => 'png',
        'webp' => 'webp',
        _ => 'jpeg',
      };

      request.files.add(
        await http.MultipartFile.fromPath(
          fieldName,
          file.path,
          contentType: MediaType('image', subtype),
        ),
      );

      final streamedResponse = await _client
          .send(request)
          .timeout(ApiConstants.requestTimeout);
      return http.Response.fromStream(streamedResponse);
    });
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final bodyText = response.body;

    dynamic decoded;
    if (bodyText.isNotEmpty) {
      try {
        decoded = jsonDecode(bodyText);
      } catch (_) {
        decoded = bodyText;
      }
    }

    if (statusCode >= 200 && statusCode < 300) {
      return decoded;
    }

    final serverMessage = _extractErrorMessage(decoded);

    switch (statusCode) {
      case 400:
      case 422:
        throw ValidationException(
          message: serverMessage ?? 'Invalid request parameters.',
          statusCode: statusCode,
          details: decoded,
        );
      case 401:
        throw AuthenticationException(
          message: serverMessage ??
              'Session expired or unauthorized. Please sign in again.',
          details: decoded,
        );
      case 403:
        throw AccessDeniedException(
          message: serverMessage ??
              'You do not have permission to perform this action.',
          details: decoded,
        );
      case 404:
        throw NotFoundException(
          message: serverMessage ?? 'The requested resource was not found.',
          details: decoded,
        );
      case 409:
        throw ConflictException(
          message: serverMessage ??
              'The operation conflicted with the current state.',
          details: decoded,
        );
      default:
        throw ServerException(
          message: serverMessage ?? 'Unexpected server error ($statusCode).',
          statusCode: statusCode,
          details: decoded,
        );
    }
  }

  String? _extractErrorMessage(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      return decoded['detail']?.toString() ??
          decoded['message']?.toString() ??
          decoded['error']?.toString() ??
          decoded['title']?.toString();
    }
    if (decoded is String && decoded.trim().isNotEmpty) {
      return decoded;
    }
    return null;
  }
}
