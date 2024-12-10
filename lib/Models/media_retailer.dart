class MediaRetailer {
  // Data
  int mediaId;
  int retailerId;

  MediaRetailer({required this.mediaId, required this.retailerId});

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return mediaId == (other as MediaRetailer).mediaId &&
        retailerId == other.retailerId;
  }

  @override
  int get hashCode => Object.hash(mediaId, retailerId);

  Map<String, dynamic> toSupa() {
    return {
      "mediaid": mediaId,
      "retailerid": retailerId,
    };
  }

  factory MediaRetailer.from(Map<String, dynamic> json) {
    return MediaRetailer(
      mediaId: json["mediaid"],
      retailerId: json["retailerid"],
    );
  }
}