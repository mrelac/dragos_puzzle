// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:path_drawing/path_drawing.dart';

// import 'package:dragos_puzzle/path_shape.dart';

// class EdgeStyles {
//   final ePaths = <Epath1>[];
//   final sPaths = <Spath1>[];
//   final wPaths = <Wpath1>[];
//   final nPaths = <Npath1>[];

//   void doit() {
//     ePaths.add(epath1);
//   }

//   void generatePaths(Size size, int row, int col, int maxRow, int maxCol) {
//     ePaths.add(Epath1(
//         dir: Dir.e,
//         size: size,
//         row: row,
//         col: col,
//         maxRow: maxRow,
//         maxCol: maxCol));
//   }
// }

// class EdgesGenerator {
//   final Dir dir;
//   final Size size;
//   final int row;
//   final int col;
//   final int maxRow;
//   final int maxCol;
//   GeneratePath genPath;
//   GeneratePath genPathMate;

//   final _ePaths = <Edgepath>[];
//   final _sPaths = <Edgepath>[];
//   final _wPaths = <Edgepath>[];
//   final _nPaths = <Edgepath>[];

//   EdgesGenerator({
//     required this.dir,
//     required this.size,
//     required this.row,
//     required this.col,
//     required this.maxRow,
//     required this.maxCol,
//     required this.genPath,
//     required this.genPathMate,
//   }) {

//   }
// }

// Edgepath e1 = Edgepath(dir: dir, size: size, row: row, col: col, maxRow: maxRow, maxCol: maxCol, genPath: genPath, genPathMate: genPathMate)

// class EdgeGenerator {
//   final Dir dir;
//   final Size size;
//   final int row;
//   final int col;
//   final int maxRow;
//   final int maxCol;
//   GeneratePath genPath;
//   GeneratePath genPathMate;
//   EdgeGenerator({
//     required this.dir,
//     required this.size,
//     required this.row,
//     required this.col,
//     required this.maxRow,
//     required this.maxCol,
//     required this.genPath,
//     required this.genPathMate,
//   });

//   EdgePath genPath() {
//     return EdgePath(dir: dir, size: size, row: row, col: col, maxRow maxRow, maxCol: maxCol)
//   }
// }

// class Style1 {
//   final Epath1 e;
//   final Spath1 s;
//   final Wpath1 w;
//   final Npath1 n;
//   Style1({
//     required this.e,
//     required this.s,
//     required this.w,
//     required this.n,
//   });
// }

// class Epath1 extends Edgepath {
//   Epath1({required super.dir, required super.size, required super.row, required super.col, required super.maxRow, required super.maxCol, required super.genPath, required super.genPathMate});
//   // Epath1(
//   //     {required super.dir,
//   //     required super.size,
//   //     required super.row,
//   //     required super.col,
//   //     required super.maxRow,
//   //     required super.maxCol});

//   // @override
//   // String gen(Size size, int row, int col, int maxRow, int maxCol) {
//   //   // TODO: implement gen
//   //   throw UnimplementedError();
//   // }

//   // @override
//   // String genMate(Size size, int row, int col, int maxRow, int maxCol) {
//   //   // TODO: implement genMate
//   //   throw UnimplementedError();
//   // }
// }

// class Spath1 extends Edgepath {
//   Spath1(
//       {required super.dir,
//       required super.size,
//       required super.row,
//       required super.col,
//       required super.maxRow,
//       required super.maxCol});

//   @override
//   String gen(Size size, int row, int col, int maxRow, int maxCol) {
//     // TODO: implement gen
//     throw UnimplementedError();
//   }

//   @override
//   String genMate(Size size, int row, int col, int maxRow, int maxCol) {
//     // TODO: implement genMate
//     throw UnimplementedError();
//   }
// }

// class Wpath1 extends Edgepath {
//   Wpath1(
//       {required super.dir,
//       required super.size,
//       required super.row,
//       required super.col,
//       required super.maxRow,
//       required super.maxCol});

//   @override
//   String gen(Size size, int row, int col, int maxRow, int maxCol) {
//     // TODO: implement gen
//     throw UnimplementedError();
//   }

//   @override
//   String genMate(Size size, int row, int col, int maxRow, int maxCol) {
//     // TODO: implement genMate
//     throw UnimplementedError();
//   }
// }

// class Npath1 extends Edgepath {
//   Npath1(
//       {required super.dir,
//       required super.size,
//       required super.row,
//       required super.col,
//       required super.maxRow,
//       required super.maxCol});

//   @override
//   String gen(Size size, int row, int col, int maxRow, int maxCol) {
//     // TODO: implement gen
//     throw UnimplementedError();
//   }

//   @override
//   String genMate(Size size, int row, int col, int maxRow, int maxCol) {
//     // TODO: implement genMate
//     throw UnimplementedError();
//   }
// }
