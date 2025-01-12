import 'media.dart';
import 'general/model.dart';
import 'general/media_type.dart';
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
    this.parentGameId = 1,
    this.IGDBId = -1,
    this.OSMinimum = '',
    this.OSRecommended = '',
    this.CPUMinimum = '',
    this.CPURecommended = '',
    this.RAMMinimum = '',
    this.RAMRecommended = '',
    this.HDDMinimum = '',
    this.HDDRecommended = '',
    this.GPUMinimum = '',
    this.GPURecommended = '',
    this.HLTBMainInSeconds = 0,
    this.HLTBMainSideInSeconds = 0,
    this.HLTBCompletionistInSeconds = 0,
    this.HLTBAllStylesInSeconds = 0,
    this.HLTBCoopInSeconds = 0,
    this.HLTBVersusInSeconds = 0,
  });

  static String get endpoint => 'games';

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
      parentGameId: json['parentgameid'] ?? 1,
      IGDBId: json['igdbid'] ?? 0,
      OSMinimum: json['osminimum'] ?? '',
      OSRecommended: json['osrecommended'] ?? '',
      CPUMinimum: json['cpuminimum'] ?? '',
      CPURecommended: json['cpurecommended'] ?? '',
      RAMMinimum: json['ramminimum'] ?? '',
      RAMRecommended: json['ramrecommended'] ?? '',
      HDDMinimum: json['hddminimum'] ?? '',
      HDDRecommended: json['hddrecommended'] ?? '',
      GPUMinimum: json['gpuminimum'] ?? '',
      GPURecommended: json['gpurecommended'] ?? '',
      HLTBMainInSeconds: json['hltbmaininseconds'] ?? 0,
      HLTBMainSideInSeconds: json['hltbmainsideinseconds'] ?? 0,
      HLTBCompletionistInSeconds: json['hltbcompletionistinseconds'] ?? 0,
      HLTBAllStylesInSeconds: json['hltballstylesinseconds'] ?? 0,
      HLTBCoopInSeconds: json['hltbcoopinseconds'] ?? 0,
      HLTBVersusInSeconds: json['hltbversusinseconds'] ?? 0,
    );
  }

  // Less endpoint calls
  Media? _media;

  @override
  Future<Media> get media async {
    _media ??= await MediaService.instance.readById([mediaId]);
    return _media!;
  }

  Game? _parentGame;

  Future<Game?> get parentGame async {
    _parentGame ??= await GameService.instance.readById([parentGameId]);
    return _parentGame;
  }
}