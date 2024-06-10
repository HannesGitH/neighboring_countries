import 'package:neighboring_countries/src/graph.dart';

class Country implements GraphNode {
  static HasBorderType countsAsNeighborIfBorder = HasBorderType.either;

  final String name;
  Set<(Country, BorderType)> neighbors = {};

  Country(this.name);

  @override
  String get id => name;

  @override
  Set<Country> get goesTo => neighbors
      //unfortunately https://github.com/dart-lang/language/issues/3001
      .where((x) => countsAsNeighborIfBorder.includes(x.$2))
      .map<Country>((x) => x.$1)
      .toSet();
}

enum BorderType {
  onlyLand,
  onlySea,
  both,
}

enum HasBorderType {
  land,
  sea,
  both,
  either,
}

extension IncludesBorderType on HasBorderType {
  bool includes(BorderType type) => switch ((this, type)) {
        (HasBorderType.either, _) || (_, BorderType.both) => true,
        (HasBorderType.land, BorderType.onlyLand) => true,
        (HasBorderType.sea, BorderType.onlySea) => true,
        _ => false,
      };
}
