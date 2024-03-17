// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dragos_puzzle/main.dart';
import 'package:dragos_puzzle/piece_path.dart';
// import 'package:dragos_puzzle/piece_path.dart';
import 'package:dragos_puzzle/puzzle_piece.dart';
import 'package:dragos_puzzle/rc.dart';
import 'package:dragos_puzzle/styles/edge.dart';
import 'package:dragos_puzzle/styles/path_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const isNewPuzzle = true;

class PuzzleLoader {
  // FIXME - Finish removing these 3 parms from PuzzleLoader2. Let the caller
  // drive the operation by calling PiecesGenerator (with parms) to
  // prepare (split and save) the new puzzle.
  final Image image;
  final Function bringToTop;
  final Function sendToBack;
  PuzzleLoader({
    required this.image,
    required this.bringToTop,
    required this.sendToBack,
  });

  /// Returns all puzzle pieces from storage.
  List<PuzzlePiece> getPieces() {
    final pieces = <PuzzlePiece>[];
    if (isNewPuzzle) {
      final pg = PiecesGenerator(
          image: image, bringToTop: bringToTop, sendToBack: sendToBack);
      pieces.addAll(pg.splitImage());
    }
    return pieces;
  }
}

class PiecesGenerator {
  final ppMap = <RC, PiecePath>{};
  int _nextEdgeKey = 1;
  final Image image;
  final Function bringToTop;
  final Function sendToBack;
  PiecesGenerator({
    required this.image,
    required this.bringToTop,
    required this.sendToBack,
  });

  Edge _getEast(PathBuilder pb) {
    return pb.generateEast(ppMap[RC(row: pb.row - 1, col: pb.col)]);
  }

  Edge _getSouth(PathBuilder pb) {
    return pb.generateSouth();
  }

  Edge _getWest(PathBuilder pb) {
    return pb.generateWest();
  }

  Edge _getNorth(PathBuilder pb) {
    return pb.generateNorth(ppMap[RC(row: pb.row, col: pb.col - 1)]);
  }

  PiecePath _generatePiece(PathBuilder pb) {
    final e = _getEast(pb);
    final s = _getSouth(pb);
    final w = _getWest(pb);
    final n = _getNorth(pb);

    final pp = PiecePath(
        offsetX: pb.offsetX, offsetY: pb.offsetY, e: e, s: s, w: w, n: n);
    // e: _getEast(pb),
    // s: _getSouth(pb),
    // w: _getWest(pb),
    // n: _getNorth(pb));
    ppMap[RC(row: pb.row, col: pb.col)] = pp;

    print(
        'pp${pb.row}${pb.col} all:   m ${pb.offsetX} ${pb.offsetY} ${e.edge} ${s.edge} ${w.edge} ${n.edge}');
    print(
        'pp${pb.row}${pb.col} east:  m ${pb.offsetX} ${pb.offsetY} ${e.edge}       m ${pb.offsetX} ${pb.offsetY} ${e.mate}       m ${pb.offsetX} ${pb.offsetY} ${e.mateFlipped}');
    print(
        'pp${pb.row}${pb.col} south: m ${pb.offsetX} ${pb.offsetY} ${s.edge}       m ${pb.offsetX} ${pb.offsetY} ${s.mate}       m ${pb.offsetX} ${pb.offsetY} ${s.mateFlipped}');
    print(
        'pp${pb.row}${pb.col} west:  m ${pb.offsetX} ${pb.offsetY} ${w.edge}       m ${pb.offsetX} ${pb.offsetY} ${w.mate}       m ${pb.offsetX} ${pb.offsetY} ${w.mateFlipped}');
    print(
        'pp${pb.row}${pb.col} north: m ${pb.offsetX} ${pb.offsetY} ${n.edge}       m ${pb.offsetX} ${pb.offsetY} ${n.mate}       m ${pb.offsetX} ${pb.offsetY} ${n.mateFlipped}');
    print('pp${pb.row}${pb.col}');
    return pp;
  }

  List<PuzzlePiece> splitImage() {
    final pieces = <PuzzlePiece>[];
    for (int x = 0; x < maxRC.row; x++) {
      for (int y = 0; y < maxRC.col; y++) {
        if (x == 1) {
          print('');
        }
        final pb = PathBuilder(x, y);
        final piecePath = _generatePiece(pb);
        final piece = PuzzlePiece(
            piecePath: piecePath,
            playSize: playSize,
            key: GlobalKey(),
            image: image,
            imageSize: imageSize,
            row: x,
            col: y,
            maxRow: maxRC.row,
            maxCol: maxRC.col,
            bringToTop: bringToTop,
            sendToBack: sendToBack);
        pieces.add(piece);
        if (kDebugMode) {
          print('rc$x$y piecePath: ${piecePath.toString()}');

          print(
              'KEYS (edge ($x, $y): e:(${piecePath.e.key},  s:(${piecePath.s.key},  w:(${piecePath.w.key},  n:(${piecePath.n.key})');
        }
      }
    }
    return pieces;
  }
}
