abstract class GraphNode {
  String get id;
  Set<GraphNode> get goesTo;
}

class Graph<T extends GraphNode> {
  final Map<String, T> _nodes = {};

  void addNode(T node) {
    _nodes[node.id] = node;
  }

  T? getNode(String id) {
    return _nodes[id];
  }

  void addEdge(String from, String to) {
    final fromNode = getNode(from);
    final toNode = getNode(to);

    if (fromNode == null || toNode == null) {
      throw ArgumentError('Node not found');
    }

    fromNode.goesTo.add(toNode);
  }
}

class ImmutableGraph<T extends GraphNode> {
  final Set<T> nodes;

  ImmutableGraph(this.nodes);
}
