/// Represents the result of uploading a media file to Cloudflare R2.
class MediaUploadResult {
  /// The unique cloud media identifier.
  final String mediaId;

  /// The public CDN URL of the uploaded file.
  final String url;

  /// The storage object key inside the bucket.
  final String objectKey;

  /// Whether the uploaded object is immutable.
  final bool immutable;

  /// Creates a [MediaUploadResult].
  const MediaUploadResult({
    required this.mediaId,
    required this.url,
    required this.objectKey,
    this.immutable = true,
  });
}

/// Represents a service health check response.
class ServiceHealthStatus {
  /// Reported service status (e.g. `UP`).
  final String status;

  /// Optional application name.
  final String? app;

  /// Creates a [ServiceHealthStatus].
  const ServiceHealthStatus({
    required this.status,
    this.app,
  });
}
