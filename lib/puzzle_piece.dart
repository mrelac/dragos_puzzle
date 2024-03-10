// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:dragos_puzzle/styles/path_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

class PuzzlePiece extends StatefulWidget {
  final Image image;
  final Size imageSize;
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;
  final Function bringToTop;
  final Function sendToBack;

  const PuzzlePiece({
    super.key,
    required this.image,
    required this.imageSize,
    required this.row,
    required this.col,
    required this.maxRow,
    required this.maxCol,
    required this.bringToTop,
    required this.sendToBack,
  });

  @override
  PuzzlePieceState createState() {
    return PuzzlePieceState();
  }
}

late Size playSize;

class PuzzlePieceState extends State<PuzzlePiece> {
  double? top;
  double? left;
  bool isMovable = true;

  @override
  Widget build(BuildContext context) {
    playSize = MediaQuery.of(context).size;
    final fitSize =
        fitImage(playSize, playSize.aspectRatio, widget.imageSize.aspectRatio);

    final imageWidth = fitSize.width;
    final imageHeight = fitSize.height;
    final pieceWidth = imageWidth / widget.maxCol;
    final pieceHeight = imageHeight / widget.maxRow;
    if (top == null) {
      top = Random().nextInt((imageHeight - pieceHeight).ceil()).toDouble();
      top = top! - widget.row * pieceHeight;
    }
    if (left == null) {
      left = Random().nextInt((imageWidth - pieceWidth).ceil()).toDouble();
      left = left! - widget.col * pieceWidth;
    }

    return Positioned(
      top: top,
      left: left,
      width: imageWidth,
      child: GestureDetector(
        onTap: () {
          if (isMovable) {
            widget.bringToTop(widget);
          }
        },
        onPanStart: (_) {
          if (isMovable) {
            widget.bringToTop(widget);
          }
        },
        onPanUpdate: (dragUpdateDetails) {
          if (isMovable) {
            setState(() {
              top = top! + dragUpdateDetails.delta.dy;
              left = left! + dragUpdateDetails.delta.dx;

              if (-20 < top! && top! < 20 && -20 < left! && left! < 20) {
                top = 0;
                left = 0;
                isMovable = false;
                widget.sendToBack(widget);
              }
            });
          }
        },
        child: ClipPath(
          clipper: PuzzlePieceClipper(
              widget.row, widget.col, widget.maxRow, widget.maxCol),
          child: CustomPaint(
              foregroundPainter: PuzzlePiecePainter(
                  widget.row, widget.col, widget.maxRow, widget.maxCol),
              child: widget.image),
        ),
      ),
    );
  }

  /// Returns a [Size] optimised for the device based on the device aspect ratio
  /// and the full image aspect ratio.
  Size fitImage(Size playsize, double playsizeAr, double imageAr) =>
      playsizeAr > 1
          ? Size(playsize.height * imageAr, playsize.height)
          : Size(playsize.width, imageAr * playsize.width);
}

// this class is used to clip the image to the puzzle piece path
class PuzzlePieceClipper extends CustomClipper<Path> {
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  PuzzlePieceClipper(this.row, this.col, this.maxRow, this.maxCol);

  @override
  Path getClip(Size size) {
    final path = getPiecePath(size, row, col, maxRow, maxCol);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// This class is used to draw a border around the clipped image.
///
/// The overriden [paint] method's [size] parameter describes the entire
/// image (fitted to device), not a single piece size.
class PuzzlePiecePainter extends CustomPainter {
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  PuzzlePiecePainter(this.row, this.col, this.maxRow, this.maxCol);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0x80FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    canvas.drawPath(getPiecePath(size, row, col, maxRow, maxCol), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

Path getPiecePath(Size imgSize, int row, int col, int maxRow, int maxCol) {
  final PathBuilder pb = PathBuilder(
      size: imgSize, row: row, col: col, maxRow: maxRow, maxCol: maxCol);
  String m = pb.createM();
  String e = pb.easts[0];
  String s = pb.souths[1];
  String w = pb.wests[1];
  String n = pb.norths[0];

  e = pb.easts[1];
  n = pb.norths[1];
  final pathString = '$m $e $s $w $n';

  if (kDebugMode) {
    print('AAA rc$row$col  east bump path: $m ${pb.easts[0]}');
    print('AAA rc$row$col  east cut path:  $m ${pb.easts[1]}');

    print('AAA rc$row$col  south bump path: $m ${pb.souths[0]}');
    print('AAA rc$row$col  south cut path:  $m ${pb.souths[1]}');

    print('AAA rc$row$col  west bump path: $m ${pb.wests[0]}');
    print('AAA rc$row$col  west cut path:  $m ${pb.wests[1]}');

    print('AAA rc$row$col  north bump path: $m ${pb.norths[0]}');
    print('AAA rc$row$col  north cut path:  $m ${pb.norths[1]}');

    print('AAA rc$row$col play size: $playSize');
    print('AAA rc$row$col image size: $imgSize');
    print(
        'AAA rc$row$col imgSize: $imgSize. row: $row. col: $col. maxRow: $maxRow. maxCol: $maxCol');
    print('AAA rc$row$col pathString: $pathString');
  }
  return toPath(pathString);
}

Path toPath(String pathString) {
  return parseSvgPathData(pathString);
}
