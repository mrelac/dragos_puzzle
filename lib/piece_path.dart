// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dragos_puzzle/styles/edge.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class PiecePath {
  final double offsetX;
  final double offsetY;
  final Edge e;
  final Edge s;
  final Edge w;
  final Edge n;
  PiecePath({
    required this.offsetX,
    required this.offsetY,
    required this.e,
    required this.s,
    required this.w,
    required this.n,
  });

  Path get path => parseSvgPathData(toString());

  /// Prints as path string.
  @override
  String toString() =>
      'm $offsetX $offsetY ${e.path} ${s.path} ${w.path} ${n.path}';

  String get edges => 'e: $e. s: $s. w: $w. n: $n';

  PiecePath copyWith({
    double? offsetX,
    double? offsetY,
    Edge? e,
    Edge? s,
    Edge? w,
    Edge? n,
  }) {
    return PiecePath(
      offsetX: offsetX ?? this.offsetX,
      offsetY: offsetY ?? this.offsetY,
      e: e ?? this.e,
      s: s ?? this.s,
      w: w ?? this.w,
      n: n ?? this.n,
    );
  }
}
