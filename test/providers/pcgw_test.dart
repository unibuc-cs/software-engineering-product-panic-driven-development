import 'package:test/test.dart';
import 'package:mediamaster/Services/provider_service.dart';

void main() {
  group('PcGamingWiki', () {
    test('getOptions for several valid games', () async {
      final games = [
        'Hollow Knight',
        'God of War',
        'League of Legends',
        'Minecraft'
      ];
      for (var game in games) {
        final options = await getOptionsPCGW(game);
        expect(options, isNotEmpty);
        for (var option in options) {
          expect(option['name'], isNotNull);
        }
      }
    });

    test('getOptions for an invalid game', () async {
      final options = await getOptionsPCGW('reddit');
      expect(options, isEmpty);
    });

    test('getInfo for a valid game', () async {
      final game_info = await getInfoPCGW({
        'name': 'Hollow Knight'
      });
      expect(game_info, isNotNull);
      expect(game_info['windows'], isNotNull);
      expect(game_info['windows']['OS'], isNotNull);
      expect(game_info['windows']['CPU'], isNotNull);
      expect(game_info['windows']['HDD'], isNotNull);
      expect(game_info['windows']['GPU'], isNotNull);
      expect(game_info['os_x'], isNotNull);
      expect(game_info['linux'], isNotNull);
      expect(game_info['windows']['OS']['minimum'], contains('7'));
      expect(game_info['windows']['OS']['recommended'], contains('10'));
    });
  });
}
