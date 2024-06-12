import 'package:neighboring_countries/src/generate/crawler.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';

import '../country.dart';
import 'annotation.dart';

/// Generates a single-line comment for each class
class CommentGenerator extends GeneratorForAnnotation<GenerateCountryGraph> {
  const CommentGenerator();

  @override
  Future<String> generateForAnnotatedElement(element, reader, step) async {
    final output = <String>[];
    output.add('/// Library: ${element.library}');
    output.add('///');
    output.add('/// ${element.name}');
    // make first letter uppercase
    final name = "_\$${element.name!}";

    final outputStart = <String>[];
    final outputEnd = <String>['_addNeighbors(){'];

    final crawler = CountryCrawler()..useOfflineHtml = true;

    final countryVars = <String>[];

    for (final country in (await crawler.parseCountries()).values) {
      final countryVar = countryToVar(country);
      countryVars.add(countryVar);
      outputStart.add('Country $countryVar = Country("${country.name}");');
      final neighborsListStr = country.neighbors
          .map((n) => '(${countryToVar(n.$1)}, ${n.$2})')
          .join(', ');
      outputEnd.add("${countryToVar(country)}.neighbors={$neighborsListStr};");
    }

    output.addAll(outputStart);
    output.addAll(outputEnd);
    output.add('}');
    output.add(
        '$name(){_addNeighbors();return CountryGraph({${countryVars.join(', ')}});}');
    return output.join('\n');
  }

  String countryToVar(Country country) =>
      '_c_${country.name.replaceAll(RegExp(r'[^\w]+'), '')}';
}

final countryGraphBuilder =
    SharedPartBuilder([CommentGenerator()], "mk_country_graph");

Builder countryGraphFactory(BuilderOptions opts) => countryGraphBuilder;
