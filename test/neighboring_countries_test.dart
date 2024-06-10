import 'package:neighboring_countries/src/generate/crawler.dart';
import 'package:test/test.dart';

void main() {
  group('test crawler', () {
    final crawler = CountryCrawler()..useOfflineHtml = true;

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () async {
      // expect(awesome.isAwesome, isTrue);
      final countries = await crawler.parseCountries();
      expect(countries["Andorra"]!.goesTo.length, 2);
      expect(countries["Finland"]!.goesTo.length, 4);
      expect(countries["Yemen"]!.goesTo.length, 5);
    });
  });
}
