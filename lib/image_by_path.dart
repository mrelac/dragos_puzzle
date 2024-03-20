import 'package:dragos_puzzle/image_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Returns an Image of type [ImageProviderType] based on [path].
/// The image provider backing the returned image is determined by the path's
/// starting characters:
///
///   path start        Image constructor   Example path
///     'asset'           Image.asset         'asset/myImage.jpg'
///     'http'            Image.network       'http://myhost/myImage.jpg'
///     'file'            Image.file          'file://myhost/myImage.jpg'
///     '/'               Image.file          '/images/myImage.jpg'
/// If the image cannot be created, an exception is thrown.
///
/// Currently only the Image parameres are supported. If necessary, other
/// parameters specific to Image.asset, Image.network and Image.file can be
/// added.
///
class ImageByPath extends Image {
  ImageByPath({
    super.key,
    required this.path,
    super.frameBuilder,
    super.loadingBuilder,
    super.errorBuilder,
    super.semanticLabel,
    super.excludeFromSemantics = false,
    super.width,
    super.height,
    super.color,
    super.opacity,
    super.colorBlendMode,
    super.fit,
    super.alignment = Alignment.center,
    super.repeat = ImageRepeat.noRepeat,
    super.centerSlice,
    super.matchTextDirection = false,
    super.gaplessPlayback = false,
    super.isAntiAlias = false,
    super.filterQuality = FilterQuality.low,
  }) : super(image: ImageUtils.getImageFromPath(path).image);
  final String path;

  Image get asImage => Image(image: super.image);
}
