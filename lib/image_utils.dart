import 'dart:async';
import 'dart:io';

import 'package:dragos_puzzle/image_by_path.dart';
import 'package:dragos_puzzle/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
// import 'package:jiggy/consts.dart';
// import 'package:jiggy/main.dart';

class ImageUtils {
  /// Returns the [Uint8List] synchronously from the given [Image].
  ///
  /// Throws an Exception if the [image.image] [ImageProvider] is not of type [FileImage].
  static Uint8List getBytesFromFileImage(Image image) {
    if (image.image.runtimeType != FileImage) {
      throw Exception('Expected "FileImage" type.');
    }
    return (image as FileImage).file.readAsBytesSync();
  }

  /// Returns the [Uint8List] synchronously from the given [Image].
  ///
  /// Throws an Exception if the [image.image] [ImageProvider] is not of type [MemoryImage].
  static Uint8List getBytesFromMemoryImage(Image image) {
    if (image.image.runtimeType != MemoryImage) {
      throw Exception('Expected "MemoryImage" type.');
    }
    return (image as MemoryImage).bytes;
  }

  /// Returns [Uint8List] image bytes for any type of [Image].
  ///
  /// Supported types: [AssetImage], [FileImage], [NetworkImage], [MemoryImage].
  static Future<Uint8List> getBytesFromImage(Image image) async {
    late final Uint8List bytes;
    switch (image.image.runtimeType) {
      case AssetImage:
        {
          AssetImage ai = image.image as AssetImage;
          ByteData bd = await rootBundle.load(ai.assetName);
          final buffer = bd.buffer;
          bytes = buffer.asUint8List();
          break;
        }

      case FileImage:
        {
          FileImage fi = image.image as FileImage;
          bytes = fi.file.readAsBytesSync();
          break;
        }

      case NetworkImage:
        {
          NetworkImage ni = image.image as NetworkImage;
          bytes = (await NetworkAssetBundle(Uri.parse(ni.url)).load(ni.url))
              .buffer
              .asUint8List();
          break;
        }

      case MemoryImage:
        {
          MemoryImage mi = image.image as MemoryImage;
          bytes = mi.bytes;
          break;
        }

      default:
        throw UnsupportedError(
            'imageToBytes(): Unknown Image type ${image.image.runtimeType}');
    }

    return bytes;
  }

  /// Returns [Image] from [path], or null if no image found.
  ///
  /// Supported path types: [AssetImage], [FileImage], [NetworkImage], [MemoryImage].
  static Image getImageFromPath(String url) {
    if (url.startsWith("asset")) {
      return Image.asset(url);
    } else if (url.startsWith('http')) {
      return Image.network(url);
    } else if ((url.startsWith('file')) || (url.startsWith('/'))) {
      return Image.file(File(Uri.parse(url).toFilePath(windows: false)));
    }
    if (kDebugMode) print('Invalid image path $url');
    return Consts.defaultImage;
  }

  /// Returns [Uint8List] image bytes from [path].
  ///
  /// Supported path types: [AssetImage], [FileImage], [NetworkImage], [MemoryImage].
  static Future<Uint8List> getBytesFromPath(String path) async {
    return await getBytesFromImage(getImageFromPath(path));
  }

  /// Resizes image in [inPath] to 64-pixel file in [outPath].
  ///
  /// [inPath] is the path and file to be resized. Supported path types:
  ///     [AssetImage], [FileImage], [NetworkImage], [MemoryImage].
  /// [outPath] is the path the resized image is written to (without the filename)
  ///
  /// Example:
  /// ```dart
  /// final inPath = 'assets/artwork/defaultStation.png';
  /// final outPath = '/data/data/com.mikes.audiostreamplayer/app_flutter/playlists/0/KCSM-1696426529589-artwork.jpg'
  /// await imageToThumb(inPath, outPath);
  /// ```
  static Future<String> imageToThumb(String inPath, String outPath) async {
    outPath = '${outPath}_${inPath.split("/").last}';
    final bytes = await getBytesFromPath(inPath);
    final cmd = img.Command()
      ..decodeImage(bytes)
      // Resize the image to a width of 64 pixels and a height that maintains the aspect ratio of the original.
      ..copyResize(width: 1024)
      ..writeToFile(outPath);
    // On platforms that support Isolates, execute the image commands asynchronously on an isolate thread.
    // Otherwise, the commands will be executed synchronously.
    await cmd.executeThread();
    return outPath;
  }






/// OLD image_utils.dart:
  //   /// Returns [Uint8List] image bytes from [path].
  // ///
  // /// [path] may be of [imageProvider] type [imageAsset], [imageNetwork],
  // /// [imageFile], or [imageMemory].
  // ///
  // /// Throws [UnsupportedError] if [image] extraction failed.
  // static Future<Uint8List> getBytesFromPath(String path) async {
  //   return await getBytesFromImage(getImageFromPath(path));
  // }

  // /// Returns [Uint8List] image bytes from [image].
  // ///
  // /// [image] may be of [imageProvider] type [imageAsset], [imageNetwork],
  // /// [imageFile], or [imageMemory].
  // ///
  // /// Throws [UnsupportedError] if [image] extraction failed.
  // static Future<Uint8List> getBytesFromImage(Image image) async {
  //   late final Uint8List bytes;
  //   switch (image.image.runtimeType) {
  //     case AssetImage:
  //       {
  //         AssetImage ai = image.image as AssetImage;
  //         ByteData bd = await rootBundle.load(ai.assetName);
  //         final buffer = bd.buffer;
  //         bytes = buffer.asUint8List();
  //         break;
  //       }

