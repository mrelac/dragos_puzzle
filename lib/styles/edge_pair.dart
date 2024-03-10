// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dragos_puzzle/styles/path_builder.dart';
import 'package:flutter/material.dart';

/// Describes the path direction in directional terms.
enum Dir {
  e, // east
  s, // south
  w, // west
  n // north
}

enum PieceStyle { bump, cut, line }

// TODO - rename file to edge_path.dart.
class EdgePath {
  final int? key;
  final String path;
  final Dir dir;
  final PieceStyle style;
  final Size size;
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;
  EdgePath({
    this.key,
    required this.path,
    required this.dir,
    required this.style,
    required this.size,
    required this.row,
    required this.col,
    required this.maxRow,
    required this.maxCol,
  });

  EdgePath copyWith({
    int? key,
    String? path,
    Dir? dir,
    PieceStyle? style,
    Size? size,
    int? row,
    int? col,
    int? maxRow,
    int? maxCol,
  }) {
    return EdgePath(
      key: key ?? this.key,
      path: path ?? this.path,
      dir: dir ?? this.dir,
      style: style ?? this.style,
      size: size ?? this.size,
      row: row ?? this.row,
      col: col ?? this.col,
      maxRow: maxRow ?? this.maxRow,
      maxCol: maxCol ?? this.maxCol,
    );
  }

  @override
  String toString() {
    return 'EdgePath(key: $key, path: $path, dir: $dir, style: $style, size: $size, row: $row, col: $col, maxRow: $maxRow, maxCol: $maxCol)';
  }
}

/// Defines a vertical or horizontal puzzle edge path and its [mate] (compliment).
///
/// [key] is a nullable unique edge identifier. Border piece keys are null. All
/// other pieces must have a unique key that identifies this edge. Non-border
/// [path] and [mate] share the same key.
/// [path] is the piece's path, comprised of 3 parts:
/// - a vertical or horizontal line to the start of the bezier curve
/// - the bezier curve (typically a bump or cut)
/// - another vertical or horizontal line to the edge.
/// [mate] is a path that describes [path] as drawn from the opposite direction
/// and with a complimentary shape (e.g. if [path] is an east _cut_, drawn from
/// left to right, [mate] is a west _bump_, drawn from right to left, that,
/// when placed next to [path], should fit perfectly.)
///
/// [dir] is the primary [Path] direction (east, south, west, north).
/// [size] is the image size as fit to the device.
///
@Deprecated('Use EdgePath instead. Mate can be generated on the fly.')
class EdgePair {
  final int? key;
  final String path;
  final String mate;
  final Dir dir;
  // final PieceStyle style;
  final Size size;
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;
  EdgePair({
    this.key,
    this.path = '',
    this.mate = '',
    required this.dir,
    // required this.style,
    this.size = Size.zero,
    required this.row,
    required this.col,
    required this.maxRow,
    required this.maxCol,
  });

  EdgePair copyWith({
    int? key,
    String? path,
    String? mate,
    Dir? dir,
    // PieceStyle? style,
    Size? size,
    int? row,
    int? col,
    int? maxRow,
    int? maxCol,
  }) {
    return EdgePair(
      key: key ?? this.key,
      path: path ?? this.path,
      mate: mate ?? this.mate,
      dir: dir ?? this.dir,
      // style: style ?? this.style,
      size: size ?? this.size,
      row: row ?? this.row,
      col: col ?? this.col,
      maxRow: maxRow ?? this.maxRow,
      maxCol: maxCol ?? this.maxCol,
    );
  }

  @override
  String toString() {
    return 'EdgePair(key: $key, path: $path, mate: $mate, dir: $dir, size: $size, row: $row, col: $col, maxRow: $maxRow, maxCol: $maxCol)';
  }
}
