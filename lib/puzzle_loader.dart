// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dragos_puzzle/main.dart';
import 'package:dragos_puzzle/piece_path.dart';
import 'package:dragos_puzzle/puzzle_piece.dart';
import 'package:dragos_puzzle/styles/path_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const isNewPuzzle = true;

class PuzzleLoader {
  int _nextEdgeKey = 1;

  /// Returns all puzzle pieces from storage.
  List<PuzzlePiece> getPieces() {
    final pieces = <PuzzlePiece>[];
    if (isNewPuzzle) {
      pieces.addAll(_splitImage());
    }
    return pieces;
  }

  PiecePath _generatePiece(int row, int col) {
    final pb = PathBuilder(row, col);
    return PiecePath(
        offsetX: pb.offsetX,
        offsetY: pb.offsetY,
        e: pb.easts[0].edge.copyWith(key: _nextEdgeKey++),
        s: pb.souths[0].edge.copyWith(key: _nextEdgeKey++),
        w: pb.wests[0].edge.copyWith(key: _nextEdgeKey++),
        n: pb.norths[0].edge.copyWith(key: _nextEdgeKey++));
  }

  List<PuzzlePiece> _splitImage() {
    final pieces = <PuzzlePiece>[];

    for (int x = 0; x < maxRC.row; x++) {
      for (int y = 0; y < maxRC.col; y++) {
        final piecePath = _generatePiece(x, y);
        final piece = PuzzlePiece(
            pieces: pieces,
            piecePath: piecePath,
            playSize: playSize,
            key: GlobalKey(),
            image: image,
            imageSize: imageSize,
            row: x,
            col: y,
            maxRow: maxRC.row,
            maxCol: maxRC.col);

        pieces.add(piece);
        if (kDebugMode) {
          print('rc$x$y piecePath edges: ${piecePath.edges}');

          print(
              'KEYS (edge ($x, $y): e:(${piecePath.e.key},  s:(${piecePath.s.key},  w:(${piecePath.w.key},  n:(${piecePath.n.key})');
        }
      }
    }
    return pieces;
  }
}
