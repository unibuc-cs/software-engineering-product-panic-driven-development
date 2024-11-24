import 'package:test/test.dart';
import '../../../lib/Services/ApiService.dart';

void main() {
  group('Anilist', () {
    group('anime', () {
      test('getOptions for several valid anime', () async {
        final animeList = [
          'Attack on Titan',
          'Frieren',
          'Blue Lock',
          'My Hero Academia'
        ];
        for (var anime in animeList) {
          final options = await getOptionsAnime(anime);
          expect(options, isNotEmpty);
          for (var option in options) {
            expect(option['name'], isNotEmpty);
            expect(option['id'], isA<int>());
          }
        }
      });

      test('getOptions for invalid anime', () async {
        // asdasdasdasdasd finds results
        final options = await getOptionsAnime('');
        expect(options, isEmpty);
      });

      test('getInfo for a valid anime', () async {
        final anime_info = await getInfoAnime({
          'id': 16498
        });
        expect(anime_info, isNotNull);
        expect(anime_info['title']['english'], contains('Attack on Titan'));
        expect(anime_info['episodes'], 25);
        expect(anime_info['release_date'], contains('2013-04-07'));
        expect(anime_info['genres'][0], contains('Action'));
      });
    });

    group('manga', () {
      test('getOptions for several valid manga', () async {
        final mangaList = [
          'Blue Box',
          'Kanojo no Okarishimasu',
          'Record of ragnarok',
          'Kaiju no 8'
        ];
        for (var manga in mangaList) {
          final options = await getOptionsManga(manga);
          expect(options, isNotEmpty);
          for (var option in options) {
            expect(option['name'], isNotEmpty);
            expect(option['id'], isA<int>());
          }
        }
      });

      test('getOptions for invalid manga', () async {
        // asdasdasdasdasd finds results
        final options = await getOptionsManga('');
        expect(options, isEmpty);
      });

      test('getInfo for a valid manga', () async {
        final manga_info = await getInfoManga({
          'id': 132182
        });
        expect(manga_info, isNotNull);
        expect(manga_info['title']['english'], contains('Blue Box'));
        expect(manga_info['release_date'], contains('2021-04-12'));
        expect(manga_info['genres'][0], contains('Romance'));
      });
    });
  });
}
