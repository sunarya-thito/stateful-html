import 'package:collection/collection.dart';

import 'basic.dart';
import 'framework.dart';
import 'key.dart';
import 'style.dart';
import 'widgets.dart';

class TextStyle extends StyleSheet {
  @override
  final bool inherit;
  final Color? color;
  final String? fontFamily;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextTransform? textTransform;
  final TextDecoration? textDecoration;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? lineHeight;
  final WhiteSpace? whiteSpace;
  final WordWrap? wordWrap;
  final TextOverflow? textOverflow;
  final VerticalAlign? verticalAlign;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final TextRendering? textRendering;
  final TextQuote? textQuote;
  final TextOrientation? textOrientation;
  final WritingMode? writingMode;
  final List<TextShadow>? textShadow;

  const TextStyle({
    this.inherit = true,
    this.color,
    this.fontFamily,
    this.fontSize,
    this.fontWeight,
    this.textTransform,
    this.textDecoration,
    this.textAlign,
    this.letterSpacing,
    this.wordSpacing,
    this.lineHeight,
    this.whiteSpace,
    this.wordWrap,
    this.textOverflow,
    this.verticalAlign,
    this.textAlignVertical,
    this.textDirection,
    this.textRendering,
    this.textQuote,
    this.textOrientation,
    this.writingMode,
    this.textShadow,
  });

  @override
  Map<String, String> get css => {
        if (color != null) 'color': color!.css,
        if (fontFamily != null) 'font-family': fontFamily!,
        if (fontSize != null) 'font-size': '${fontSize!}px',
        if (fontWeight != null) 'font-weight': fontWeight!.value,
        if (textTransform != null) 'text-transform': textTransform!.value,
        if (textDecoration != null) 'text-decoration': textDecoration!.value,
        if (textAlign != null) 'text-align': textAlign!.value,
        if (letterSpacing != null) 'letter-spacing': '${letterSpacing!}px',
        if (wordSpacing != null) 'word-spacing': '${wordSpacing!}px',
        if (lineHeight != null) 'line-height': '${lineHeight!}px',
        if (whiteSpace != null) 'white-space': whiteSpace!.value,
        if (wordWrap != null) 'word-wrap': wordWrap!.value,
        if (textOverflow != null) 'text-overflow': textOverflow!.value,
        if (verticalAlign != null) 'vertical-align': verticalAlign!.value,
        if (textAlignVertical != null)
          'text-align-vertical': textAlignVertical!.value,
        if (textDirection != null) 'text-direction': textDirection!.value,
        if (textRendering != null) 'text-rendering': textRendering!.value,
        if (textQuote != null)
          'text-quote': '${textQuote!.open} ${textQuote!.close}',
        if (textOrientation != null) 'text-orientation': textOrientation!.value,
        if (writingMode != null) 'writing-mode': writingMode!.value,
        if (textShadow != null)
          'text-shadow': textShadow!
              .map((shadow) =>
                  '${shadow.offsetX}px ${shadow.offsetY}px ${shadow.blurRadius}px ${shadow.color.css}')
              .join(', '),
      };
}

enum WhiteSpace {
  normal('normal'),
  nowrap('nowrap'),
  pre('pre'),
  preLine('pre-line'),
  preWrap('pre-wrap');

  final String value;
  const WhiteSpace(this.value);
}

enum WordWrap {
  normal('normal'),
  breakWord('break-word');

  final String value;
  const WordWrap(this.value);
}

enum TextOverflow {
  clip('clip'),
  ellipsis('ellipsis'),
  ellipsisWord('ellipsis-word');

  final String value;
  const TextOverflow(this.value);
}

enum VerticalAlign {
  baseline('baseline'),
  sub('sub'),
  super_('super'),
  textTop('text-top'),
  textBottom('text-bottom'),
  middle('middle'),
  top('top'),
  bottom('bottom');

  final String value;
  const VerticalAlign(this.value);
}

enum TextAlignVertical {
  top('top'),
  bottom('bottom'),
  middle('middle');

  final String value;
  const TextAlignVertical(this.value);
}

enum TextDirection {
  ltr('ltr'),
  rtl('rtl');

  final String value;
  const TextDirection(this.value);
}

enum TextRendering {
  auto('auto'),
  optimizeSpeed('optimizeSpeed'),
  optimizeLegibility('optimizeLegibility'),
  geometricPrecision('geometricPrecision');

  final String value;
  const TextRendering(this.value);
}

class TextQuote {
  final String open;
  final String close;

  const TextQuote({
    required this.open,
    required this.close,
  });
}

enum TextOrientation {
  mixed('mixed'),
  upright('upright'),
  sideways('sideways');

  final String value;
  const TextOrientation(this.value);
}

enum WritingMode {
  horizontalTb('horizontal-tb'),
  verticalRl('vertical-rl'),
  verticalLr('vertical-lr');

  final String value;
  const WritingMode(this.value);
}

