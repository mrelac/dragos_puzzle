// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:dragos_puzzle/main.dart';
import 'package:dragos_puzzle/rc.dart';
import 'package:flutter/material.dart';

import 'piece_path.dart';

class PuzzlePiece extends StatefulWidget {
  final int id;
  final Image image;
  final Size imageSize;
  final RC home;
  final PiecePath piecePath;
  final Function bringToTop;
  final Function sendToBack;

  const PuzzlePiece({
    super.key,
    this.id = -1,
    required this.image,
    required this.imageSize,
    required this.home,
    required this.piecePath,
    required this.bringToTop,
    required this.sendToBack,
  });

  @override
  PuzzlePieceState createState() {
    return PuzzlePieceState();
  }
}

class PuzzlePieceState extends State<PuzzlePiece> {
  double? top;
  double? left;
  bool isMovable = true;
  final bool isNewPuzzleSetup = true;
  late final double imageWidth;
  late final double imageHeight;
  late final double pieceWidth;
  late final double pieceHeight;

  @override
  void initState() {
    super.initState();
    imageWidth = imageSize.width;
    imageHeight = imageSize.height;
    pieceWidth = imageWidth / maxRC.col;
    pieceHeight = imageHeight / maxRC.row;
    if (top == null) {
      top = Random().nextInt((imageHeight - pieceHeight).ceil()).toDouble();
      top = top! - widget.home.row * pieceHeight;
    }
    if (left == null) {
      left = Random().nextInt((imageWidth - pieceWidth).ceil()).toDouble();
      left = left! - widget.home.col * pieceWidth;
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
          clipper: PuzzlePieceClipper(widget.piecePath, widget.home, maxRC),
          child: CustomPaint(
              foregroundPainter: PuzzlePiecePainter(
                widget.piecePath,
                widget.home,
                maxRC,
              ),
              child: widget.image),
        ),
      ),
    );
  }
}

// Clips the image to the puzzle piece path
class PuzzlePieceClipper extends CustomClipper<Path> {
  final PiecePath piecePath;
  final RC home;
  final RC maxRC;

  PuzzlePieceClipper(this.piecePath, this.home, this.maxRC);

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
  final RC home;
  final RC maxRC;

  final PiecePath piecePath;

  PuzzlePiecePainter(this.piecePath, this.home, this.maxRC);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0x80FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(getPiecePath(piecePath), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

Path getPiecePath(PiecePath piecePath) => piecePath.path;
