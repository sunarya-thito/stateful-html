abstract class Effect {
  String get filterCss;
}
//
// abstract class FilterEffect {
//   String get filterCss;
// }
//
// abstract class StyleEffect {
//   void setup(html.CssStyleDeclaration style);
// }
//
// class InnerShadowEffect extends Effect {
//   final double x;
//   final double y;
//   final double blur;
//   final double spread;
//   final Color color;
//   final double opacity;
//
//   InnerShadowEffect({
//     required this.x,
//     required this.y,
//     required this.blur,
//     required this.spread,
//     required this.color,
//     required this.opacity,
//   });
//
//   @override
//   String get filterCss {
//     return 'drop-shadow(${x}px ${y}px ${blur}px rgba(${color.red}, ${color.green}, ${color.blue}, $opacity))';
//   }
// }
//
// class DropShadowEffect extends Effect {
//   final double x;
//   final double y;
//   final double blur;
//   final double spread;
//   final Color color;
//   final double opacity;
//   final bool showBehindTransparentAreas;
//
//   DropShadowEffect({
//     required this.x,
//     required this.y,
//     required this.blur,
//     required this.spread,
//     required this.color,
//     required this.opacity,
//     this.showBehindTransparentAreas = false,
//   });
//
//   @
// }
//
// class BlurEffect extends Effect {
//   final double blur;
//
//   BlurEffect({
//     required this.blur,
//   });
//
//   @override
//   void setup(html.CssStyleDeclaration style) {
//     style.filter = 'blur(${blur}px)';
//   }
// }
//
// class BackgroundBlurEffect extends Effect {
//   final double blur;
//
//   BackgroundBlurEffect({
//     required this.blur,
//   });
//
//   @override
//   void setup(html.CssStyleDeclaration style) {
//     style.setProperty('backdrop-filter', 'blur(${blur}px)');
//   }
// }
