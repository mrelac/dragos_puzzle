// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:dragos_puzzle/main.dart';
import 'package:dragos_puzzle/piece_path.dart';
import 'package:dragos_puzzle/styles/edge.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Generates all possible [Edge] instances from the given parameters.
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

  void printAllEdges() {
    if (kDebugMode) {
      // print('pathBuilder$row$col eastBump edge: $m ${easts[0].edge.path}');
      // print('pathBuilder$row$col eastBump mate: $m ${easts[0].mate.path}');
      // print('pathBuilder$row$col eastCut edge: $m ${easts[1].edge.path}');
      // print('pathBuilder$row$col eastCut mate: $m ${easts[1].mate.path}');
      // print('PathBuilder2');

      // print('pathBuilder$row$col southBump edge: $m ${souths[0].edge.path}');
      // print('pathBuilder$row$col southBump mate: $m ${souths[0].mate.path}');
      // print('pathBuilder$row$col southCut edge: $m ${souths[1].edge.path}');
      // print('pathBuilder$row$col southCut mate: $m ${souths[1].mate.path}');
      // print('PathBuilder2');

      // print('pathBuilder$row$col westBump edge: $m ${wests[0].edge.path}');
      // print('pathBuilder$row$col westBump mate: $m ${wests[0].mate.path}');
      // print('pathBuilder$row$col westCut edge: $m ${wests[1].edge.path}');
      // print('pathBuilder$row$col westCut mate: $m ${wests[1].mate.path}');
      // print('PathBuilder2');

      // print('pathBuilder$row$col northBump edge: $m ${norths[0].edge.path}');
      // print('pathBuilder$row$col northBump mate: $m ${norths[0].mate.path}');
      // print('pathBuilder$row$col northCut edge: $m ${norths[1].edge.path}');
      // print('pathBuilder$row$col northCut mate: $m ${norths[1].mate.path}');
      // print('PathBuilder2');
      // print('PathBuilder2');
    }
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
  Edge generateEast(PiecePath? prevRow) {
    if (row == 0) return Edge(edge: 'h $pieceWidth');
    // // return Edge(edge: prevRow!.e.mate);
    // return generateSouth();
    return Edge(edge: prevRow!.w.mateFlipped);
  }

  /// Returns random edge, or vert line if right border edge piece.
  Edge generateSouth() {
    if (col == maxRC.col - 1) return Edge(edge: 'v $pieceHeight');
    final bool next = Random().nextBool();
    final parms = next ? _southBumpParms : _southCutParms;
    print('pp$row$col GENERATED South ${next ? "Bump" : "Cut"}');
    // final parms = (Random().nextBool()) ? _southBumpParms : _southCutParms;
    return Edge(edge: getVerticalEdge(parms), mate: getVerticalMate(parms), mateFlipped: getVerticalMateFlipped(parms));
  }

  /// Returns random edge, or horiz line if bottom border edge piece.
  Edge generateWest() {
    if (row == maxRC.row - 1) return Edge(edge: 'h ${-pieceWidth}');
    final bool next = Random().nextBool();
    final parms = next ? _westBumpParms : _westCutParms;
    // final parms = (Random().nextBool()) ? _westBumpParms : _westCutParms;
    print('pp$row$col GENERATED West ${next ? "Bump" : "Cut"}');
    return Edge(
        edge: getHorizontalEdge(parms),
        mate: getHorizontalMate(parms),
        mateFlipped: getHorizontalMateFlipped(parms));
  }

  /// Returns prev col's south mate, or vert line if left border edge piece.
  Edge generateNorth(PiecePath? prevCol) {
    if (col == 0) return Edge(edge: 'v ${-pieceHeight}');
    return Edge(edge: prevCol!.s.mateFlipped);
  }

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

  PathParms get _northBumpParms => _reverseVertical(_southBumpParms);

  PathParms get _northCutParms => _reverseVertical(_southCutParms);

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

  String getHorizontalMate(PathParms pp) =>
      getHorizontalEdge(_reverseHorizontal(pp));

  String getHorizontalMateFlipped(PathParms pp) =>
      getHorizontalEdge(_reverseHorizontal(_flipHorizontal(pp)));

  String getVerticalMate(PathParms pp) => getVerticalEdge(_reverseVertical(pp));

  String getVerticalMateFlipped(PathParms pp) =>
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
