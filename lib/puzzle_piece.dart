// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:dragos_puzzle/main.dart';
import 'package:dragos_puzzle/path_shape.dart';
import 'package:dragos_puzzle/styles/path_builder.dart';
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
  String e = pb.easts[0];       // pb.createEbump1();
  String s = pb.souths[1];         // pb.createScut1();
  String w = pb.wests[1];         // pb.createWcut1();
  String n = pb.norths[0];         // pb.createNbump1();
  final pathString = '$m $e $s $w $n';

  print('AAA rc$row$col  east bump path: $m ${pb.easts[0]}');
  // print('AAA rc$row$col  east bump mate: $m ${pb.easts[0]}');
  print('AAA rc$row$col  east cut path:  $m ${pb.easts[1]}');
  // print('AAA rc$row$col  east cut mate:  $m ${pb.easts[1]}');

  print('AAA rc$row$col  south bump path: $m ${pb.souths[0]}');
  // print('AAA rc$row$col  south bump mate: $m ${pb.souths[0]}');
  print('AAA rc$row$col  south cut path:  $m ${pb.souths[1]}');
  // print('AAA rc$row$col  south cut mate:  $m ${pb.souths[1]}');
  
  print('AAA rc$row$col  west bump path: $m ${pb.wests[0]}');
  // print('AAA rc$row$col  west bump mate: $m ${pb.wests[0]}');
  print('AAA rc$row$col  west cut path:  $m ${pb.wests[1]}');
  // print('AAA rc$row$col  west cut mate:  $m ${pb.wests[1]}');

  print('AAA rc$row$col  north bump path: $m ${pb.norths[0]}');
  // print('AAA rc$row$col  north bump mate: $m ${pb.norths[0]}');
  print('AAA rc$row$col  north cut path:  $m ${pb.norths[1]}');
  // print('AAA rc$row$col  north cut mate:  $m ${pb.norths[1]}');

  print('AAA rc$row$col play size: $playSize');
  print('AAA rc$row$col image size: $imgSize');
  print(
      'AAA rc$row$col imgSize: $imgSize. row: $row. col: $col. maxRow: $maxRow. maxCol: $maxCol');
  print('AAA rc$row$col pathString: $pathString');
  // print('YYYYY:');
  return toPath(pathString);
}

Path toPath(String pathString) {
  return parseSvgPathData(pathString);
}

// this is the path used to clip the image and, then, to draw a border around it; here we actually draw the puzzle piece
Path getPiecePath2(Size size, int row, int col, int maxRow, int maxCol) {
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

  final sb = StringBuffer();

  String m = '';
  String e = '';
  String s = '';
  String w = '';
  String n = '';

  // var path = Path();
  // path.moveTo(offsetX, offsetY);
  sb.write('M $offsetX $offsetY');
  m = sb.toString();

  // if (row == 0) {
  //   // top side piece
  //   path.lineTo(offsetX + width, offsetY);
  // } else {
  //   // top bump
  //   path.lineTo(offsetX + width / 3, offsetY);
  //   path.cubicTo(
  //       offsetX + width / 6,
  //       offsetY - bumpSize,
  //       offsetX + width / 6 * 5,
  //       offsetY - bumpSize,
  //       offsetX + width / 3 * 2,
  //       offsetY);
  //   path.lineTo(offsetX + width, offsetY);
  // }
  // east bump
  sb.clear();
  if (row == 0) {
    sb.write('L ${offsetX + width} $offsetY');
  } else {
    sb
      ..write('L ${offsetX + width / 3} $offsetY')
      ..write(' C ${offsetX + width / 6}')
      ..write(' ${offsetY - bumpSize}')
      ..write(' ${offsetX + width / 6 * 5}')
      ..write(' ${offsetY - bumpSize}')
      ..write(' ${offsetX + width / 3 * 2}')
      ..write(' $offsetY')
      ..write(' L ${offsetX + width} $offsetY');
  }
  e = sb.toString();

  // if (col == maxCol - 1) {
  //   // right side piece
  //   path.lineTo(offsetX + width, offsetY + height);
  // } else {
  //   path.lineTo(offsetX + width, offsetY + height / 3);
  //   // right bump
  //   path.cubicTo(
  //       offsetX + width - bumpSize,
  //       offsetY + height / 6,
  //       offsetX + width - bumpSize,
  //       offsetY + height / 6 * 5,
  //       offsetX + width,
  //       offsetY + height / 3 * 2);
  //   path.lineTo(offsetX + width, offsetY + height);
  // }
  // south cut
  sb.clear();
  if (col == maxCol - 1) {
    // right side piece
    sb.write('L ${offsetX + width} ${offsetY + height}');
  } else {
    sb
      ..write('L ${offsetX + width} ${offsetY + height / 3}')
      ..write(' C ${offsetX + width - bumpSize}')
      ..write(' ${offsetY + height / 6}')
      ..write(' ${offsetX + width - bumpSize}')
      ..write(' ${offsetY + height / 6 * 5}')
      ..write(' ${offsetX + width}')
      ..write(' ${offsetY + height / 3 * 2}')
      ..write(' L ${offsetX + width} ${offsetY + height}');
  }
  s = sb.toString();

  // if (row == maxRow - 1) {
  //   // bottom side piece
  //   path.lineTo(offsetX, offsetY + height);
  // } else {
  //   // bottom bump
  //   path.lineTo(offsetX + width / 3 * 2, offsetY + height);
  //   path.cubicTo(
  //       offsetX + width / 6 * 5,
  //       offsetY + height - bumpSize,
  //       offsetX + width / 6,
  //       offsetY + height - bumpSize,
  //       offsetX + width / 3,
  //       offsetY + height);
  //   path.lineTo(offsetX, offsetY + height);
  // }
  // west cut
  sb.clear();
  if (row == maxRow - 1) {
    // bottom side piece
    sb.write('L $offsetX ${offsetY + height}');
  } else {
    sb
      ..write('L ${offsetX + width / 3 * 2} ${offsetY + height}')
      ..write(' C ${offsetX + width / 6 * 5}')
      ..write(' ${offsetY + height - bumpSize}')
      ..write(' ${offsetX + width / 6}')
      ..write(' ${offsetY + height - bumpSize}')
      ..write(' ${offsetX + width / 3}')
      ..write(' ${offsetY + height}')
      ..write(' L $offsetX ${offsetY + height}');
  }
  w = sb.toString();

  // if (col == 0) {
  //   // left side piece
  //   path.close();
  // } else {
  //   // left bump
  //   path.lineTo(offsetX, offsetY + height / 3 * 2);
  //   path.cubicTo(
  //       offsetX - bumpSize,
  //       offsetY + height / 6 * 5,
  //       offsetX - bumpSize,
  //       offsetY + height / 6,
  //       offsetX,
  //       offsetY + height / 3);
  //   path.close();
  // }
  // north bump
  sb.clear();
  if (col == 0) {
    sb.write('Z');
  } else {
    sb
      ..write('L $offsetX ${offsetY + height / 3 * 2}')
      ..write(' C ${offsetX - bumpSize}')
      ..write(' ${offsetY + height / 6 * 5}')
      ..write(' ${offsetX - bumpSize}')
      ..write(' ${offsetY + height / 6}')
      ..write(' $offsetX')
      ..write(' ${offsetY + height / 3}')
      ..write(' Z');
  }
  n = sb.toString();
  final pathString = '$m $e $s $w $n';
  print('YYYYY: pathString: $pathString');
  print('YYYYY:');
  return toPath(pathString);

  // return path;
}
