import 'dart:async';

import 'package:neighboring_countries/src/graph.dart';

class SelectableGraph<T extends GraphNode> extends ImmutableGraph<T> {
  final Set<T> selectedNodes;

  final Map<T, (T, int)> _refCountedCurrentNeighbors = {};

  final _neighborController = StreamController<Set<T>>.broadcast();

  Set<T> get currentNeighbors => _neighBorsOfCurrentSelection;

  SelectableGraph(Set<T> nodes, [this.selectedNodes = const {}]) : super(nodes);

  Stream<Set<T>> get neighbors => _neighborController.stream;

  void selectNode(T node) {
    if (selectedNodes.add(node)) {
      var potentiallyNewNeighbors = node.goesTo as Set<T>;
      for (T neighbor in potentiallyNewNeighbors) {
        var rcT = _refCountedCurrentNeighbors[neighbor] ?? (neighbor, 0);
        _refCountedCurrentNeighbors[neighbor] = (rcT.$1, rcT.$2 + 1);
      }
      _pushNeighbors();
    }
  }

  void unselectNode(T node) {
    if (selectedNodes.remove(node)) {
      var potentiallyOldNeighbors = node.goesTo as Set<T>;
      for (T neighbor in potentiallyOldNeighbors) {
        var rcT = _refCountedCurrentNeighbors[neighbor]!;
        if (rcT.$2 == 1) {
          _refCountedCurrentNeighbors.remove(neighbor);
        } else {
          _refCountedCurrentNeighbors[neighbor] = (rcT.$1, rcT.$2 - 1);
        }
      }
      _pushNeighbors();
    }
  }

  /// selected nodes are not neighbors of the group
  Set<T> get _neighBorsOfCurrentSelection =>
      _refCountedCurrentNeighbors.keys.toSet().difference(selectedNodes);

  void _pushNeighbors() {
    _neighborController.add(_neighBorsOfCurrentSelection);
  }

  void toggleNode(T node) {
    if (selectedNodes.contains(node)) {
      unselectNode(node);
    } else {
      selectNode(node);
    }
  }

  void dispose() {
    _neighborController.close();
  }
}
