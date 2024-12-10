class MediaPlatform {
  // Data
  int mediaId;
  int platformId;

  MediaPlatform({required this.mediaId, required this.platformId});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaPlatform).mediaId &&
        platformId == other.platformId;
  }

  @override
  int get hashCode => Object.hash(mediaId, platformId);

  Map<String, dynamic> toSupa() {
    return {
      "mediaid": mediaId,
      "platformid": platformId,
    };
  }

  factory MediaPlatform.from(Map<String, dynamic> json) {
    return MediaPlatform(
      mediaId: json["mediaid"],
      platformId: json["platformid"],
    );
  }
}