import 'dart:convert';
import 'dart:html';

abstract class Image {
  String get css;
  void updateStyle(CssStyleDeclaration style);
}

class NetworkImage extends Image {
  final String url;
  NetworkImage(this.url);

  @override
  void updateStyle(CssStyleDeclaration style) {
    style.backgroundImage = 'url($url)';
  }

  @override
  String get css => 'url($url)';
}

class MemoryImage extends Image {
  final String base64;
  MemoryImage(this.base64);
  factory MemoryImage.fromBytes(List<int> bytes) {
    return MemoryImage(base64Encode(bytes));
  }

  @override
  void updateStyle(CssStyleDeclaration style) {
    style.backgroundImage = 'url(data:image/png;base64,$base64)';
  }

  @override
  String get css => 'url(data:image/png;base64,$base64)';
}
