import 'package:test/test.dart';
import 'package:mediamaster/Services/provider_service.dart';

double getHours(String time) {
  final hours = time.split(' ')[0];
  return double.parse(hours);
}

void main() {
  group('HowLongToBeat', () {

    test('getOptions for several valid games', () async {
      final games = [
        'Hollow Knight',
        'God of War',
        'League of Legends',
        'Minecraft'
      ];
      for (var game in games) {
        final options = await getOptionsHLTB(game);
        expect(options, isNotEmpty);
        for (var option in options) {
          expect(option['name'], isNotEmpty);
          expect(option['id'], isA<int>());
        }
      }
    });

    test('getOptions for invalid game', () async {
      final options = await getOptionsHLTB('reddit');
      expect(options, isEmpty);
    });

    test('getInfo for a singleplayer game', () async {
      // game: Hollow Knight
      final game_info = await getInfoHLTB({
        'id': '26286'
      });
      expect(game_info, isNotNull);
      expect(game_info['Main Story'], isNotNull);
      expect(game_info['Main + Sides'], isNotNull);
      expect(game_info['Completionist'], isNotNull);
      expect(game_info['All Styles'], isNotNull);
      expect(getHours(game_info['Main Story']), greaterThan(20));
      expect(getHours(game_info['Main + Sides']), greaterThan(40));
      expect(getHours(game_info['Completionist']), greaterThan(60));
    });

    test('getInfo for a multiplayer game', () async {
      // game: League of Legends
      final game_info = await getInfoHLTB({
        'id': '5203'
      });
      expect(game_info, isNotNull);
      expect(game_info['Main Story'], isNull);
      expect(game_info['Main + Sides'], isNull);
      expect(game_info['Completionist'], isNull);
      expect(game_info['Co-Op'], isNotNull);
      expect(game_info['Vs.'], isNotNull);
      expect(getHours(game_info['Co-Op']), greaterThan(1000));
      expect(getHours(game_info['Vs.']), greaterThan(1000));
    });

    test('getInfo for a game with no data', () async {
      // game: Khamrai
      final game_info = await getInfoHLTB({
        'id': '19200'
      });
      expect(game_info, isNotNull);
      expect(game_info, isEmpty);
    });
  });
}
