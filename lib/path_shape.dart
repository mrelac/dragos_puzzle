// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

/// Describes the path direction in directional terms for [PieceShapes].
enum Dir {
  e, // east
  s, // south
  w, // west
  n // north
}

/// Encapsulates a single svg [String] puzzle piece side shape as an svg String.
///
///  (bumps and cuts) and
/// its inverse (mate) for the given [Dir].
///
// TODO - Generate the key upon adding. You'll need the offsets and widths too.
class PathShape {
  final int key;
  final Dir dir;
  final String path;
  // final String mate;
  PathShape({
    required this.key,  // Generate this instead of requiring it.
    required this.dir,
    required this.path,
    // required this.mate,
  });

  // Path getPath(int key) {
  //   final pathString = _shapes[key];
  //   return parseSvgPathData(pathString);
  // }

  static Path _toPath(String pathString) {
    return parseSvgPathData(pathString);
  }
}

// TODO - Generate the key upon adding.
class PieceShape {
  final int key;
  final PathShape e;
  final PathShape s;
  final PathShape w;
  final PathShape n;
  PieceShape({
    required this.key,  // Generate this instead of requiring it.
    required this.e,
    required this.s,
    required this.w,
    required this.n,
  });
}

class PieceShapes {
  static final _shapes = <int, PieceShape>{};
  static PieceShape getPieceShape(int key) => _shapes[key]!;
  static void add(PieceShape pieceShape) => _shapes[pieceShape.key] = pieceShape;

  PathShape getRandomShape(
    Dir dir,
  ) {
    // load all shapes for [dir] into an array with sequential indexes from 0 or 1.
    // use rnd(max) to return one.
    throw Exception('Implement me!');
  }

  /// Create a [path] from the given parameters to create and add a path to the
  /// shapes store.
  void loadShapes(
      Dir dir, Size size, int row, int col, int maxRow, int maxCol) {}
}
