// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:dragos_puzzle/rc.dart';
import 'package:dragos_puzzle/styles/path_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PuzzlePiece extends StatefulWidget {
  final Size playSize;
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
    required this.playSize,
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

// late Size playSize;

final piecePaths = <RC, PiecePath>{};

class PuzzlePieceState extends State<PuzzlePiece> {
  late PiecePath piecePath;
  static final piecePaths = <RC, PiecePath>{};
  double? top;
  double? left;
  bool isMovable = true;
  late Size fitSize;
  final bool isNewPuzzleSetup = true;

  late final double imageWidth;
  late final double imageHeight;
  late final double pieceWidth;
  late final double pieceHeight;

  @override
  void initState() {
    super.initState();

    if (isNewPuzzleSetup) {
      fitSize = fitImage(widget.playSize, widget.playSize.aspectRatio,
          widget.imageSize.aspectRatio);

      imageWidth = fitSize.width;
      imageHeight = fitSize.height;
      pieceWidth = imageWidth / widget.maxCol;
      pieceHeight = imageHeight / widget.maxRow;

      if (top == null) {
        top = Random().nextInt((imageHeight - pieceHeight).ceil()).toDouble();
        top = top! - widget.row * pieceHeight;
      }
      if (left == null) {
        left = Random().nextInt((imageWidth - pieceWidth).ceil()).toDouble();
        left = left! - widget.col * pieceWidth;
      }

      final PathBuilder pb = PathBuilder(
          size: fitSize,
          row: widget.row,
          col: widget.col,
          maxRow: widget.maxRow,
          maxCol: widget.maxCol);

      final row = widget.row;
      final col = widget.col;
      final imgSize = widget.imageSize;
      final maxRow = widget.maxRow;
      final maxCol = widget.maxCol;
      piecePath = PiecePath(
          offsetX: pb.offsetX,
          offsetY: pb.offsetY,
          e: pb.easts[1],
          s: pb.souths[1],
          w: pb.wests[1],
          n: pb.norths[1]);
      piecePaths[RC(row: widget.row, col: widget.col)] = piecePath;

      if (kDebugMode) {
        final m = 'm ${pb.offsetX} ${pb.offsetY}';
        print('AAA rc$row$col  east bump path: $m ${pb.easts[0].path}');
        print('AAA rc$row$col  east cut path:  $m ${pb.easts[1].path}');

        print('AAA rc$row$col  south bump path: $m ${pb.souths[0].path}');
        print('AAA rc$row$col  south cut path:  $m ${pb.souths[1].path}');

        print('AAA rc$row$col  west bump path: $m ${pb.wests[0].path}');
        print('AAA rc$row$col  west cut path:  $m ${pb.wests[1].path}');

        print('AAA rc$row$col  north bump path: $m ${pb.norths[0].path}');
        print('AAA rc$row$col  north cut path:  $m ${pb.norths[1].path}');

        print('AAA rc$row$col play size: ${widget.playSize}');
        print('AAA rc$row$col image size: $imgSize');
        print(
            'AAA rc$row$col imgSize: $imgSize. row: $row. col: $col. maxRow: $maxRow. maxCol: $maxCol');
        print('AAA rc$row$col path: ${piecePath.toString()}');
        print('AAA rc$row$col piecePaths.size: ${piecePaths.length}');
        print(
            'rc11YY playSize: ${widget.playSize}, imageWidth: $imageWidth, imageHeight: $imageHeight, pieceWidth: $pieceWidth, pieceHeight: $pieceHeight');
      }
    } else {
      // TODO - Read path from storage:
    }
  }

  @override
  Widget build(BuildContext context) {
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
              piecePath, widget.row, widget.col, widget.maxRow, widget.maxCol),
          child: CustomPaint(
              foregroundPainter: PuzzlePiecePainter(piecePath, widget.row,
                  widget.col, widget.maxRow, widget.maxCol),
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

// Clips the image to the puzzle piece path
class PuzzlePieceClipper extends CustomClipper<Path> {
  final PiecePath piecePath;
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  PuzzlePieceClipper(
      this.piecePath, this.row, this.col, this.maxRow, this.maxCol);

  @override
  Path getClip(Size size) {
    final path = getPiecePath(piecePath);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// Draws a border around the clipped image.
///
/// The overriden [paint] method's [size] parameter describes the entire
/// image (fitted to device), not a single piece size.
class PuzzlePiecePainter extends CustomPainter {
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  final PiecePath piecePath;

  PuzzlePiecePainter(
      this.piecePath, this.row, this.col, this.maxRow, this.maxCol);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0x80FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;
    canvas.drawPath(getPiecePath(piecePath), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

Path getPiecePath(PiecePath piecePath) => piecePath.path;
