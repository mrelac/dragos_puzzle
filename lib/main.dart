// ignore_for_file: public_member_api_docs, sort_constructors_first, library_private_types_in_public_api
import 'dart:async';
import 'dart:io';

import 'package:dragos_puzzle/prepare_new_puzzle.dart';
import 'package:dragos_puzzle/rc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Image size itted to device
late Size imageSize;

/// Size of device
late Size playSize;

/// Number of rows and columns for selected puzzle.
final RC maxRC = RC(row: 3, col: 3);

/// Chosen puzzle image
late Image image;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    playSize = MediaQuery.of(context).size;
    return MaterialApp(
      title: 'Flutter Puzzle',
      debugShowCheckedModeBanner: false,
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

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  List<Widget> pieces = [];

  Future getImage(ImageSource source) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
    );
    if (result == null) return;

    // TODO For better readabililty, move setState to *after* imageSize computation.
    setState(() {
      _image = File(result.paths.first!);
      pieces.clear();
    });

    image = Image.file(File(result.paths.first!));
    final fullSize = await _getImageSize(image);
    imageSize = fitImage(playSize, playSize.aspectRatio, fullSize.aspectRatio);
    final loader = PuzzleLoader();
    setState(() => pieces = loader.getPieces());
  }

  /// Returns [image] size.
  Future<Size> _getImageSize(Image image) {
    Completer<Size> completer = Completer();
    image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
      Size size = Size(imageInfo.image.width.toDouble() - 60,
          imageInfo.image.height.toDouble() - 80);
      completer.complete(size);
    }));

    return completer.future;
  }

  /// Returns a [Size] optimised for the device based on the device aspect ratio
  /// and the full image aspect ratio.
  Size fitImage(Size playsize, double playsizeAr, double imageAr) =>
      playsizeAr > 1
          ? Size(playsize.height * imageAr, playsize.height)
          : Size(playsize.width, imageAr * playsize.width);

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
      body: Center(
          child: _image == null
              ? const Text('No image selected.')
              : Stack(children: pieces)),
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
