// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

/// Describes the path direction in directional terms.
enum Dir {
  e, // east
  s, // south
  w, // west
  n // north
}

enum EdgeStyle { bump, cut, line }

class EdgePath {
  final int? key;
  final String path;
  final Dir dir;
  final EdgeStyle style;
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
    EdgeStyle? style,
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
