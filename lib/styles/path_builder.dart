// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dragos_puzzle/styles/edge_pair.dart';
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

  // /// Flips [PathParms]. [dir] is the direction of [pp].
  // PathParms _flip(PathParms pp, Dir dir) {
  //   if ((dir == Dir.e) || (dir == Dir.w)) {
  //     return pp.copyWith(p2: -pp.p2, p4: -pp.p4);
  //   } else {
  //     return pp.copyWith(p1: -pp.p1, p3: -pp.p3);
  //   }
  // }

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

  /// Returns [pp] drawn in the opposite direction of [dir].
  // PathParms _reverse(PathParms pp, Dir dir) {
  //   if ((dir == Dir.e) || (dir == Dir.w)) {
  //     return pp.copyWith(
  //         beforeC: -pp.afterC,
  //         p1: -pp.p1,
  //         p2: -pp.p2,
  //         p3: -pp.p3,
  //         p4: -pp.p4,
  //         p5: -pp.p5,
  //         afterC: -pp.beforeC);
  //   } else {
  //     return pp.copyWith(
  //         beforeC: -pp.afterC,
  //         p1: -pp.p1,
  //         p2: -pp.p2,
  //         p3: -pp.p3,
  //         p4: -pp.p4,
  //         p6: -pp.p6,
  //         afterC: -pp.beforeC);
  //   }
  // }

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

  // @Deprecated('Not used')
  // List<EdgePair> createEast() {
  //   final pp = PathParms(
  //       beforeC: pieceWidth / 3,
  //       p1: -(pieceWidth / 6),
  //       p2: bumpSize,
  //       p3: pieceWidth / 2,
  //       p4: bumpSize,
  //       p5: pieceWidth / 3,
  //       p6: 0,
  //       afterC: pieceWidth / 3);
  //   final bumpEdgePair = _buildEdgePair(pp, Dir.e);
  //   final cutEdgePair =
  //       _buildEdgePair(pp.copyWith(p2: -pp.p2, p4: -pp.p4), Dir.e);
  //   return [bumpEdgePair, cutEdgePair];
  // }

  // @Deprecated('Not used')
  // List<EdgePair> createWest() {
  //   final pp = PathParms(
  //       beforeC: pieceWidth / 3,
  //       p1: -(pieceWidth / 6),
  //       p2: -bumpSize,
  //       p3: pieceWidth / 2,
  //       p4: -bumpSize,
  //       p5: pieceWidth / 3,
  //       p6: 0,
  //       afterC: pieceWidth / 3);
  //   final bumpEdgePair = _buildEdgePair(pp, Dir.e);
  //   final cutEdgePair =
  //       _buildEdgePair(pp.copyWith(p2: -pp.p2, p4: -pp.p4), Dir.e);
  //   return [bumpEdgePair, cutEdgePair];
  // }

  /// Returns a horizontal or vertical [EdgePath] built from [pp] and [dir].
  ///
  /// Whether bump or cut is determined by [pp] settings.
  // EdgePath _buildEdgePath(PathParms pp, Dir dir) {
  //   String path;
  //   if (dir == Dir.e) {
  //     path = _buildEast(pp);
  //   } else if (dir == Dir.s) {
  //     path = _buildSouth(pp);
  //   } else if (dir == Dir.w) {
  //     path = _buildWest(pp);
  //   } else {
  //     path = _buildNorth(pp);
  //   }

  //   return EdgePair(
  //       dir: dir,
  //       row: row,
  //       col: col,
  //       maxRow: maxRow,
  //       maxCol: maxCol,
  //       path: path,
  //       mate: mate);
  // }

  // String _buildEast(PathParms pp) {
  //   final sb = StringBuffer();
  //   if (row == 0) {
  //     sb.write('h $pieceWidth');
  //   } else {
  //     sb
  //       ..write('h ${pp.beforeC}')
  //       ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
  //       ..write(' h ${pp.afterC}');
  //   }
  //   return sb.toString();
  // }
  String _buildEastPath(PathParms pp) => row == 0
      ? 'h $pieceWidth'
      : ((StringBuffer())
            ..write('h ${pp.beforeC}')
            ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
            ..write(' h ${pp.afterC}'))
          .toString();

  // String _buildWest(PathParms pp) {
  //   final sb = StringBuffer();
  //   if (row == maxRow - 1) {
  //     sb.write('h ${-pieceWidth}');
  //   } else {
  //     sb
  //       ..write('h ${pp.beforeC}')
  //       ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
  //       ..write(' h ${pp.afterC}');
  //   }
  //   return sb.toString();
  // }
  String _buildWestPath(PathParms pp) => row == maxRow - 1
      ? 'h ${-pieceWidth}'
      : ((StringBuffer())
            ..write('h ${pp.beforeC}')
            ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
            ..write(' h ${pp.afterC}'))
          .toString();

  // String _buildSouth(PathParms pp) {
  //   final sb = StringBuffer();
  //   if (col == maxCol - 1) {
  //     sb.write('v $pieceHeight');
  //   } else {
  //     sb
  //       ..write('v ${pp.beforeC}')
  //       ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
  //       ..write(' v ${pp.afterC}');
  //   }
  //   return sb.toString();
  // }
  String _buildSouthPath(PathParms pp) => col == maxCol - 1
      ? 'v $pieceHeight'
      : ((StringBuffer())
            ..write('v ${pp.beforeC}')
            ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
            ..write(' v ${pp.afterC}'))
          .toString();

  // String _buildNorth(PathParms pp) {
  //   final sb = StringBuffer();
  //   if (col == 0) {
  //     sb.write('v ${-pieceHeight}');
  //   } else {
  //     sb
  //       ..write('v ${pp.beforeC}')
  //       ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
  //       ..write(' v ${pp.afterC}');
  //   }
  //   return sb.toString();
  // }
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
  final EdgePair e;
  final EdgePair s;
  final EdgePair w;
  final EdgePair n;
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

