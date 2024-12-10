class MediaPublisher {
  // Data
  int mediaId;
  int publisherId;

  MediaPublisher({required this.mediaId, required this.publisherId});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaPublisher).mediaId &&
        publisherId == other.publisherId;
  }

  @override
  int get hashCode => Object.hash(mediaId, publisherId);

  Map<String, dynamic> toSupa() {
    return {
      "mediaid": mediaId,
      "publisherid": publisherId,
    };
  }

  factory MediaPublisher.from(Map<String, dynamic> json) {
    return MediaPublisher(
      mediaId: json["mediaid"],
      publisherId: json["publisherid"],
    );
  }
}