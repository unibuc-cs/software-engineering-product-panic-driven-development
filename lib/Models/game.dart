import 'model.dart';
import 'media.dart';
import 'media_type.dart';
import 'package:mediamaster/Services/media_service.dart';
import 'package:mediamaster/Services/game_service.dart';

class Game extends MediaType implements Model {
  // Data
  int mediaId;
  int id;
  int parentGameId;
  int IGDBId;
  String OSMinimum;
  String OSRecommended;
  String CPUMinimum;
  String CPURecommended;
  String RAMMinimum;
  String RAMRecommended;
  String HDDMinimum;
  String HDDRecommended;
  String GPUMinimum;
  String GPURecommended;
  int HLTBMainInSeconds;
  int HLTBMainSideInSeconds;
  int HLTBCompletionistInSeconds;
  int HLTBAllStylesInSeconds;
  int HLTBCoopInSeconds;
  int HLTBVersusInSeconds;

  Game({
    this.id = -1,
    required this.mediaId,
    this.parentGameId = -1,
    required this.IGDBId,
    required this.OSMinimum,
    required this.OSRecommended,
    required this.CPUMinimum,
    required this.CPURecommended,
    required this.RAMMinimum,
    required this.RAMRecommended,
    required this.HDDMinimum,
    required this.HDDRecommended,
    required this.GPUMinimum,
    required this.GPURecommended,
    this.HLTBMainInSeconds = -1,
    this.HLTBMainSideInSeconds = -1,
    this.HLTBCompletionistInSeconds = -1,
    this.HLTBAllStylesInSeconds = -1,
    this.HLTBCoopInSeconds = -1,
    this.HLTBVersusInSeconds = -1,
  });

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return id == (other as Game).id;
  }

  @override
  int getMediaId() {
    return mediaId;
  }

  @override
  int get hashCode => id;

  @override
  Map<String, dynamic> toJson() {
    return {
      'mediaid': mediaId,
      'parentgameid': parentGameId,
      'igdbid': IGDBId,
      'osminimum': OSMinimum,
      'osrecommended': OSRecommended,
      'cpuminimum': CPUMinimum,
      'cpurecommended': CPURecommended,
      'ramminimum': RAMMinimum,
      'ramrecommended': RAMRecommended,
      'hddminimum': HDDMinimum,
      'hddrecommended': HDDRecommended,
      'gpuminimum': GPUMinimum,
      'gpurecommended': GPURecommended,
      'hltbmaininseconds': HLTBMainInSeconds,
      'hltbmainsideinseconds': HLTBMainSideInSeconds,
      'hltbcompletionistinseconds': HLTBCompletionistInSeconds,
      'hltballstylesinseconds': HLTBAllStylesInSeconds,
      'hltbcoopinseconds': HLTBCoopInSeconds,
      'hltbversusinseconds': HLTBVersusInSeconds,
    };
  }

  @override
  factory Game.from(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      mediaId: json['mediaid'],
      parentGameId: json['parentgameid'],
      IGDBId: json['igdbid'],
      OSMinimum: json['osminimum'],
      OSRecommended: json['osrecommended'],
      CPUMinimum: json['cpuminimum'],
      CPURecommended: json['cpurecommended'],
      RAMMinimum: json['ramminimum'],
      RAMRecommended: json['ramrecommended'],
      HDDMinimum: json['hddminimum'],
      HDDRecommended: json['hddrecommended'],
      GPUMinimum: json['gpuminimum'],
      GPURecommended: json['gpurecommended'],
      HLTBMainInSeconds: json['hltbmaininseconds'],
      HLTBMainSideInSeconds: json['hltbmainsideinseconds'],
      HLTBCompletionistInSeconds: json['hltbcompletionistinseconds'],
      HLTBAllStylesInSeconds: json['hltballstylesinseconds'],
      HLTBCoopInSeconds: json['hltbcoopinseconds'],
      HLTBVersusInSeconds: json['hltbversusinseconds'],
    );
  }

  // Less endpoint calls
  Media? _media;

  @override
  Future<Media> get media async {
    _media ??= await MediaService().readById(mediaId);
    return _media!;
  }

  Game? _parentGame;

  Future<Game?> get parentGame async {
    _parentGame ??= await GameService().readById(parentGameId);
    return _parentGame;
  }
}