/// Creates and loads [EdgePair] instances
class EdgesCreator {
  // final Dir dir;
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
  final sb = StringBuffer();

  EdgesCreator({
    // required this.dir,
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

    eastBumpParms = _buildEastBumpParms();
    westBumpParms = _reverse(eastBumpParms, Dir.e);
    southBumpParms = _buildSouthBumpParms();
    northBumpParms = _reverse(southBumpParms, Dir.s);

    easts.addAll([
      _buildEdgePair(eastBumpParms, Dir.e),
      _buildEdgePair(_flip(eastBumpParms, Dir.e), Dir.e)
    ]);
    souths.addAll([
      _buildEdgePair(southBumpParms, Dir.s),
      _buildEdgePair(_flip(southBumpParms, Dir.s), Dir.s)
    ]);
    wests.addAll([
      _buildEdgePair(westBumpParms, Dir.w),
      _buildEdgePair(_flip(westBumpParms, Dir.w), Dir.w)
    ]);
    norths.addAll([
      _buildEdgePair(northBumpParms, Dir.n),
      _buildEdgePair(_flip(northBumpParms, Dir.n), Dir.n)
    ]);
  }

  final easts = <EdgePair>[];
  final souths = <EdgePair>[];
  final wests = <EdgePair>[];
  final norths = <EdgePair>[];
  final pieces = <int, Piece>{};

  String createM() => 'm $offsetX $offsetY';

  /// Flips [PathParms]. [dir] is the direction of [pp].
  PathParms _flip(PathParms pp, Dir dir) {
    if ((dir == Dir.e) || (dir == Dir.w)) {
      return pp.copyWith(p2: -pp.p2, p4: -pp.p4);
    } else {
      return pp.copyWith(p1: -pp.p1, p3: -pp.p3);
    }
  }

  /// Returns [pp] drawn in the opposite direction of [dir].
  PathParms _reverse(PathParms pp, Dir dir) {
    if ((dir == Dir.e) || (dir == Dir.w)) {
      return pp.copyWith(
          beforeC: -pp.afterC,
          p1: -pp.p1,
          p3: -pp.p3,
          p5: -pp.p5,
          afterC: -pp.beforeC);
    } else {
      return pp.copyWith(
          beforeC: -pp.afterC,
          p2: -pp.p2,
          p4: -pp.p4,
          p6: -pp.p6,
          afterC: -pp.beforeC);
    }
  }

  // String createEbump1() {
  //   sb.clear();
  //   if (row == 0) {
  //     sb.write('L ${offsetX + width} $offsetY');
  //   } else {
  //     sb
  //       ..write('L ${offsetX + width / 3} $offsetY')
  //       ..write(' C ${offsetX + width / 6}')
  //       ..write(' ${offsetY - bumpSize}')
  //       ..write(' ${offsetX + width / 6 * 5}')
  //       ..write(' ${offsetY - bumpSize}')
  //       ..write(' ${offsetX + width / 3 * 2}')
  //       ..write(' $offsetY')
  //       ..write(' L ${offsetX + width} $offsetY');
  //   }
  //   return sb.toString();
  // }

  String createEbump1_GOOD_ORIGINAL() {
    double beforeC = offsetX + pieceWidth / 3;
    final double p1 = offsetX + pieceWidth / 6;
    final double p2 = offsetY - bumpSize;
    final double p3 = offsetX + pieceWidth / 6 * 5;
    final double p4 = offsetY - bumpSize;
    final double p5 = offsetX + pieceWidth / 3 * 2;
    final double p6 = offsetY;
    double afterC = offsetX + pieceWidth;
    sb.clear();
    if (row == 0) {
      sb.write('H ${offsetX + pieceWidth}');
    } else {
      sb
        ..write('H $beforeC')
        ..write(' C $p1 $p2 $p3 $p4 $p5 $p6')
        ..write(' H $afterC');
    }
    return sb.toString();
  }

  PathParms _buildEastBumpParms() => PathParms(
      beforeC: pieceWidth / 3,
      p1: -(pieceWidth / 6),
      p2: bumpSize,
      p3: pieceWidth / 2,
      p4: bumpSize,
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

  // PathParms _buildWestBumpParms() => _reverse(eastBumpParms, Dir.e);
  //     PathParms(beforeC: pieceWidth / 3,
  //     p1: -(pieceWidth / 6),
  //     p2: bumpSize,
  //     p3: pieceWidth / 2,
  //     p4: bumpSize,
  //     p5: pieceWidth / 3,
  //     p6: 0,
  //     afterC: pieceWidth / 3);

  String createEbump1() {
    final p = PathParms(
        beforeC: pieceWidth / 3,
        p1: -(pieceWidth / 6),
        p2: bumpSize,
        p3: pieceWidth / 2,
        p4: bumpSize,
        p5: pieceWidth / 3,
        p6: 0,
        afterC: pieceWidth / 3);

    // double beforeC = pieceWidth / 3;
    // final double p1 = -(pieceWidth / 6);
    // final double p2 = (bumpSize);
    // final double p3 = pieceWidth / 2;
    // final double p4 = (bumpSize);
    // final double p5 = pieceWidth / 3;
    // const double p6 = 0;
    // double afterC = pieceWidth / 3;
    sb.clear();
    if (row == 0) {
      sb.write('h $pieceWidth');
    } else {
      sb
        ..write('h ${p.beforeC}')
        ..write(' c ${p.p1} ${p.p2} ${p.p3} ${p.p4} ${p.p5} ${p.p6}')
        ..write(' h ${p.afterC}');
    }
    return sb.toString();
  }

  // @Deprecated('Not used')
  // List<EdgePair> createEast() {
  //   final pp = PathParms(
  //       beforeC: pieceWidth / 3,
  //       p1: -(pieceWidth / 6),
  //       p2: bumpSize,
  //       p3: pieceWidth / 2,
  //       p4: bumpSize,
  //       p5: pieceWidth / 3,
  //       p6: 0,
  //       afterC: pieceWidth / 3);
  //   final bumpEdgePair = _buildEdgePair(pp, Dir.e);
  //   final cutEdgePair =
  //       _buildEdgePair(pp.copyWith(p2: -pp.p2, p4: -pp.p4), Dir.e);
  //   return [bumpEdgePair, cutEdgePair];
  // }

  // @Deprecated('Not used')
  // List<EdgePair> createWest() {
  //   final pp = PathParms(
  //       beforeC: pieceWidth / 3,
  //       p1: -(pieceWidth / 6),
  //       p2: -bumpSize,
  //       p3: pieceWidth / 2,
  //       p4: -bumpSize,
  //       p5: pieceWidth / 3,
  //       p6: 0,
  //       afterC: pieceWidth / 3);
  //   final bumpEdgePair = _buildEdgePair(pp, Dir.e);
  //   final cutEdgePair =
  //       _buildEdgePair(pp.copyWith(p2: -pp.p2, p4: -pp.p4), Dir.e);
  //   return [bumpEdgePair, cutEdgePair];
  // }

  /// Returns a horizontal or vertical [EdgePair] built from [pp] and [dir].
  ///
  /// Whether bump or cut is determined by [pp] settings.
  EdgePair _buildEdgePair(PathParms pp, Dir dir) {
    String path;
    String mate;
    final matePP = _flip(_reverse(pp, dir), dir);
    if (dir == Dir.e) {
      path = _buildEast(pp);
      mate = _buildWest(matePP);
    } else if (dir == Dir.s) {
      path = _buildSouth(pp);
      mate = _buildNorth(matePP);
    } else if (dir == Dir.w) {
      path = _buildWest(pp);
      mate = _buildEast(matePP);
    } else {
      path = _buildNorth(pp);
      mate = _buildSouth(matePP);
    }

    return EdgePair(
        dir: dir,
        row: row,
        col: col,
        maxRow: maxRow,
        maxCol: maxCol,
        path: path,
        mate: mate);
  }

  String _buildEast(PathParms pp) {
    final sb = StringBuffer();
    if (row == 0) {
      sb.write('h $pieceWidth');
    } else {
      sb
        ..write('h ${pp.beforeC}')
        ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
        ..write(' h ${pp.afterC}');
    }
    return sb.toString();
  }

  String _buildWest(PathParms pp) {
    final sb = StringBuffer();
    if (row == maxRow - 1) {
      sb.write('h ${-pieceWidth}');
    } else {
      sb
        ..write('h ${pp.beforeC}')
        ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
        ..write(' h ${pp.afterC}');
    }
    return sb.toString();
  }

  String _buildSouth(PathParms pp) {
    final sb = StringBuffer();
    if (col == maxCol - 1) {
      sb.write('v $pieceHeight');
    } else {
      sb
        ..write('v ${pp.beforeC}')
        ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
        ..write(' v ${pp.afterC}');
    }
    return sb.toString();
  }

  String _buildNorth(PathParms pp) {
    final sb = StringBuffer();
    if (col == 0) {
      sb.write('v ${-pieceHeight}');
    } else {
      sb
        ..write('v ${pp.beforeC}')
        ..write(' c ${pp.p1} ${pp.p2} ${pp.p3} ${pp.p4} ${pp.p5} ${pp.p6}')
        ..write(' v ${pp.afterC}');
    }
    return sb.toString();
  }

  // String createEcut1() {
  //   sb.clear();
  //   if (row == 0) {
  //     sb.write('L ${offsetX + pieceWidth} $offsetY');
  //   } else {
  //     sb
  //       ..write('L ${offsetX + pieceWidth / 3} $offsetY')
  //       ..write(' C ${offsetX + pieceWidth / 6}')
  //       ..write(' ${offsetY - bumpSize}')
  //       ..write(' ${offsetX + pieceWidth / 6 * 5}')
  //       ..write(' ${offsetY - bumpSize}')
  //       ..write(' ${offsetX + pieceWidth / 3 * 2}')
  //       ..write(' $offsetY')
  //       ..write(' L ${offsetX + pieceWidth} $offsetY');
  //   }
  //   return sb.toString();
  // }

  // String createEcut1() {
  //   sb.clear();
  //   if (row == 0) {
  //     sb.write('L ${offsetX + width} $offsetY');
  //   } else {
  //     sb
  //       ..write('L ${offsetX + width / 3} $offsetY')
  //       ..write(' C ${offsetX + width / 6}')
  //       ..write(' ${offsetY - bumpSize}')
  //       ..write(' ${offsetX + width / 6 * 5}')
  //       ..write(' ${offsetY - bumpSize}')
  //       ..write(' ${offsetX + width / 3 * 2}')
  //       ..write(' $offsetY')
  //       ..write(' L ${offsetX + width} $offsetY');
  //   }
  //   return sb.toString();
  // }

  String createScut1() {
    sb.clear();
    if (col == maxCol - 1) {
      sb.write('L ${offsetX + pieceWidth} ${offsetY + pieceHeight}');
    } else {
      sb
        ..write('L ${offsetX + pieceWidth} ${offsetY + pieceHeight / 3}')
        ..write(' C ${offsetX + pieceWidth - bumpSize}')
        ..write(' ${offsetY + pieceHeight / 6}')
        ..write(' ${offsetX + pieceWidth - bumpSize}')
        ..write(' ${offsetY + pieceHeight / 6 * 5}')
        ..write(' ${offsetX + pieceWidth}')
        ..write(' ${offsetY + pieceHeight / 3 * 2}')
        ..write(' L ${offsetX + pieceWidth} ${offsetY + pieceHeight}');
    }
    return sb.toString();
  }

  String createWcut1() {
    sb.clear();
    if (row == maxRow - 1) {
      sb.write('L $offsetX ${offsetY + pieceHeight}');
    } else {
      sb
        ..write('L ${offsetX + pieceWidth / 3 * 2} ${offsetY + pieceHeight}')
        ..write(' C ${offsetX + pieceWidth / 6 * 5}')
        ..write(' ${offsetY + pieceHeight - bumpSize}')
        ..write(' ${offsetX + pieceWidth / 6}')
        ..write(' ${offsetY + pieceHeight - bumpSize}')
        ..write(' ${offsetX + pieceWidth / 3}')
        ..write(' ${offsetY + pieceHeight}')
        ..write(' L $offsetX ${offsetY + pieceHeight}');
    }
    return sb.toString();
  }

  String createNbump1() {
    sb.clear();
    if (col == 0) {
      sb.write('Z');
    } else {
      sb
        ..write('L $offsetX ${offsetY + pieceHeight / 3 * 2}')
        ..write(' C ${offsetX - bumpSize}')
        ..write(' ${offsetY + pieceHeight / 6 * 5}')
        ..write(' ${offsetX - bumpSize}')
        ..write(' ${offsetY + pieceHeight / 6}')
        ..write(' $offsetX')
        ..write(' ${offsetY + pieceHeight / 3}')
        ..write(' Z');
    }
    return sb.toString();
  }
}

void thang() {
  '''
PIECE 0
  ABSOLUTE
    south cut   M 0 0 L 0 95.3448 C -71.5086 47.6724 -71.5086 238.362 0 190.6896 L 0 286
    south bump  M 0 0 L 0 95.3448 C 71.5086 47.6724 71.5086 238.362 0 190.6896 L 0 286
    north cut   M 0 286 L 0 190.6896 C -71.5086 238.362 -71.5086 47.6724 0 95 L 0 -95
    north bump  M 0 286 L 0 190.6896 C 71.5086 238.362 71.5086 47.6724 0 95 L 0 -95
  RELATIVE
    south cut   m 0 0 l 0 95.3448 c -71.5086 -47.6724 -71.5086 143.0172 0 95.3448 l 0 95.3104
    south bump  m 0 0 l 0 95.3448 c 71.5086 -47.6724 71.5086 143.0172 0 95.3448 l 0 95.3104
    north cut   m 0 286 l 0 -95.3104 c -71.5086 47.6724 -71.5086 -143.0172 0 -95.6896 l 0 -190
    north bump  m 0 286 l 0 -95.3104 c 71.5086 47.6724 71.5086 -143.0172 0 -95.6896 l 0 -190

  ABSOLUTE
    east cut    M 381.3793 286.0345 L 508.5057 286.0345 C 444.9425 357.5431 699.1954 357.5431 635.6321 286.0345 L 762.7585 286.0345
    east bump   M 381.3793 286.0345 L 508.5057 286.0345 C 444.9425 214.5259 699.1954 214.5259 635.6321 286.0345 L 762.7585 286.0345
    west cut    M 381.3793 286.0345 L 508.5057 286.0345 C 444.9425 357.5431 699.1954 357.5431 635.6322 286.0345 L 762.7586 286.0345
    west bump   M 762.758 286.034 L 635.632 286.034 C 699.1954 214.5259 444.9425 214.5259 508.5057 286.0345 L 381.3793 286.0345
  RELATIVE
    east cut    m 381.3793 286.0345 l 127.1264 0 c -63.5632 71.5086 190.6897 71.5086 127.1264 0 l 127.1264 0
    east bump   m 381.3793 286.0345 l 127.1264 0 c -63.5632 -71.5086 190.6897 -71.5086 127.1264 0 l 127.1264 0
    west cut    m 381.3793 286.0345 l 127.1264 0 c -63.5632 71.5086 190.6897 71.5086 127.1264 0 l 127.1264 0
    west bump   m 762.758 286.034 l -127.126 0 c 63.5634 -71.5081 -190.6895 -71.5081 -127.1263 0.0005 l -127.1264 0


  USING H and V instead of L:
  ABSOLUTE
    south cut   M 0 0 V 95.3448 C -71.5086 47.6724 -71.5086 238.362 0 190.6896 V 286
    south bump  M 0 0 V 95.3448 C 71.5086 47.6724 71.5086 238.362 0 190.6896 V 286
    north cut   M 0 286 V 190.6896 C -71.5086 238.362 -71.5086 47.6724 0 95 V -95
    north bump  M 0 286 V 190.6896 C 71.5086 238.362 71.5086 47.6724 0 95 V -95
      To make a bump from a cut, swap the sign for the "C" p1 and p3.
  RELATIVE
    south cut   m 0 0 v 95.3448 c -71.5086 -47.6724 -71.5086 143.0172 0 95.3448 v 95.3104
    south bump  m 0 0 v 95.3448 c 71.5086 -47.6724 71.5086 143.0172 0 95.3448 v 95.3104
    north cut   m 0 286 v -95.3104 c -71.5086 47.6724 -71.5086 -143.0172 0 -95.6896 v -190
    north bump  m 0 286 v -95.3104 c 71.5086 47.6724 71.5086 -143.0172 0 -95.6896 v -190
      To make a bump from a cut, swap the sign for the "C" p1 and p3.
  ABSOLUTE
    east cut    M 381.3793 286.0345 H 508.5057 C 444.9425 357.5431 699.1954 357.5431 635.6321 286.0345 H 762.7585
    east bump   M 381.3793 286.0345 H 508.5057 C 444.9425 214.5259 699.1954 214.5259 635.6321 286.0345 H 762.7585
    west cut    M 381.3793 286.0345 H 508.5057 C 444.9425 357.5431 699.1954 357.5431 635.6322 286.0345 H 762.7586
    west bump   M 762.758 286.034 H 635.632 C 699.1954 214.5259 444.9425 214.5259 508.5057 286.0345 H 381.3793
      To make a bump from a cut, subtract (2 * 71.5086) from "C" p2 and p4.
      To make a cut from a bump, add (2 * 71.5086) to "C" p2 and p4.
  RELATIVE
    east cut    m 381.3793 286.0345 h 127.1264 c -63.5632 71.5086 190.6897 71.5086 127.1264 0 h 127.1264
    east bump   m 381.3793 286.0345 h 127.1264 c -63.5632 -71.5086 190.6897 -71.5086 127.1264 0 h 127.1264
    west cut    m 381.3793 286.0345 h 127.1264 c -63.5632 71.5086 190.6897 71.5086 127.1265 0 h 127.1264
    west bump   m 762.758 286.034 h -127.126 c 63.5634 -71.5081 -190.6895 -71.5081 -127.1263 0.0005 h -127.1264
      To make a cut from a bump, add (2 * 71.5086) to "C" p2 and p4.



(0, 0) absolute
M 0.0 0.0
  L 381.3793103448276 0.0 
  L 381.3793103448276 95.3448275862069 
  C 309.87068965517244 47.67241379310345 309.87068965517244 238.36206896551727 381.3793103448276 190.6896551724138
  L 381.3793103448276 286.0344827586207
  L 254.2528735632184 286.0344827586207
  C 317.816091954023 214.52586206896552 63.5632183908046 214.52586206896552 127.1264367816092 286.0344827586207
  L 0.0 286.0344827586207
  Z

(0, 0) absolute, inverted:
M 0 0
  L 381.3793 0
  L 381.3793 95.3448
  C 452.8879 47.6724 452.8879 238.362 381.3793 190.6896
  L 381.3793 286.0345
  L 254.2529 286.0345
  C 317.8161 214.5258 63.5632 214.5258 127.1264 286.0345
  L 0 286.0345
  Z

(0, 0) relative (cut)
m 0 0
  l 381.3793 0
  l 0 95.3448
  c -71.5086 -47.6724 -71.5086 143.0172 0 95.3448
  l 0 95.3448
  l -127.1264 0
  c 63.5632 -71.5086 -190.6897 -71.5086 -127.1264 0
  l -127.1264 0
  z
  (1st & 3rd 'c' parm swap sign)

(0, 0) relative, inverted (bump):
m 0 0
  l 381.3793 0 
  l 0 95.3448 
  c 71.5086 -47.6724 71.5086 143.0172 0 95.3448
  l 0 95.3448
  l -127.1264 0
  c 63.5632 71.5086 -190.6897 71.5086 -127.1264 0
  l -127.1264 0 z
(2nd & 4th 'c' parm swap sign)


(1, 0)
M 381.3793103448276 0.0 L 762.7586206896552 0.0 L 762.7586206896552 95.3448275862069 C 691.25 47.67241379310345 691.25 238.36206896551727 762.7586206896552 190.6896551724138 L 762.7586206896552 286.0344827586207 L 635.632183908046 286.0344827586207 C 699.1954022988507 214.52586206896552 444.9425287356322 214.52586206896552 508.5057471264368 286.0344827586207 L 381.3793103448276 286.0344827586207 L 381.3793103448276 190.6896551724138 C 309.87068965517244 238.36206896551727 309.87068965517244 47.67241379310345 381.3793103448276 95.3448275862069 Z

(2, 0)
M 762.7586206896552 0.0 L 1144.1379310344828 0.0 L 1144.1379310344828 286.0344827586207 L 1017.0114942528736 286.0344827586207 C 1080.5747126436781 214.52586206896552 826.3218390804599 214.52586206896552 889.8850574712644 286.0344827586207 L 762.7586206896552 286.0344827586207 L 762.7586206896552 190.6896551724138 C 691.25 238.36206896551727 691.25 47.67241379310345 762.7586206896552 95.3448275862069 Z

(1, 0)
M 0.0 286.0344827586207 L 127.1264367816092 286.0344827586207 C 63.5632183908046 214.52586206896552 317.816091954023 214.52586206896552 254.2528735632184 286.0344827586207 L 381.3793103448276 286.0344827586207 L 381.3793103448276 381.3793103448276 C 309.87068965517244 333.7068965517241 309.87068965517244 524.3965517241379 381.3793103448276 476.72413793103453 L 381.3793103448276 572.0689655172414 L 254.2528735632184 572.0689655172414 C 317.816091954023 500.5603448275862 63.5632183908046 500.5603448275862 127.1264367816092 572.0689655172414 L 0.0 572.0689655172414 Z

(1, 1)
M 381.3793103448276 286.0344827586207 L 508.5057471264368 286.0344827586207 C 444.9425287356322 214.52586206896552 699.1954022988507 214.52586206896552 635.632183908046 286.0344827586207 L 762.7586206896552 286.0344827586207 L 762.7586206896552 381.3793103448276 C 691.25 333.7068965517241 691.25 524.3965517241379 762.7586206896552 476.72413793103453 L 762.7586206896552 572.0689655172414 L 635.632183908046 572.0689655172414 C 699.1954022988507 500.5603448275862 444.9425287356322 500.5603448275862 508.5057471264368 572.0689655172414 L 381.3793103448276 572.0689655172414 L 381.3793103448276 476.72413793103453 C 309.87068965517244 524.3965517241379 309.87068965517244 333.7068965517241 381.3793103448276 381.3793103448276 Z

(1, 2)
M 762.7586206896552 286.0344827586207 L 889.8850574712644 286.0344827586207 C 826.3218390804599 214.52586206896552 1080.5747126436781 214.52586206896552 1017.0114942528736 286.0344827586207 L 1144.1379310344828 286.0344827586207 L 1144.1379310344828 572.0689655172414 L 1017.0114942528736 572.0689655172414 C 1080.5747126436781 500.5603448275862 826.3218390804599 500.5603448275862 889.8850574712644 572.0689655172414 L 762.7586206896552 572.0689655172414 L 762.7586206896552 476.72413793103453 C 691.25 524.3965517241379 691.25 333.7068965517241 762.7586206896552 381.3793103448276 Z

(2, 0)
M 0.0 572.0689655172414 L 127.1264367816092 572.0689655172414 C 63.5632183908046 500.5603448275862 317.816091954023 500.5603448275862 254.2528735632184 572.0689655172414 L 381.3793103448276 572.0689655172414 L 381.3793103448276 667.4137931034483 C 309.87068965517244 619.7413793103449 309.87068965517244 810.4310344827586 381.3793103448276 762.7586206896552 L 381.3793103448276 858.1034482758621 L 0.0 858.1034482758621 Z

(2, 1)
M 381.3793103448276 572.0689655172414 L 508.5057471264368 572.0689655172414 C 444.9425287356322 500.5603448275862 699.1954022988507 500.5603448275862 635.632183908046 572.0689655172414 L 762.7586206896552 572.0689655172414 L 762.7586206896552 667.4137931034483 C 691.25 619.7413793103449 691.25 810.4310344827586 762.7586206896552 762.7586206896552 L 762.7586206896552 858.1034482758621 L 381.3793103448276 858.1034482758621 L 381.3793103448276 762.7586206896552 C 309.87068965517244 810.4310344827586 309.87068965517244 619.7413793103449 381.3793103448276 667.4137931034483 Z

(2, 2)
M 762.7586206896552 572.0689655172414 L 889.8850574712644 572.0689655172414 C 826.3218390804599 500.5603448275862 1080.5747126436781 500.5603448275862 1017.0114942528736 572.0689655172414 L 1144.1379310344828 572.0689655172414 L 1144.1379310344828 858.1034482758621 L 762.7586206896552 858.1034482758621 L 762.7586206896552 762.7586206896552 C 691.25 810.4310344827586 691.25 619.7413793103449 762.7586206896552 667.4137931034483 Z
''';
}
