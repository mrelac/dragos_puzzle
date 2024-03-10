// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dragos_puzzle/styles/edge_path.dart';
import 'package:flutter/material.dart';

class PathBuilder {
  final Size size;
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;
  final double pieceWidth;
  final double pieceHeight;
  late final double offsetX;
  late final double offsetY;
  late final double bumpSize;
  late final PathParms eastBumpParms;
  late final PathParms southBumpParms;
  late final PathParms westBumpParms;
  late final PathParms northBumpParms;

  final easts = <String>[];
  final souths = <String>[];
  final wests = <String>[];
  final norths = <String>[];
  final pieces = <int, Piece>{};

  PathBuilder({
    required this.size,
    required this.row,
    required this.col,
    required this.maxRow,
    required this.maxCol,
  })  : pieceWidth = size.width / maxCol,
        pieceHeight = size.height / maxRow {
    offsetX = col * pieceWidth;
    offsetY = row * pieceHeight;
    bumpSize = pieceHeight / 4;

    final eastBumpParms = _buildEastBumpParms();
    final eastCutParms = _flipHorizontal(eastBumpParms);
    final westBumpParms = _reverseHorizontal(eastBumpParms);
    final westCutParms = _flipHorizontal(westBumpParms);
    final southBumpParms = _buildSouthBumpParms();
    final southCutParms = _flipVertical(southBumpParms);
    final northBumpParms = _reverseVertical(southBumpParms);
    final northCutParms = _flipVertical(northBumpParms);

    easts.addAll([
      _buildEastPath(eastBumpParms),
      _buildEastPath(eastCutParms),
    ]);
    souths.addAll([
      _buildSouthPath(southBumpParms),
      _buildSouthPath(southCutParms),
    ]);
    wests.addAll([
      _buildWestPath(westBumpParms),
      _buildWestPath(westCutParms),
    ]);
    norths.addAll([
      _buildNorthtPath(northBumpParms),
      _buildNorthtPath(northCutParms),
    ]);
  }

  String createM() => 'm $offsetX $offsetY';

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

  PathParms _buildEastBumpParms() => PathParms(
      beforeC: pieceWidth / 3,
      p1: -(pieceWidth / 6),
      p2: -bumpSize,
      p3: pieceWidth / 2,
      p4: -bumpSize,
      p5: pieceWidth / 3,
      p6: 0,
      afterC: pieceWidth / 3);

  PathParms _buildSouthBumpParms() => PathParms(
      beforeC: pieceHeight / 3,
      p1: bumpSize,
      p2: -(pieceHeight / 6),
      p3: bumpSize,
      p4: pieceHeight / 2,
      p5: 0,
      p6: pieceHeight / 3,
      afterC: pieceHeight / 3);

  String _buildEastPath(PathParms pp) => row == 0
      ? 'h $pieceWidth'
      : ((StringBuffer())
            ..write('h ${pp.beforeC}')
            ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
            ..write(' h ${pp.afterC}'))
          .toString();

  String _buildWestPath(PathParms pp) => row == maxRow - 1
      ? 'h ${-pieceWidth}'
      : ((StringBuffer())
            ..write('h ${pp.beforeC}')
            ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
            ..write(' h ${pp.afterC}'))
          .toString();

  String _buildSouthPath(PathParms pp) => col == maxCol - 1
      ? 'v $pieceHeight'
      : ((StringBuffer())
            ..write('v ${pp.beforeC}')
            ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
            ..write(' v ${pp.afterC}'))
          .toString();

  String _buildNorthtPath(PathParms pp) => col == 0
      ? 'v ${-pieceHeight}'
      : ((StringBuffer())
            ..write('v ${pp.beforeC}')
            ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
            ..write(' v ${pp.afterC}'))
          .toString();
}
//
//
//
//
//
//
//
//
//
//

class Piece {
  final EdgePath e;
  final EdgePath s;
  final EdgePath w;
  final EdgePath n;
  Piece({
    required this.e,
    required this.s,
    required this.w,
    required this.n,
  });
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
