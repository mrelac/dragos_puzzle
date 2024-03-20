// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dragos_puzzle/styles/edge.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class PiecePath {
  final double homeX;
  final double homeY;
  final Edge e;
  final Edge s;
  final Edge w;
  final Edge n;
  PiecePath({
    required this.homeX,
    required this.homeY,
    required this.e,
    required this.s,
    required this.w,
    required this.n,
  });

  Path get path => parseSvgPathData(toString());

  /// Prints as path string.
  @override
  String toString() =>
      'm $homeX $homeY ${e.edge} ${s.edge} ${w.edge} ${n.edge} z';

  String get edges => 'e: $e. s: $s. w: $w. n: $n';

  PiecePath copyWith({
    double? homeX,
    double? homeY,
    Edge? e,
    Edge? s,
    Edge? w,
    Edge? n,
  }) {
    return PiecePath(
      homeX: homeX ?? this.homeX,
      homeY: homeY ?? this.homeY,
      e: e ?? this.e,
      s: s ?? this.s,
      w: w ?? this.w,
      n: n ?? this.n,
    );
  }
}
