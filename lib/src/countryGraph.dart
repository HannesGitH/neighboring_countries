import 'package:neighboring_countries/src/selectableGraph.dart';

import 'country.dart';
import 'generate/annotation.dart';

part 'countryGraph.g.dart';

class CountryGraph extends SelectableGraph<Country> {
  CountryGraph(super.nodes);
}

@GenerateCountryGraph()
final CountryGraph countryGraph = _$countryGraph();
