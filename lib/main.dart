// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api
import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dragos_puzzle/puzzle_piece.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Puzzle'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({
    super.key,
    required this.title,
  });
  final int rows = 3;
  final int cols = 3;

  // MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  List<Widget> pieces = [];

  Future getImage(ImageSource source) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      // initialDirectory: dirs.zipStorage,
      allowMultiple: false,
      // allowedExtensions: ['png', 'jpg'],
      type: FileType.image,
    );

    if (result == null) return;

    setState(() {
      _image = File(result.paths.first!);
      pieces.clear();
    });
    splitImage(Image.file(File(result.paths.first!)));

    // var image = await (ImagePicker()).pickImage(source: source);

    // if (image != null) {
    //   setState(() {
    //     _image = File(image.path);
    //     pieces.clear();
    //   });

      // splitImage(Image.file(File(image.path)));
    // }
  }

  // we need to find out the image size, to be used in the PuzzlePiece widget
  // Future<Size> getImageSize(Image image) async {
  //   final Completer<Size> completer = Completer<Size>();

  //   image.image.resolve(const ImageConfiguration()).addListener(
  //         (ImageInfo info, bool _) {
  //       completer.complete(Size(
  //         info.image.width.toDouble(),
  //         info.image.height.toDouble(),
  //       ));
  //     },
  //   );

  //   final Size imageSize = await completer.future;

  //   return imageSize;
  // }

  /// Returns [image] size.
  Future<Size> getImageSize(Image image) {
    Completer<Size> completer = Completer();
    image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
      Size size = Size(
          imageInfo.image.width.toDouble(), imageInfo.image.height.toDouble());
      completer.complete(size);
    }));

    return completer.future;
  }

  // here we will split the image into small pieces using the rows and columns defined above; each piece will be added to a stack
  void splitImage(Image image) async {
    Size imageSize = await getImageSize(image);

    for (int x = 0; x < widget.rows; x++) {
      for (int y = 0; y < widget.cols; y++) {
        print('XXXXX: Adding piece ($x, $y. imageSize = $imageSize');
        setState(() {
          pieces.add(PuzzlePiece(
              key: GlobalKey(),
              image: image,
              imageSize: imageSize,
              row: x,
              col: y,
              maxRow: widget.rows,
              maxCol: widget.cols,
              bringToTop: bringToTop,
              sendToBack: sendToBack));
        });
      }
    }
  }

  // when the pan of a piece starts, we need to bring it to the front of the stack
  void bringToTop(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.add(widget);
    });
  }

  // when a piece reaches its final position, it will be sent to the back of the stack to not get in the way of other, still movable, pieces
  void sendToBack(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.insert(0, widget);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
            child: _image == null
                ? const Text('No image selected.')
                : Stack(children: pieces)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera),
                        title: const Text('Camera'),
                        onTap: () {
                          getImage(ImageSource.camera);
                          // this is how you dismiss the modal bottom sheet after making a choice
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.image),
                        title: const Text('Gallery'),
                        onTap: () {
                          getImage(ImageSource.gallery);
                          // dismiss the modal sheet
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              });
        },
        tooltip: 'New Image',
        child: const Icon(Icons.add),
      ),
    );
  }
}
