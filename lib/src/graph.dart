abstract class GraphNode {
  String get id;
  Set<GraphNode> get goesTo;
}

class Graph {
  final Map<String, GraphNode> _nodes = {};

  void addNode(GraphNode node) {
    _nodes[node.id] = node;
  }

  GraphNode? getNode(String id) {
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