class TextShadow {
  final Color color;
  final double offsetX;
  final double offsetY;
  final double blurRadius;

  const TextShadow({
    required this.color,
    required this.offsetX,
    required this.offsetY,
    required this.blurRadius,
  });
}

enum FontWeight {
  normal('normal'),
  bold('bold'),
  lighter('lighter'),
  bolder('bolder'),
  w100('100'),
  w200('200'),
  w300('300'),
  w400('400'),
  w500('500'),
  w600('600'),
  w700('700'),
  w800('800'),
  w900('900');

  final String value;
  const FontWeight(this.value);
}

enum TextTransform {
  none('none'),
  capitalize('capitalize'),
  uppercase('uppercase'),
  lowercase('lowercase'),
  fullWidth('full-width');

  final String value;
  const TextTransform(this.value);
}

enum TextDecoration {
  none('none'),
  underline('underline'),
  overline('overline'),
  lineThrough('line-through');

  final String value;
  const TextDecoration(this.value);
}

enum TextAlign {
  left('left'),
  right('right'),
  center('center'),
  justify('justify');

  final String value;
  const TextAlign(this.value);
}

class Text extends StatefulWidget {
  final String data;
  final bool selectable;
  final Object? _style;

  const Text(
    this.data, {
    Key? key,
    this.selectable = false,
  })  : _style = null,
        super(key: key);

  const Text.styled(
    this.data, {
    Key? key,
    required TextStyle style,
    this.selectable = false,
  })  : _style = style,
        super(key: key);

  const Text.inheritStyle(
    this.data, {
    Key? key,
    required Type style,
    this.selectable = false,
  })  : _style = style,
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TextState();
  }
}

class _TextState extends State<Text> {
  late final HtmlController controller;

  HtmlController createController() {
    return HtmlController.div();
  }

  @override
  void initState() {
    super.initState();
    controller = createController();
    if (!widget.selectable) {
      controller.element.style.userSelect = 'none';
    }
    Object? style = widget._style;
    if (style is TextStyle) {
      Map<String, String> sheet = style.css;
      for (var entry in sheet.entries) {
        controller.style.setProperty(entry.key, entry.value);
      }
      List<String> classNames =
          StyleSheet.classNames(context, style.runtimeType);
      if (!IterableEquality().equals(controller.element.classes, classNames)) {
        controller.element.classes = classNames;
      }
    } else if (style is Type) {
      List<String> classNames = StyleSheet.classNames(context, style);
      if (!IterableEquality().equals(controller.element.classes, classNames)) {
        controller.element.classes = classNames;
      }
    }
    controller.element.text = widget.data;
  }

  @override
  void didUpdateWidget(Text oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      controller.element.text = widget.data;
    }
    if (widget._style != oldWidget._style) {
      Object? style = widget._style;
      if (style is TextStyle) {
        Map<String, String> sheet = style.css;
        for (var entry in sheet.entries) {
          controller.style.setProperty(entry.key, entry.value);
        }
        List<String> classNames =
            StyleSheet.classNames(context, style.runtimeType);
        if (!IterableEquality()
            .equals(controller.element.classes, classNames)) {
          controller.element.classes = classNames;
        }
      } else if (style is Type) {
        List<String> classNames = StyleSheet.classNames(context, style);
        if (!IterableEquality()
            .equals(controller.element.classes, classNames)) {
          controller.element.classes = classNames;
        }
      }
    }
  }

  @override
  List<Widget> buildChildren(BuildContext context) {
    return [
      HtmlWidget(controller: controller),
    ];
  }
}

class Span extends Text {
  const Span(
    super.data, {
    Key? key,
    super.selectable = false,
  }) : super(key: key);

  const Span.styled(
    super.data, {
    Key? key,
    required TextStyle style,
    super.selectable = false,
  }) : super.styled(key: key, style: style);
  const Span.inheritStyle(
    super.data, {
    Key? key,
    required Type style,
    super.selectable = false,
  }) : super.inheritStyle(key: key, style: style);
  @override
  State<StatefulWidget> createState() {
    return _SpanState();
  }
}

class _SpanState extends _TextState {
  @override
  HtmlController createController() {
    return HtmlController.span();
  }
}

class Paragraph extends Text {
  const Paragraph(
    super.data, {
    Key? key,
    super.selectable = false,
  }) : super(key: key);
  const Paragraph.styled(
    super.data, {
    Key? key,
    required TextStyle style,
    super.selectable = false,
  }) : super.styled(key: key, style: style);
  const Paragraph.inheritStyle(
    super.data, {
    Key? key,
    required Type style,
    super.selectable = false,
  }) : super.inheritStyle(key: key, style: style);
  @override
  State<StatefulWidget> createState() {
    return _ParagraphState();
  }
}

class _ParagraphState extends _TextState {
  @override
  HtmlController createController() {
    return HtmlController.paragraph();
  }
}
