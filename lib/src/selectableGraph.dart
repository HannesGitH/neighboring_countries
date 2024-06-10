import 'dart:async';

import 'package:neighboring_countries/src/graph.dart';

class SelectableGraph<T extends GraphNode> extends ImmutableGraph<T> {
  final Set<T> selectedNodes;

  final _neighborController = StreamController<T>.broadcast();

  SelectableGraph(Set<T> nodes, [this.selectedNodes = const {}]) : super(nodes);

  Stream<T> get neighbors => _neighborController.stream;

  void selectNode(T node) {
    if (selectedNodes.add(node)) {
      _neighborController.add(node);
    }
  }

  void unselectNode(T node) {
    if (selectedNodes.remove(node)) {
      _neighborController.add(node);
    }
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
