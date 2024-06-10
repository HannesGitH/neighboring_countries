import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:html/dom.dart' show Element;
import 'dart:io';

import '../country.dart';

class CountryCrawler {
  bool useOfflineHtml = false;

  static final url = Uri.parse(
      "https://en.m.wikipedia.org/wiki/List_of_countries_and_territories_by_land_and_maritime_borders");

  static final tableCSSSelector = ".wikitable > tbody";
  Future<Map<String, Country>> parseCountries() async {
    final document = parse(useOfflineHtml
        ? await File('lib/src/generate/sourceWiki.html').readAsString()
        : (await http.get(url)).body);
    final table = document.querySelector(tableCSSSelector);
    Map<String, Country> countries = {};
    for (final row in table!.children) {
      if (row.children.length < 4) continue;
      try {
        final countryName = row.children[0].text.trim();
        if (!_isNameLegit(countryName)) continue;
        Country country =
            countries.putIfAbsent(countryName, () => Country(countryName));
        final neighbors = _parseNeighborsNameAndBorder(row.children[4]);
        country.neighbors = neighbors
            .map(
                (e) => (countries.putIfAbsent(e.$1, () => Country(e.$1)), e.$2))
            .toSet();
        //pass by value?!?!
        // countries[countryName] = country;
      } catch (e) {}
    }
    return countries;
  }

  _isNameLegit(String name) => name.length > 2 && !name.startsWith('(');
  _makeNameLegit(String name) => name.replaceAll(RegExp(r'[^\w]+'), '');

  List<(String, BorderType)> _parseNeighborsNameAndBorder(Element column) {
    //unfortunately not every css selector (like :has()) is supported
    final countryRows =
        column.innerHtml.split('<br>').map((str) => parse('$str').body);
    return countryRows
        .map((e) {
          //leider gibt e.text Russia (M) zurück (statt nur '(M)')
          final borderType = BorderTypeStr.fromString(e!.text.split(' ').last);

          final name = e.children[1].text;
          if (!_isNameLegit(name)) return null;
          return (name, borderType);
        })
        .whereType<(String, BorderType)>()
        .toList();
  }
}

extension BorderTypeStr on BorderType {
  //factory extensions on enums are not supported either
  static BorderType fromString(String str) => str.contains('(M)')
      ? BorderType.onlySea
      : str.contains('(L)')
          ? BorderType.onlyLand
          : BorderType.both;
}