  //     case FileImage:
  //       {
  //         FileImage fi = image.image as FileImage;
  //         bytes = fi.file.readAsBytesSync();
  //         break;
  //       }

  //     case NetworkImage:
  //       {
  //         NetworkImage ni = image.image as NetworkImage;
  //         bytes = (await NetworkAssetBundle(Uri.parse(ni.url)).load(ni.url))
  //             .buffer
  //             .asUint8List();
  //         break;
  //       }

  //     case MemoryImage:
  //       {
  //         MemoryImage mi = image.image as MemoryImage;
  //         bytes = mi.bytes;
  //         break;
  //       }

  //     default:
  //       throw UnsupportedError(
  //           'imageToBytes(): Unknown Image type ${image.image.runtimeType}');
  //   }

  //   return bytes;
  // }

  // /// Returns [Image] of type [providerType] from [path].
  // ///
  // /// See [ImageByPath] for supported [path] formats.
  // ///
  // /// Throws exception if image could not be created.
  // static Image getImageFromPath(String path) {
  //   if (path.startsWith("asset")) {
  //     return Image.asset(path);
  //   } else if (path.startsWith('http')) {
  //     return Image.network(path);
  //   } else if ((path.startsWith('file')) || (path.startsWith('/'))) {
  //     return FileService.getImageFileFromPath(path);
  //   }
  //   if (kDebugMode) print('Invalid image path $path');
  //   throw Exception('Creation of image at $path failed.');
  // }

  /// Returns [image] size.
  static Future<Size> getSize(Image image) {
    Completer<Size> completer = Completer();
    image.image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
      Size size = Size(
          imageInfo.image.width.toDouble(), imageInfo.image.height.toDouble());
      completer.complete(size);
    }));

    return completer.future;
  }

  /// Returns image size from [bytes].
  static Future<Size> getSizeFromBytes(Uint8List bytes) async {
    return await getSize(Image.memory(bytes));
  }

  // FIXME The formulas below are incorrectly based on AR being height / width.
  // The AR returned by Size objects is width / height. You need to recompute
  // the formula and code based on this correction.

  /// Returns [playSize] crop dimensions from original image size.
  /// To compute these dimensions we need one fixed raw unit and the aspect
  /// ratios (AR) of the raw image and the target (desired) image. Either fixed
  /// raw unit may be used; either altorithm yields the same results.
  /// _Note:_ AR is width / height.
  /// - Method 1: To compute target width given raw height:
  ///     tw = rawW * rawAR / AR
  /// - Method 2: to compute target height given raw height:
  ///     tH = rawH * AR / rawAR
  ///
  /// Without more research it's hard to know which method is best, so I'm
  /// opting for method 1.
  /// FIXME Oops - The AR values above refer to height / width. Actual AR is
  ///       measured as width / height! The comment above, and the code below,
  ///       need to be refactored. For now I fixed AR to be 1 / <incorrect>AR.
  static Size getAutoCropSize(Size originalSize) {
    final originalAR = 1 / originalSize.aspectRatio;
    final playSizeAR = 1 / playSize.aspectRatio;
    return Size(
        originalSize.width * originalAR / playSizeAR, originalSize.height);
  }

  /// Crops, resizes, converts to .png, and writes [image] to [targetPath].
  ///
  /// [image] may be any supported Image type. The resulting file is written
  /// to [targetPath].
  static Future<Uint8List> cropResizeWriteAsPng(
      Image image, String targetPath) async {
    final originalSize = await getSize(image);
    late final img.Command cmd;
    final width = playSize.width.toInt();
    final bytes = await getBytesFromImage(image);
    final croppedSize = getAutoCropSize(originalSize);
    if (kDebugMode) {
      print(
          'Cropping ${(image.image as AssetImage).assetName.split("/").last} from $originalSize to $croppedSize.');
    }
    cmd = img.Command()
      ..decodeImage(bytes)
      ..copyCrop(
          x: 0,
          y: 0,
          width: croppedSize.width.toInt(),
          height: croppedSize.height.toInt())
      // Resize the image to [width] pixels and a height that maintains the
      // aspect ratio.
      ..copyResize(width: width)
      ..encodePng()
      ..writeToFile(targetPath);
    // Executes asynchronously on platforms that support Isolates; synchronously
    // on platforms that do not.
    final result = await cmd.executeThread();
    if (kDebugMode) {
      final newSize = await getSizeFromBytes(result.outputBytes!);
      print(
          'Resized ${targetPath.split("/").last} from $originalSize to $newSize.');
    }
    return result.outputBytes!;
  }

  /// Resizes, converts to .png, and writes [image] to [targetPath].
  ///
  /// [image] may be any supported Image type. The resulting file is written
  /// to [targetPath].
  static Future<Uint8List> resizeWriteAsPng(
      Image image, String targetPath) async {
    late final img.Command cmd;
    final width = playSize.width.toInt();
    final bytes = await getBytesFromImage(image);
    cmd = img.Command()
      ..decodeImage(bytes)
      // Resize the image to [width] pixels and a height that maintains the
      // aspect ratio.
      ..copyResize(width: width)
      ..encodePng()
      ..writeToFile(targetPath);
    // Executes asynchronously on platforms that support Isolates; synchronously
    // on platforms that do not.
    final result = await cmd.executeThread();
    if (kDebugMode) {
      final originalSize = await getSize(image);
      final newSize = await getSizeFromBytes(result.outputBytes!);
      print(
          'Resized ${targetPath.split("/").last} from $originalSize to $newSize.');
    }
    return result.outputBytes!;
  }
}

class Consts {
  static const String defaultImageUrl =
      'assets/img/default.png';
  static Image defaultImage =
      ImageByPath(path: defaultImageUrl);
}