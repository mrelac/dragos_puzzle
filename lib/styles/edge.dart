// ignore_for_file: public_member_api_docs, sort_constructors_first

/// Encapsulates a path edge and mate with optional key.
/// [edge] is the svg path string. [mate] is the edge's compliment
/// that should produce a path that fits [edge]. [mate] should be [path]
/// drawn in the opposite direction and with a flipped style. [key] binds the
/// path and mate.
/// In the case of borders, neither [mate] nor [key] is needed, as borders
/// do not have mates.
class Edge {
  final int? key;
  final String edge;
  final String mate;

  Edge({
    this.key,
    required this.edge,
    this.mate = '',
  });

  Edge copyWith({
    int? key,
    String? edge,
    String? mate,
  }) {
    return Edge(
        key: key ?? this.key, edge: edge ?? this.edge, mate: mate ?? this.mate);
  }

  @override
  String toString() => 'Edge(key: $key, edge: $edge, mate: $mate)';
}
