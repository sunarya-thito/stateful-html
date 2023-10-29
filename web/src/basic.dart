import 'package:collection/collection.dart';

import 'effects.dart';
import 'fill.dart';
import 'foundation.dart';
import 'framework.dart';
import 'key.dart';
import 'widgets.dart';

enum Direction {
  horizontal,
  vertical,
  wrap,
}

enum Alignment {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

class Insets {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const Insets({
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
  });

  const Insets.all(double value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const Insets.symmetric({
    double vertical = 0,
    double horizontal = 0,
  })  : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;

  const Insets.zero()
      : left = 0,
        top = 0,
        right = 0,
        bottom = 0;

  const Insets.fromLTRB(
    this.left,
    this.top,
    this.right,
    this.bottom,
  );

  Insets copyWith({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return Insets.fromLTRB(
      left ?? this.left,
      top ?? this.top,
      right ?? this.right,
      bottom ?? this.bottom,
    );
  }
}

enum StrokeLayout {
  included,
  excluded,
}

enum StackingOrder {
  lastOnTop,
  firstOnTop,
}

class Layout {
  final Direction direction;
  final double spacing;
  final double runSpacing;
  final Alignment alignment;
  final Insets padding;
  final StrokeLayout strokeLayout;

  final StackingOrder stackingOrder;
  final bool alignTextBaseline;

  const Layout({
    this.direction = Direction.horizontal,
    this.spacing = 0,
    this.runSpacing = 0,
    this.alignment = Alignment.topLeft,
    this.padding = const Insets.zero(),
    this.strokeLayout = StrokeLayout.included,
    this.stackingOrder = StackingOrder.lastOnTop,
    this.alignTextBaseline = false,
  });
}

class Scaling {
  final double scale;
  final Alignment alignment;

  const Scaling({
    this.scale = 1,
    this.alignment = Alignment.center,
  });
}

class Color {
  final int red;
  final int green;
  final int blue;
  final int alpha;

  const Color({
    this.red = 0,
    this.green = 0,
    this.blue = 0,
    this.alpha = 255,
  });

  const Color.rgb(
    this.red,
    this.green,
    this.blue,
  ) : alpha = 255;

  const Color.rgba(
    this.red,
    this.green,
    this.blue,
    this.alpha,
  );

  factory Color.rgbo(
    int red,
    int green,
    int blue,
    double opacity,
  ) {
    return Color.rgba(
      red,
      green,
      blue,
      (opacity * 255).round(),
    );
  }

  factory Color.fromHex(String hex, [int alpha = 255]) {
    if (hex.startsWith('#')) {
      hex = hex.substring(1);
    }
    int parsedHex = int.parse(hex, radix: 16);
    int red = (parsedHex >> 16) & 0xFF;
    int green = (parsedHex >> 8) & 0xFF;
    int blue = parsedHex & 0xFF;
    return Color.rgba(red, green, blue, alpha);
  }

  String get css => 'rgba($red, $green, $blue, ${alpha / 255})';

  Color lerpWith(Color other, double t) {
    return Color.rgba(
      _lerpInt(red, other.red, t),
      _lerpInt(green, other.green, t),
      _lerpInt(blue, other.blue, t),
      _lerpInt(alpha, other.alpha, t),
    );
  }

  Color copyWith({
    int? red,
    int? green,
    int? blue,
    int? alpha,
  }) {
    return Color.rgba(
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
      alpha ?? this.alpha,
    );
  }

  static const Color transparent = Color.rgba(0, 0, 0, 0);
  static Color lerp(Color a, Color b, double t) {
    return Color.rgba(
      _lerpInt(a.red, b.red, t),
      _lerpInt(a.green, b.green, t),
      _lerpInt(a.blue, b.blue, t),
      _lerpInt(a.alpha, b.alpha, t),
    );
  }

  static int _lerpInt(int a, int b, double t) {
    return (a + (b - a) * t).round();
  }
}

enum StrokeAlign {
  inside,
  outside,
  center,
}

class Stroke {
  final List<Color> colors;
  final StrokeAlign align;
  final Insets width;

  const Stroke({
    required this.colors,
    this.align = StrokeAlign.outside,
    this.width = const Insets.all(1),
  });
}

class CornerRadius {
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;
  final double smoothness;

  const CornerRadius({
    this.topLeft = 0,
    this.topRight = 0,
    this.bottomLeft = 0,
    this.bottomRight = 0,
    this.smoothness = 0,
  });

  const CornerRadius.all(double value, [this.smoothness = 0])
      : topLeft = value,
        topRight = value,
        bottomLeft = value,
        bottomRight = value;

  const CornerRadius.symmetric({
    double vertical = 0,
    double horizontal = 0,
    this.smoothness = 0,
  })  : topLeft = horizontal,
        topRight = vertical,
        bottomLeft = horizontal,
        bottomRight = vertical;

  CornerRadius copyWith({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
    double? smoothness,
  }) {
    return CornerRadius(
      topLeft: topLeft ?? this.topLeft,
      topRight: topRight ?? this.topRight,
      bottomLeft: bottomLeft ?? this.bottomLeft,
      bottomRight: bottomRight ?? this.bottomRight,
      smoothness: smoothness ?? this.smoothness,
    );
  }
}

enum HorizontalConstraints {
  left,
  right,
  center,
  leftAndRight,
  scale,
}

enum VerticalConstraints {
  top,
  bottom,
  center,
  topAndBottom,
  scale,
}

abstract class FrameSize {
  static const hugContent = _HugContent.instance;
  static const fillParent = _FillParent.instance;
  factory FrameSize.fixed(Unit value) => _Fixed(value);
  const FrameSize._();
}

class _HugContent extends FrameSize {
  static const _HugContent instance = _HugContent._();
  const _HugContent._() : super._();
}

class _FillParent extends FrameSize {
  static const _FillParent instance = _FillParent._();
  const _FillParent._() : super._();
}

class _Fixed extends FrameSize {
  final Unit value;
  const _Fixed(this.value) : super._();
}

enum OverflowBehavior {
  visible,
  hidden,
  scroll,
}

class Frame extends StatefulWidget {
  final bool clipContent;
  final double? x;
  final double? y;
  final double? x2;
  final double? y2;
  final FrameSize width;
  final FrameSize height;
  final double? rotation;
  final Layout? layout;
  final Scaling? scaling;
  final List<Effect>? effects;
  final Stroke? stroke;
  final CornerRadius? cornerRadius;
  final HorizontalConstraints? horizontalConstraints;
  final VerticalConstraints? verticalConstraints;
  final List<Widget>? children;
  final List<Fill>? fills;
  final OverflowBehavior? horizontalOverflow;
  final OverflowBehavior? verticalOverflow;

  const Frame({
    super.key,
    this.clipContent = false,
    this.x,
    this.y,
    this.x2,
    this.y2,
    this.width = FrameSize.hugContent,
    this.height = FrameSize.hugContent,
    this.rotation,
    this.layout,
    this.scaling,
    this.effects,
    this.stroke,
    this.cornerRadius,
    this.horizontalConstraints,
    this.verticalConstraints,
    this.children,
    this.fills,
    this.horizontalOverflow,
    this.verticalOverflow,
  });

  const Frame.fillParent({
    super.key,
    this.clipContent = false,
    this.x = 0,
    this.y = 0,
    this.x2 = 0,
    this.y2 = 0,
    this.width = FrameSize.hugContent,
    this.height = FrameSize.hugContent,
    this.rotation,
    this.layout,
    this.scaling,
    this.effects,
    this.stroke,
    this.cornerRadius,
    this.horizontalConstraints = HorizontalConstraints.leftAndRight,
    this.verticalConstraints = VerticalConstraints.topAndBottom,
    this.children,
    this.fills,
    this.horizontalOverflow,
    this.verticalOverflow,
  });

  @override
  State<StatefulWidget> createState() {
    return FrameState();
  }
}

class FrameState extends SingleChildState<Frame> {
  final HtmlController self = HtmlController.div();

  @override
  void initState() {
    super.initState();
    _updateStyle();
  }

  @override
  void didUpdateWidget(Frame oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateStyle();
  }

  void _updateStyle() {
    self.style.cssText = ''; // clear all styles
    int? zIndex = IndexOrderData.of(context);
    if (zIndex != null) {
      self.style.zIndex = '$zIndex';
    }
    FrameSize width = widget.width;
    FrameSize height = widget.height;
    bool hasAbsolutePosition = widget.x != null ||
        widget.y != null ||
        widget.x2 != null ||
        widget.y2 != null;
    self.style.position = hasAbsolutePosition ? 'absolute' : 'relative';
    if (hasAbsolutePosition) {
      HorizontalConstraints horizontalConstraints =
          widget.horizontalConstraints ?? HorizontalConstraints.left;
      VerticalConstraints verticalConstraints =
          widget.verticalConstraints ?? VerticalConstraints.top;
      double x = widget.x ?? 0;
      double y = widget.y ?? 0;
      double x2 = widget.x2 ?? 0;
      double y2 = widget.y2 ?? 0;
      if (horizontalConstraints == HorizontalConstraints.left) {
        self.style.left = '${x}px';
      } else if (horizontalConstraints == HorizontalConstraints.right) {
        self.style.right = '${x2}px';
      } else if (horizontalConstraints == HorizontalConstraints.center) {
        self.style.left = '${x}px';
        self.style.right = '${x2}px';
      } else if (horizontalConstraints == HorizontalConstraints.leftAndRight) {
        self.style.left = '${x}px';
        self.style.right = '${x2}px';
      } else if (horizontalConstraints == HorizontalConstraints.scale) {
        self.style.left = '$x%';
        self.style.right = '$x2%';
      }
      if (verticalConstraints == VerticalConstraints.top) {
        self.style.top = '${y}px';
      } else if (verticalConstraints == VerticalConstraints.bottom) {
        self.style.bottom = '${y2}px';
      } else if (verticalConstraints == VerticalConstraints.center) {
        self.style.top = '${y}px';
        self.style.bottom = '${y2}px';
      } else if (verticalConstraints == VerticalConstraints.topAndBottom) {
        self.style.top = '${y}px';
        self.style.bottom = '${y2}px';
      } else if (verticalConstraints == VerticalConstraints.scale) {
        self.style.top = '$y%';
        self.style.bottom = '$y2%';
      }
    }
    if (width is _Fixed) {
      self.style.width = width.value.toString();
    } else if (width is _FillParent) {
      self.style.width = '100%';
    } else {
      self.style.width = 'auto';
    }
    if (height is _Fixed) {
      self.style.height = height.value.toString();
    } else if (height is _FillParent) {
      self.style.height = '100%';
    } else {
      self.style.height = 'auto';
    }
    Layout? layout = widget.layout;
    if (layout != null) {
      self.style.display = 'flex';
      Direction direction = layout.direction;
      Alignment alignment = layout.alignment;
      bool baseline = layout.alignTextBaseline;
      Insets padding = layout.padding;
      self.style.paddingLeft = '${padding.left}px';
      self.style.paddingTop = '${padding.top}px';
      self.style.paddingRight = '${padding.right}px';
      self.style.paddingBottom = '${padding.bottom}px';
      if (direction == Direction.horizontal) {
        self.style.flexDirection = 'row';
        self.style.flexWrap = 'nowrap';
        if (alignment == Alignment.topLeft) {
          self.style.justifyContent = 'flex-start';
          self.style.alignItems = baseline ? 'baseline' : 'flex-start';
        } else if (alignment == Alignment.topCenter) {
          self.style.justifyContent = 'center';
          self.style.alignItems = baseline ? 'baseline' : 'flex-start';
        } else if (alignment == Alignment.topRight) {
          self.style.justifyContent = 'flex-end';
          self.style.alignItems = baseline ? 'baseline' : 'flex-start';
        } else if (alignment == Alignment.centerLeft) {
          self.style.justifyContent = 'flex-start';
          self.style.alignItems = baseline ? 'baseline' : 'center';
        } else if (alignment == Alignment.center) {
          self.style.justifyContent = 'center';
          self.style.alignItems = baseline ? 'baseline' : 'center';
        } else if (alignment == Alignment.centerRight) {
          self.style.justifyContent = 'flex-end';
          self.style.alignItems = baseline ? 'baseline' : 'center';
        } else if (alignment == Alignment.bottomLeft) {
          self.style.justifyContent = 'flex-start';
          self.style.alignItems = baseline ? 'baseline' : 'flex-end';
        } else if (alignment == Alignment.bottomCenter) {
          self.style.justifyContent = 'center';
          self.style.alignItems = baseline ? 'baseline' : 'flex-end';
        } else if (alignment == Alignment.bottomRight) {
          self.style.justifyContent = 'flex-end';
          self.style.alignItems = baseline ? 'baseline' : 'flex-end';
        }
      } else if (direction == Direction.vertical) {
        self.style.flexDirection = 'column';
        self.style.flexWrap = 'nowrap';
        if (alignment == Alignment.topLeft) {
          self.style.justifyContent = 'flex-start';
          self.style.alignItems = baseline ? 'baseline' : 'flex-start';
        } else if (alignment == Alignment.topCenter) {
          self.style.justifyContent = 'flex-start';
          self.style.alignItems = baseline ? 'baseline' : 'center';
        } else if (alignment == Alignment.topRight) {
          self.style.justifyContent = 'flex-start';
          self.style.alignItems = baseline ? 'baseline' : 'flex-end';
        } else if (alignment == Alignment.centerLeft) {
          self.style.justifyContent = 'center';
          self.style.alignItems = baseline ? 'baseline' : 'flex-start';
        } else if (alignment == Alignment.center) {
          self.style.justifyContent = 'center';
          self.style.alignItems = baseline ? 'baseline' : 'center';
        } else if (alignment == Alignment.centerRight) {
          self.style.justifyContent = 'center';
          self.style.alignItems = baseline ? 'baseline' : 'flex-end';
        } else if (alignment == Alignment.bottomLeft) {
          self.style.justifyContent = 'flex-end';
          self.style.alignItems = baseline ? 'baseline' : 'flex-start';
        } else if (alignment == Alignment.bottomCenter) {
          self.style.justifyContent = 'flex-end';
          self.style.alignItems = baseline ? 'baseline' : 'center';
        } else if (alignment == Alignment.bottomRight) {
          self.style.justifyContent = 'flex-end';
          self.style.alignItems = baseline ? 'baseline' : 'flex-end';
        }
      } else if (direction == Direction.wrap) {
        self.style.flexDirection = 'row';
        self.style.flexWrap = 'wrap';
        if (alignment == Alignment.topLeft) {
          self.style.justifyContent = 'flex-start';
          self.style.alignItems = baseline ? 'baseline' : 'flex-start';
        } else if (alignment == Alignment.topCenter) {
          self.style.justifyContent = 'center';
          self.style.alignItems = baseline ? 'baseline' : 'flex-start';
        } else if (alignment == Alignment.topRight) {
          self.style.justifyContent = 'flex-end';
          self.style.alignItems = baseline ? 'baseline' : 'flex-start';
        } else if (alignment == Alignment.centerLeft) {
          self.style.justifyContent = 'flex-start';
          self.style.alignItems = baseline ? 'baseline' : 'center';
        } else if (alignment == Alignment.center) {
          self.style.justifyContent = 'center';
          self.style.alignItems = baseline ? 'baseline' : 'center';
        } else if (alignment == Alignment.centerRight) {
          self.style.justifyContent = 'flex-end';
          self.style.alignItems = baseline ? 'baseline' : 'center';
        } else if (alignment == Alignment.bottomLeft) {
          self.style.justifyContent = 'flex-start';
          self.style.alignItems = baseline ? 'baseline' : 'flex-end';
        } else if (alignment == Alignment.bottomCenter) {
          self.style.justifyContent = 'center';
          self.style.alignItems = baseline ? 'baseline' : 'flex-end';
        } else if (alignment == Alignment.bottomRight) {
          self.style.justifyContent = 'flex-end';
          self.style.alignItems = baseline ? 'baseline' : 'flex-end';
        }
      }
    }
    if (widget.clipContent) {
      OverflowBehavior horizontalOverflow =
          widget.horizontalOverflow ?? OverflowBehavior.hidden;
      OverflowBehavior verticalOverflow =
          widget.verticalOverflow ?? OverflowBehavior.hidden;
      if (horizontalOverflow == OverflowBehavior.scroll) {
        self.style.overflowX = 'scroll';
      } else if (horizontalOverflow == OverflowBehavior.hidden) {
        self.style.overflowX = 'hidden';
      } else {
        self.style.overflowX = 'visible';
      }
      if (verticalOverflow == OverflowBehavior.scroll) {
        self.style.overflowY = 'scroll';
      } else if (verticalOverflow == OverflowBehavior.hidden) {
        self.style.overflowY = 'hidden';
      } else {
        self.style.overflowY = 'visible';
      }
    } else {
      self.style.overflow = 'visible';
    }
    List<Fill>? fills = widget.fills;
    if (fills != null) {
      String background = fills.map((fill) => fill.backgroundCss).join(',');
      self.style.background = background;
    }
  }

  @override
  Widget buildChild(BuildContext context) {
    List<Widget>? children = widget.children;
    Layout? layout = widget.layout;
    return HtmlWidget(
      controller: self,
      children: children?.mapIndexed(
        (index, element) {
          int i = layout?.stackingOrder == StackingOrder.firstOnTop
              ? children.length - index - 1
              : index;
          return IndexOrderData(
            order: i,
            child: element,
          );
        },
      ).toList(),
    );
  }
}

class IndexOrderData extends DataWidget {
  final int order;

  const IndexOrderData({
    Key? key,
    required this.order,
    required Widget child,
  }) : super.single(key: key, child: child);

  @override
  bool updateShouldNotify(IndexOrderData old) {
    return order != old.order;
  }

  static int? of(BuildContext context) {
    return context.lookUpData<IndexOrderData>()?.order;
  }
}
