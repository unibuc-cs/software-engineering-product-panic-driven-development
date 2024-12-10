class MediaCreator {
  // Data
  int mediaId;
  int creatorId;

  MediaCreator({required this.mediaId, required this.creatorId});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaCreator).mediaId &&
        creatorId == other.creatorId;
  }

  @override
  int get hashCode => Object.hash(mediaId, creatorId);

  Map<String, dynamic> toSupa() {
    return {
      "mediaid": mediaId,
      "creatorid": creatorId,
    };
  }

  factory MediaCreator.from(Map<String, dynamic> json) {
    return MediaCreator(
      mediaId: json["mediaid"],
      creatorId: json["creatorid"],
    );
  }
}