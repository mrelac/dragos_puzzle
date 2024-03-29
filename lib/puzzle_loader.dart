// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dragos_puzzle/main.dart';
import 'package:dragos_puzzle/piece_path.dart';
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
  final Image image;
  final Function bringToTop;
  final Function sendToBack;
  PiecesGenerator({
    required this.image,
    required this.bringToTop,
    required this.sendToBack,
  });

  Edge _getEast(PathBuilder pb) {
    return pb.generateEast(ppMap[RC(pb.home.row - 1, pb.home.col)]);
  }

  Edge _getSouth(PathBuilder pb) {
    return pb.generateSouth();
  }

  Edge _getWest(PathBuilder pb) {
    return pb.generateWest();
  }

  Edge _getNorth(PathBuilder pb) {
    return pb.generateNorth(ppMap[RC(pb.home.row, pb.home.col - 1)]);
  }

  PiecePath _generatePiece(PathBuilder pb) {
    final e = _getEast(pb);
    final s = _getSouth(pb);
    final w = _getWest(pb);
    final n = _getNorth(pb);

    final pp =
        PiecePath(homeX: pb.homeX, homeY: pb.homeY, e: e, s: s, w: w, n: n);
    ppMap[RC(pb.home.row, pb.home.col)] = pp;
    if (kDebugMode) {
      print(
          'pp${pb.home.row}${pb.home.col} all:   m ${pb.homeX} ${pb.homeY} ${e.edge} ${s.edge} ${w.edge} ${n.edge}');
      print(
          'pp${pb.home.row}${pb.home.col} east:  m ${pb.homeX} ${pb.homeY} ${e.edge}       m ${pb.homeX} ${pb.homeY} ${e.mate}    key: ${e.key}');
      print(
          'pp${pb.home.row}${pb.home.col} south: m ${pb.homeX} ${pb.homeY} ${s.edge}       m ${pb.homeX} ${pb.homeY} ${s.mate}    key: ${s.key}');
      print(
          'pp${pb.home.row}${pb.home.col} west:  m ${pb.homeX} ${pb.homeY} ${w.edge}       m ${pb.homeX} ${pb.homeY} ${w.mate}    key: ${w.key}');
      print(
          'pp${pb.home.row}${pb.home.col} north: m ${pb.homeX} ${pb.homeY} ${n.edge}       m ${pb.homeX} ${pb.homeY} ${n.mate}    key: ${n.key}');
      print('pp${pb.home.row}${pb.home.col}');
    }
    return pp;
  }

  List<PuzzlePiece> splitImage() {
    nextEdgeKey = 1;
    final pieces = <PuzzlePiece>[];
    for (int x = 0; x < maxRC.row; x++) {
      for (int y = 0; y < maxRC.col; y++) {
        final pb = PathBuilder(RC(x, y));
        final piecePath = _generatePiece(pb);
        final piece = PuzzlePiece(
            piecePath: piecePath,
            key: GlobalKey(),
            image: image,
            imageSize: imageSize,
            home: RC(x, y),
            bringToTop: bringToTop,
            sendToBack: sendToBack);
        pieces.add(piece);
        if (kDebugMode) {
          print('rc$x$y piecePath: ${piecePath.toString()}');

          print(
              'rc$x$y KEYS: e: ${piecePath.e.key},  s: ${piecePath.s.key},  w: ${piecePath.w.key},  n: ${piecePath.n.key}');
        }
      }
    }
    return pieces;
  }
}
