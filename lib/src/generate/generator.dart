import 'package:neighboring_countries/src/generate/crawler.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';

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
    final outputEnd = <String>[];

    final crawler = CountryCrawler()..useOfflineHtml = true;

    output.addAll(outputStart);
    output.addAll(outputEnd);
    return output.join('\n');
  }
}

class GenerateCountryGraph {
  const GenerateCountryGraph();
}

final countryGraphBuilder =
    SharedPartBuilder([CommentGenerator()], "mk_country_graph");

Builder countryGraphFactory(BuilderOptions opts) => countryGraphBuilder;
