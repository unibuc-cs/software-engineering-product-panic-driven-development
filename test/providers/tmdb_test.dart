import 'package:test/test.dart';
import 'package:mediamaster/Services/provider_service.dart';

void main() {
  group('TMDB', () {
    group('movies', () {
      test('getOptions for several valid movies', () async {
        final movies = [
          'Harry Potter',
          'John Wick',
          'Lord of the rings',
          'Hard to kill'
        ];
        for (var movie in movies) {
          final options = await getOptionsMovie(movie);
          expect(options, isNotEmpty);
          for (var option in options) {
            expect(option['name'], isNotEmpty);
            expect(option['id'], isA<int>());
          }
        }
      });

      test('getOptions for invalid movie', () async {
        final options = await getOptionsMovie('asdasdasdasdasd');
        expect(options, isEmpty);
      });

      test('getInfo for a valid movie', () async {
        final movie_info = await getInfoMovie({
          'id': 671
        });
        expect(movie_info, isNotNull);
        expect(movie_info['originalname'], contains('Harry Potter and the Philosopher\'s Stone'));
        expect(movie_info['seriesname'], 'Harry Potter Collection');
        expect(movie_info['releasedate'], '2001-11-16');
        expect(movie_info['creators'][0], contains('Warner Bros'));
        expect(movie_info['duration'], 152);
      });
    });

    group('series', () {
      test('getOptions for several valid series', () async {
        final someSeries = [
          'Breaking Bad',
          'Family Feud',
          'Dark',
          'Prison Break',
          'Family Guy'
        ];
        for (var series in someSeries) {
          final options = await getOptionsSeries(series);
          expect(options, isNotEmpty);
          for (var option in options) {
            expect(option['name'], isNotEmpty);
            expect(option['id'], isA<int>());
          }
        }
      });

      test('getOptions for invalid series', () async {
        final options = await getOptionsSeries('asdasdasdasdasd');

        expect(options, isEmpty);
      });

      test('getInfo for a valid series', () async {
        final series_info = await getInfoSeries({
          'id': 2288
        });
        expect(series_info, isNotNull);
        expect(series_info['originalname'], contains('Prison Break'));
        expect(series_info['language'], 'en');
        expect(series_info['status'], 'Ended');
        expect(series_info['creators'][0], contains('Adelstein-Parouse'));
      });
    });
  });
}
