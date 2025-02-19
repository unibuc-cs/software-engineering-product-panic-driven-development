import 'package:mediamaster/Models/creator.dart';
import 'package:mediamaster/Models/genre.dart';
import 'package:mediamaster/Models/platform.dart';
import 'package:mediamaster/Models/publisher.dart';
import 'package:mediamaster/Services/creator_service.dart';
import 'package:mediamaster/Services/genre_service.dart';
import 'package:mediamaster/Services/media_creator_service.dart';
import 'package:mediamaster/Services/media_genre_service.dart';
import 'package:mediamaster/Services/media_platform_service.dart';
import 'package:mediamaster/Services/media_publisher_service.dart';
import 'package:mediamaster/Services/platform_service.dart';

import 'general/model.dart';
import '../Services/publisher_service.dart';

class Media implements Model {
  // Data
  int id;
  String originalName;
  String description;
  DateTime? releaseDate;
  int criticScore;
  int communityScore;
  String mediaType;

  Media({
    required this.originalName,
    required this.mediaType,
    this.releaseDate,
    this.id             = -1,
    this.description    = '',
    this.criticScore    = 0,
    this.communityScore = 0,
  });

  static String get endpoint => 'medias';

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Media).id;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() => {
    'originalname'  : originalName,
    'description'   : description,
    'releasedate'   : releaseDate?.toIso8601String(),
    'criticscore'   : criticScore,
    'communityscore': communityScore,
    'mediatype'     : mediaType,
  };

  @override
  factory Media.from(Map<String, dynamic> json) => Media(
    id            : json['id'],
    originalName  : json['originalname'],
    description   : json['description'] ?? '',
    releaseDate   : json['releasedate'] == null ? null : DateTime.parse(json['releasedate']),
    criticScore   : json['criticscore'] ?? 0,
    communityScore: json['communityscore'] ?? 0,
    mediaType     : json['mediatype'],
  );

  List<Publisher> get publishers {
    Set<int> ids = MediaPublisherService
      .instance
      .items
      .where((mp) => mp.mediaId == id)
      .map((mp) => mp.publisherId)
      .toSet();
    return PublisherService
      .instance
      .items
      .where((pub) => ids.contains(pub.id))
      .toList();
  }

  List<Creator> get creators {
    Set<int> ids = MediaCreatorService
      .instance
      .items
      .where((mc) => mc.mediaId == id)
      .map((mc) => mc.creatorId)
      .toSet();
    return CreatorService
      .instance
      .items
      .where((cre) => ids.contains(cre.id))
      .toList();
  }

  List<Platform> get platforms {
    Set<int> ids = MediaPlatformService
      .instance
      .items
      .where((mp) => mp.mediaId == id)
      .map((mp) => mp.platformId)
      .toSet();
    return PlatformService
      .instance
      .items
      .where((pla) => ids.contains(pla.id))
      .toList();
  }

  List<Genre> get genres {
    Set<int> ids = MediaGenreService
      .instance
      .items
      .where((mg) => mg.mediaId == id)
      .map((mg) => mg.genreId)
      .toSet();
    return GenreService
      .instance
      .items
      .where((gen) => ids.contains(gen.id))
      .toList();
  }
}
