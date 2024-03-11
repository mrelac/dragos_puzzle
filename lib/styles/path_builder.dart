// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dragos_puzzle/styles/edge_path.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

/// This class generates and stores all svg [Path] strings for the given parameters.
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

  final easts = <Edge>[];
  final souths = <Edge>[];
  final wests = <Edge>[];
  final norths = <Edge>[];

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
      _buildEastEdge(eastBumpParms, EdgeStyle.bump),
      _buildEastEdge(eastCutParms, EdgeStyle.cut),
    ]);
    souths.addAll([
      _buildSouthEdge(southBumpParms, EdgeStyle.bump),
      _buildSouthEdge(southCutParms, EdgeStyle.cut),
    ]);
    wests.addAll([
      _buildWestEdge(westBumpParms, EdgeStyle.bump),
      _buildWestEdge(westCutParms, EdgeStyle.cut),
    ]);
    norths.addAll([
      _buildNorthEdge(northBumpParms, EdgeStyle.bump),
      _buildNorthEdge(northCutParms, EdgeStyle.cut),
    ]);
  }

  /// Returns the svg-relative 'm' path component.
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

  Edge _buildEastEdge(PathParms pp, EdgeStyle style) {
    const dir = Dir.e;
    final key = 0; // TODO get next key from preferences.
    return row == 0
        ? Edge(path: 'h $pieceWidth', dir: dir, style: EdgeStyle.line)
        : Edge(key: key, path: getHorizontalPath(pp), dir: dir, style: style);
  }

  Edge _buildSouthEdge(PathParms pp, EdgeStyle style) {
    const dir = Dir.s;
    final key = 0; // TODO get next key from preferences.
    return col == maxCol - 1
        ? Edge(path: 'v $pieceHeight', dir: dir, style: EdgeStyle.line)
        : Edge(key: key, path: getVerticalPath(pp), dir: dir, style: style);
  }

  Edge _buildWestEdge(PathParms pp, EdgeStyle style) {
    const dir = Dir.w;
    final key = 0; // TODO get next key from preferences.
    return row == maxRow - 1
        ? Edge(path: 'h ${-pieceWidth}', dir: dir, style: EdgeStyle.line)
        : Edge(key: key, path: getHorizontalPath(pp), dir: dir, style: style);
  }

  Edge _buildNorthEdge(PathParms pp, EdgeStyle style) {
    const dir = Dir.n;
    final key = 0; // TODO get next key from preferences.
    return col == 0
        ? Edge(path: 'v ${-pieceHeight}', dir: dir, style: EdgeStyle.line)
        : Edge(key: key, path: getVerticalPath(pp), dir: dir, style: style);
  }

  //  row == maxRow - 1
  //     ? 'h ${-pieceWidth}'
  //     : ((StringBuffer())
  //           ..write('h ${pp.beforeC}')
  //           ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
  //           ..write(' h ${pp.afterC}'))
  //         .toString();

  // Edge _buildSouthEdge(PathParms pp) => col == maxCol - 1
  //     ? 'v $pieceHeight'
  //     : ((StringBuffer())
  //           ..write('v ${pp.beforeC}')
  //           ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
  //           ..write(' v ${pp.afterC}'))
  //         .toString();

  // Edge _buildNorthtEdge(PathParms pp) => col == 0
  //     ? 'v ${-pieceHeight}'
  //     : ((StringBuffer())
  //           ..write('v ${pp.beforeC}')
  //           ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
  //           ..write(' v ${pp.afterC}'))
  //         .toString();
}

String getHorizontalPath(PathParms pp) => ((StringBuffer())
      ..write('h ${pp.beforeC}')
      ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
      ..write(' h ${pp.afterC}'))
    .toString();

String getVerticalPath(PathParms pp) => ((StringBuffer())
      ..write('v ${pp.beforeC}')
      ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
      ..write(' v ${pp.afterC}'))
    .toString();

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

  Path get path => parseSvgPathData(
      'm $offsetX $offsetY ${e.path} ${s.path} ${w.path} ${n.path}');

  /// Prints as path string.
  @override
  String toString() =>
      'm $offsetX $offsetY ${e.path} ${s.path} ${w.path} ${n.path}';

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
