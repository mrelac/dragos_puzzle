// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';

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

class PuzzlePieceState extends State<PuzzlePiece> {
  double? top;
  double? left;
  bool isMovable = true;

  @override
  Widget build(BuildContext context) {
    final playSize = Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
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
    print('XXXXXX: getClip($row, $col): ${path.computeMetrics().toString()}');

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// this class is used to draw a border around the clipped image
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
      ..strokeWidth = 1.0;

    canvas.drawPath(getPiecePath(size, row, col, maxRow, maxCol), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// this is the path used to clip the image and, then, to draw a border around it; here we actually draw the puzzle piece
Path getPiecePath(Size size, int row, int col, int maxRow, int maxCol) {
  final width = size.width / maxCol;
  final height = size.height / maxRow;
  final offsetX = col * width;
  final offsetY = row * height;
  final bumpSize = height / 4;

  print(
      'YYYYY: getPiecePath(): width = $width. height = $height. offsetX = $offsetX. offsetY = $offsetY. bumpSize = $bumpSize');
  '''
TABLET:
  PORTRAIT: Halstatter-See.jpg
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 0.0. offsetY = 0.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 0.0. offsetY = 0.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 210.0. offsetY = 0.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 210.0. offsetY = 0.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 420.0. offsetY = 0.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 420.0. offsetY = 0.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 0.0. offsetY = 280.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 0.0. offsetY = 280.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 210.0. offsetY = 280.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 210.0. offsetY = 280.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 420.0. offsetY = 280.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 420.0. offsetY = 280.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 0.0. offsetY = 560.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 0.0. offsetY = 560.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 210.0. offsetY = 560.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 210.0. offsetY = 560.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 420.0. offsetY = 560.0. bumpSize = 70.0
    I/flutter ( 8350): YYYYY: getPiecePath(): width = 210.0. height = 280.0. offsetX = 420.0. offsetY = 560.0. bumpSize = 70.0

  LANDSCAPE: dow-farm-1.jpg
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 0.0. offsetY = 0.0. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 0.0. offsetY = 0.0. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 381.3793103448276. offsetY = 0.0. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 381.3793103448276. offsetY = 0.0. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 762.7586206896552. offsetY = 0.0. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 762.7586206896552. offsetY = 0.0. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 0.0. offsetY = 286.0344827586207. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 0.0. offsetY = 286.0344827586207. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 381.3793103448276. offsetY = 286.0344827586207. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 381.3793103448276. offsetY = 286.0344827586207. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 762.7586206896552. offsetY = 286.0344827586207. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 762.7586206896552. offsetY = 286.0344827586207. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 0.0. offsetY = 572.0689655172414. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 0.0. offsetY = 572.0689655172414. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 381.3793103448276. offsetY = 572.0689655172414. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 381.3793103448276. offsetY = 572.0689655172414. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 762.7586206896552. offsetY = 572.0689655172414. bumpSize = 71.50862068965517
    width = 381.3793103448276. height = 286.0344827586207. offsetX = 762.7586206896552. offsetY = 572.0689655172414. bumpSize = 71.50862068965517
''';

  var path = Path();
  path.moveTo(offsetX, offsetY);

  if (row == 0) {
    // top side piece
    path.lineTo(offsetX + width, offsetY);
  } else {
    // top bump
    path.lineTo(offsetX + width / 3, offsetY);
    path.cubicTo(
        offsetX + width / 6,
        offsetY - bumpSize,
        offsetX + width / 6 * 5,
        offsetY - bumpSize,
        offsetX + width / 3 * 2,
        offsetY);
    path.lineTo(offsetX + width, offsetY);
  }

  if (col == maxCol - 1) {
    // right side piece
    path.lineTo(offsetX + width, offsetY + height);
  } else {
    // right bump
    path.lineTo(offsetX + width, offsetY + height / 3);
    path.cubicTo(
        offsetX + width - bumpSize,
        offsetY + height / 6,
        offsetX + width - bumpSize,
        offsetY + height / 6 * 5,
        offsetX + width,
        offsetY + height / 3 * 2);
    path.lineTo(offsetX + width, offsetY + height);
  }

  if (row == maxRow - 1) {
    // bottom side piece
    path.lineTo(offsetX, offsetY + height);
  } else {
    // bottom bump
    path.lineTo(offsetX + width / 3 * 2, offsetY + height);
    path.cubicTo(
        offsetX + width / 6 * 5,
        offsetY + height - bumpSize,
        offsetX + width / 6,
        offsetY + height - bumpSize,
        offsetX + width / 3,
        offsetY + height);
    path.lineTo(offsetX, offsetY + height);
  }

  if (col == 0) {
    // left side piece
    path.close();
  } else {
    // left bump
    path.lineTo(offsetX, offsetY + height / 3 * 2);
    path.cubicTo(
        offsetX - bumpSize,
        offsetY + height / 6 * 5,
        offsetX - bumpSize,
        offsetY + height / 6,
        offsetX,
        offsetY + height / 3);
    path.close();
  }

  return path;
}
