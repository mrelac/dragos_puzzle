// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:dragos_puzzle/main.dart';
import 'package:dragos_puzzle/piece_path.dart';
import 'package:dragos_puzzle/styles/edge.dart';
import 'package:flutter/material.dart';

int nextEdgeKey = 1;

/// Generates [Edge] instances from the given parameters.
/// These instances are used to assign random [Path]s for each [PiecePath].
class PathBuilder {
  final int row;
  final int col;
  final double pieceWidth;
  final double pieceHeight;
  late final double offsetX;
  late final double offsetY;
  late final double bumpSize;

  String get m => 'm $offsetX $offsetY';

  PathBuilder(
    this.row,
    this.col,
  )   : pieceWidth = imageSize.width / maxRC.col,
        pieceHeight = imageSize.height / maxRC.row {
    offsetX = col * pieceWidth;
    offsetY = row * pieceHeight;
    bumpSize = pieceHeight / 4;
  }

  /// Returns [PathParms] bump [pp] as cut or cut[pp] as bump for horizontal path.
  PathParms _flipHorizontal(PathParms pp) =>
      pp.copyWith(p2: -pp.p2, p4: -pp.p4);

  /// Returns [PathParms] bump [pp] as cut or cut[pp] as bump for vertical path.
  PathParms _flipVertical(PathParms pp) => pp.copyWith(p1: -pp.p1, p3: -pp.p3);

  /// Returns [PathParms] drawn in the opposite horizontal direction of [pp].
  PathParms _reverseHorizontal(PathParms pp) => pp.copyWith(
      beforeC: -pp.afterC,
      p1: -pp.p1,
      p2: -pp.p2,
      p3: -pp.p3,
      p4: -pp.p4,
      p5: -pp.p5,
      afterC: -pp.beforeC);

  /// Returns [PathParms] drawn in the opposite vertical direction of [pp].
  PathParms _reverseVertical(PathParms pp) => pp.copyWith(
      beforeC: -pp.afterC,
      p1: -pp.p1,
      p2: -pp.p2,
      p3: -pp.p3,
      p4: -pp.p4,
      p6: -pp.p6,
      afterC: -pp.beforeC);

  /// Returns prev row's east mate, or horiz line if top border edge piece.
  Edge generateEast(PiecePath? prevRow) => row == 0
      ? Edge(edge: 'h $pieceWidth')
      : Edge(edge: prevRow!.w.mate, key: prevRow.w.key);

  /// Returns random edge, or vert line if right border edge piece.
  Edge generateSouth() {
    if (col == maxRC.col - 1) return Edge(edge: 'v $pieceHeight');
    final parms = (Random().nextBool()) ? _southBumpParms : _southCutParms;
    return Edge(
        edge: getVerticalEdge(parms),
        mate: getVerticalMate(parms),
        key: nextEdgeKey++);
  }

  /// Returns random edge, or horiz line if bottom border edge piece.
  Edge generateWest() {
    if (row == maxRC.row - 1) return Edge(edge: 'h ${-pieceWidth}');
    final parms = (Random().nextBool()) ? _westBumpParms : _westCutParms;
    return Edge(
        edge: getHorizontalEdge(parms),
        mate: getHorizontalMate(parms),
        key: nextEdgeKey++);
  }

  /// Returns prev col's south mate, or vert line if left border edge piece.
  Edge generateNorth(PiecePath? prevCol) => col == 0
      ? Edge(edge: 'v ${-pieceHeight}')
      : Edge(edge: prevCol!.s.mate, key: prevCol.s.key);

  PathParms get _eastBumpParms => PathParms(
      beforeC: pieceWidth / 3,
      p1: -(pieceWidth / 6),
      p2: -bumpSize,
      p3: pieceWidth / 2,
      p4: -bumpSize,
      p5: pieceWidth / 3,
      p6: 0,
      afterC: pieceWidth / 3);

  PathParms get _eastCutParms => _flipHorizontal(_eastBumpParms);

  PathParms get _westBumpParms => _reverseHorizontal(_eastBumpParms);

  PathParms get _westCutParms => _reverseHorizontal(_eastCutParms);

  PathParms get _southBumpParms => PathParms(
      beforeC: pieceHeight / 3,
      p1: bumpSize,
      p2: -(pieceHeight / 6),
      p3: bumpSize,
      p4: pieceHeight / 2,
      p5: 0,
      p6: pieceHeight / 3,
      afterC: pieceHeight / 3);

  PathParms get _southCutParms => _flipVertical(_southBumpParms);

  String getHorizontalEdge(PathParms pp) => ((StringBuffer())
        ..write('h ${pp.beforeC}')
        ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
        ..write(' h ${pp.afterC}'))
      .toString();

  String getVerticalEdge(PathParms pp) => ((StringBuffer())
        ..write('v ${pp.beforeC}')
        ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
        ..write(' v ${pp.afterC}'))
      .toString();

  String getHorizontalMateXXX(PathParms pp) =>
      getHorizontalEdge(_reverseHorizontal(pp));

  String getHorizontalMate(PathParms pp) =>
      getHorizontalEdge(_reverseHorizontal(_flipHorizontal(pp)));

  String getVerticalMate(PathParms pp) =>
      getVerticalEdge(_reverseVertical(_flipVertical(pp)));
}

class PathParms {
  final double beforeC;
  final double p1;
  final double p2;
  final double p3;
  final double p4;
  final double p5;
  final double p6;
  final double afterC;
  const PathParms({
    required this.beforeC,
    required this.p1,
    required this.p2,
    required this.p3,
    required this.p4,
    required this.p5,
    required this.p6,
    required this.afterC,
  });

  PathParms copyWith({
    double? beforeC,
    double? p1,
    double? p2,
    double? p3,
    double? p4,
    double? p5,
    double? p6,
    double? afterC,
  }) {
    return PathParms(
      beforeC: beforeC ?? this.beforeC,
      p1: p1 ?? this.p1,
      p2: p2 ?? this.p2,
      p3: p3 ?? this.p3,
      p4: p4 ?? this.p4,
      p5: p5 ?? this.p5,
      p6: p6 ?? this.p6,
      afterC: afterC ?? this.afterC,
    );
  }
}
