import 'basic.dart';
import 'resource.dart';

abstract class Fill {
  double get opacity;
  String get backgroundCss;
}

class ColorFill extends Fill {
  final Color color;
  @override
  final double opacity;
  ColorFill(this.color, {this.opacity = 1.0});

  @override
  String get backgroundCss =>
      'rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha})';
}

class LinearGradientFill extends Fill {
  final List<Color> colors;
  final List<double> stops;
  final double angle;
  @override
  final double opacity;
  LinearGradientFill({
    required this.colors,
    required this.stops,
    required this.angle,
    this.opacity = 1.0,
  });

  @override
  String get backgroundCss {
    String colorString = colors
        .map((color) =>
            'rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha})')
        .join(', ');
    String stopString = stops.map((stop) => '${stop * 100}%').join(', ');
    return 'linear-gradient(${angle}deg, $colorString, $stopString)';
  }
}

class RadialGradientFill extends Fill {
  final List<Color> colors;
  final List<double> stops;
  final double angle;
  final double width;
  final double height;
  @override
  final double opacity;
  RadialGradientFill({
    required this.colors,
    required this.stops,
    required this.angle,
    this.width = 100,
    this.height = 100,
    this.opacity = 1.0,
  });

  @override
  String get backgroundCss {
    String colorString = colors
        .map((color) =>
            'rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha})')
        .join(', ');
    String stopString = stops.map((stop) => '${stop * 100}%').join(', ');
    return 'radial-gradient(${angle}deg at $width% $height%, $colorString, $stopString)';
  }
}

class AngularGradientFill extends Fill {
  final List<Color> colors;
  final List<double> stops;
  final double angle;
  final double width;
  final double height;
  AngularGradientFill({
    required this.colors,
    required this.stops,
    required this.angle,
    this.width = 100,
    this.height = 100,
  });

  @override
  final double opacity = 1.0;

  @override
  String get backgroundCss {
    String colorString = colors
        .map((color) =>
            'rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha})')
        .join(', ');
    String stopString = stops.map((stop) => '${stop * 100}%').join(', ');
    return 'conic-gradient(from ${angle}deg at $width% $height%, $colorString, $stopString)';
  }
}

// TODO: DiamondGradientFill

class ImageEffect {
  final double exposure;
  final double contrast;
  final double saturation;
  final double temperature;
  final double tint;
  final double highlights;
  final double shadows;

  const ImageEffect({
    this.exposure = 0,
    this.contrast = 1,
    this.saturation = 1,
    this.temperature = 0,
    this.tint = 0,
    this.highlights = 0,
    this.shadows = 0,
  });
}

abstract class ImageSize {
  static const ImageSize fill = _ImageFill.instance;
  static const ImageSize fit = _ImageFit.instance;
  static const ImageSize stretch = _ImageStretch.instance;
  factory ImageSize.tile(double scale) => _ImageTile(scale);
  factory ImageSize.crop(Insets insets) => _ImageCrop(insets);
  const ImageSize._();
}

class _ImageFill extends ImageSize {
  static const _ImageFill instance = _ImageFill._();
  const _ImageFill._() : super._();
}

class _ImageFit extends ImageSize {
  static const _ImageFit instance = _ImageFit._();
  const _ImageFit._() : super._();
}

class _ImageStretch extends ImageSize {
  static const _ImageStretch instance = _ImageStretch._();
  const _ImageStretch._() : super._();
}

class _ImageTile extends ImageSize {
  final double scale;

  const _ImageTile(this.scale) : super._();
}

class _ImageCrop extends ImageSize {
  final Insets insets;
  const _ImageCrop(this.insets) : super._();
}

class ImageFill extends Fill {
  final Image image;
  final ImageSize size;
  final ImageEffect? effect;
  @override
  final double opacity;

  ImageFill({
    required this.image,
    required this.size,
    this.effect,
    this.opacity = 1.0,
  });

  @override
  String get backgroundCss {
    String sizeString;
    if (size is _ImageFill) {
      sizeString = 'cover';
    } else if (size is _ImageFit) {
      sizeString = 'contain';
    } else if (size is _ImageStretch) {
      sizeString = '100% 100%';
    } else if (size is _ImageTile) {
      sizeString = 'auto';
    } else if (size is _ImageCrop) {
      sizeString = 'auto';
    } else {
      throw UnimplementedError();
    }
    return '${image.css} $sizeString';
  }
}
