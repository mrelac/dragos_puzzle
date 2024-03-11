// ignore_for_file: public_member_api_docs, sort_constructors_first

/// Describes the path direction in directional terms.
enum Dir {
  e, // east
  s, // south
  w, // west
  n // north
}

enum EdgeStyle { bump, cut, line }

/// This class describes a single edge's unique [key], [path], [dir] and [style].
/// [key] uniquely identifies the edge, unless the edge style is [EdgeStyle.line],
/// in which case [key] is not used.
// TODO - Rename file to edge.dart
class Edge {
  final int? key;
  final String path;
  final Dir dir;
  final EdgeStyle style;
  Edge({
    this.key,
    required this.path,
    required this.dir,
    required this.style,
  });

  Edge copyWith({
    int? key,
    String? path,
    Dir? dir,
    EdgeStyle? style,
  }) {
    return Edge(
      key: key ?? this.key,
      path: path ?? this.path,
      dir: dir ?? this.dir,
      style: style ?? this.style,
    );
  }

  @override
  String toString() => 'Edge(key: $key, path: $path, dir: $dir, style: $style)';
}
