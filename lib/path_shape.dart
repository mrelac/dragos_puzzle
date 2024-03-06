// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api
import 'package:dragos_puzzle/styles/style_q.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

/// Describes the path direction in directional terms.
enum Dir {
  e, // east
  s, // south
  w, // west
  n // north
}

// TODO - Generate the key upon adding.
// abstract class Pathside2 {
//   final int _key;
//   final Dir dir;
//   final String _path;
//   String gen(Size size, int row, int col, int maxRow, int maxCol);
//   Pathside({
//     required this.key,
//     required this.dir,
//     // required this.path,
//   }) {
// _path = gen(size, row, col, maxRow, maxCol);
//   }
// }

/// Defines a directional edge [Path] string and its inverse (mate).
///
/// At creation, the [Edgepath] is assigned a key that uniquely describes that
/// edge's [Path]. [Dir] defines the [Path] direction (east, south, west, north).
/// [mate] is the [Path] drawn in the opposite direction. [path] and [mate]
/// share the same [key].
class Edgepath {
  late final int _key;
  late final String _path;
  late final String _pathMate;
  String get path => _path;
  String get pathMate => _pathMate;
  int get key => _key;
  final Dir dir;
  final Size size;
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;
  GeneratePath genPath;
  GeneratePath genPathMate;
  Edgepath({
    required this.dir,
    required this.size,
    required this.row,
    required this.col,
    required this.maxRow,
    required this.maxCol,
    required this.genPath,
    required this.genPathMate,
  }) {
    _path = genPath(size, row, col, maxRow, maxCol);
    _pathMate = genPathMate(size, row, col, maxRow, maxCol);
  }

  // String gen(Size size, int row, int col, int maxRow, int maxCol);
  // String genMate(Size size, int row, int col, int maxRow, int maxCol);
}

typedef GeneratePath = Function(
    Size size, int row, int col, int maxRow, int maxCol);

/// Defines the four edges of a single puzzle piece [path].
class Piecepath {
  final Edgepath e;
  final Edgepath s;
  final Edgepath w;
  final Edgepath n;
  Piecepath({
    required this.e,
    required this.s,
    required this.w,
    required this.n,
  });
}

class PieceShapes {
  void doit() {
    final size = Size(0, 0);
    final row = 1;
    final col = 1;
    final maxRow = 2;
    final maxCol = 2;
    // final e = Epath1(
    //     dir: Dir.e,
    //     size: size,
    //     row: row,
    //     col: col,
    //     maxRow: maxRow,
    //     maxCol: maxCol);
    // final pp = Piecepath(e: e, s: e, w: e, n: e);
    // String path = pp.e.path;
    // String mate = pp.e.pathMate;
  }
  // static final _shapes = <int, PieceShape>{};
  // static PieceShape getPieceShape(int key) => _shapes[key]!;
  // static void add(PieceShape pieceShape) =>
  //     _shapes[pieceShape.key] = pieceShape;

  // PathShape getRandomShape(
  //   Dir dir,
  // ) {
  //   // load all shapes for [dir] into an array with sequential indexes from 0 or 1.
  //   // use rnd(max) to return one.
  //   throw Exception('Implement me!');
  // }

  /// Create a [path] from the given parameters to create and add a path to the
  /// shapes store.
  void loadShapes(
      Dir dir, Size size, int row, int col, int maxRow, int maxCol) {}
}


