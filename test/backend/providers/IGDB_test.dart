import 'package:test/test.dart';
import '../../../lib/Services/ApiService.dart';

void main() {
  group('IGDB', () {
    test('getOptions for several valid games', () async {
      final games = [
        'Hollow Knight',
        'God of War',
        'League of Legends',
        'Minecraft'
      ];
      for (var game in games) {
        final options = await getOptionsIGDB(game);
        expect(options, isNotEmpty);
        for (var option in options) {
          expect(option['name'], isNotEmpty);
          expect(option['id'], isA<int>());
        }
      }
    });

    test('getOptions for an invalid game', () async {
      final options = await getOptionsIGDB('reddit');
      expect(options, isEmpty);
    });

    test('getInfo for a valid game', () async {
      final game_info = await getInfoIGDB({
        'id': 14593
      });
      expect(game_info, isNotNull);
      expect(game_info['name'], contains('Hollow Knight'));
      expect(game_info['url'], 'https://www.igdb.com/games/hollow-knight');
      expect(game_info['developers'], contains('Team Cherry'));
      expect(game_info['publishers'], contains('Team Cherry'));
    });
  });
}
