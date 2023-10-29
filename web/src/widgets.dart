import 'dart:html' as html;

import 'foundation.dart';
import 'framework.dart';
import 'key.dart';

typedef SingleWidgetBuilder = Widget Function(BuildContext context);
typedef WidgetBuilder = List<Widget> Function(BuildContext context);

class SingleBuilder extends StatelessWidget {
  final SingleWidgetBuilder builder;
  const SingleBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  List<Widget> build(BuildContext context) {
    return [builder(context)];
  }
}

class Builder extends StatelessWidget {
  final WidgetBuilder builder;
  const Builder({Key? key, required this.builder}) : super(key: key);

  @override
  List<Widget> build(BuildContext context) {
    return builder(context);
  }
}

abstract class DataWidget extends Widget {
  final Object _child;

  const DataWidget.single({Key? key, required Widget child})
      : _child = child,
        super(key: key);

  const DataWidget({Key? key, required List<Widget> children})
      : _child = children,
        super(key: key);

  bool updateShouldNotify(covariant DataWidget old);

  List<Widget> get children {
    if (_child is Widget) {
      return [
        _child as Widget,
      ];
    } else {
      return _child as List<Widget>;
    }
  }

  @override
  Element createElement() {
    return _DataElement();
  }
}

class _DataElement extends PassthroughElement {
  @override
  void dispatchMounted() {
    super.dispatchMounted();
    updateChild((widget as DataWidget).children);
  }

  @override
  void dispatchUpdated(Widget oldWidget) {
    super.dispatchUpdated(oldWidget);
    if ((widget as DataWidget).updateShouldNotify(oldWidget as DataWidget)) {
      dispatchChangeDependencies();
    }
    updateChild((widget as DataWidget).children);
  }
}

abstract class HtmlController {
  html.CssStyleDeclaration get style {
    return element.style;
  }

  html.Element get element;

  Map<String, String> get attributes {
    return element.attributes;
  }

  set attributes(Map<String, String> value) {
    element.attributes = value;
  }

  String? operator [](String key) {
    return element.getAttribute(key);
  }

  operator []=(String key, String value) {
    element.setAttribute(key, value);
  }

  static DivController div() {
    return DivController();
  }

  static CanvasController canvas() {
    return CanvasController();
  }

  static ButtonController button() {
    return ButtonController();
  }

  static StyleController styleSheet() {
    return StyleController();
  }

  static ParagraphController paragraph() {
    return ParagraphController();
  }

  static SpanController span() {
    return SpanController();
  }

  static TagController tag(String tag) {
    return TagController(tag);
  }
}

class TagController extends HtmlController {
  final String tag;
  @override
  final html.Element element;
  TagController(this.tag) : element = html.Element.tag(tag);
}

class SpanController extends HtmlController {
  @override
  final html.SpanElement element;
  SpanController() : element = html.SpanElement();
}

class ParagraphController extends HtmlController {
  @override
  final html.ParagraphElement element;
  ParagraphController() : element = html.ParagraphElement();
}

class StyleController extends HtmlController {
  @override
  final html.StyleElement element;
  StyleController() : element = html.StyleElement();
}

class DivController extends HtmlController {
  @override
  final html.DivElement element;
  DivController() : element = html.DivElement();
}

class ButtonController extends HtmlController {
  @override
  final html.ButtonElement element;
  ButtonController() : element = html.ButtonElement();
}

class CanvasController extends HtmlController {
  @override
  final html.CanvasElement element;
  CanvasController() : element = html.CanvasElement();

  html.CanvasRenderingContext2D get context2D => element.context2D;
}

class HtmlWidget extends Widget {
  final HtmlController controller;
  final List<Widget>? children;
  const HtmlWidget({
    Key? key,
    required this.controller,
    this.children,
  }) : super(key: key);

  @override
  Element createElement() {
    html.Element renderObject = controller.element;
    return HtmlElement(renderObject);
  }
}

class HtmlElement extends ParentElement {
  HtmlElement(html.Element renderObject) : super(renderObject);

  @override
  void dispatchMounted() {
    super.dispatchMounted();
    List<Widget> children = (widget as HtmlWidget).children ?? [];
    updateChild(children);
  }

  @override
  void dispatchUpdated(Widget oldWidget) {
    super.dispatchUpdated(oldWidget);
    var htmlWidget = widget as HtmlWidget;
    HtmlController controller = htmlWidget.controller;
    if (controller.element != renderObject) {
      renderObject = controller.element;
    }
    List<Widget> children = htmlWidget.children ?? [];
    updateChild(children);
  }
}

abstract class StatelessWidget extends Widget {
  const StatelessWidget({Key? key}) : super(key: key);

  @override
  StatelessElement createElement() {
    return StatelessElement();
  }

  List<Widget> build(BuildContext context);
}

class StatelessElement extends PassthroughElement {
  @override
  void dispatchMounted() {
    super.dispatchMounted();
    List<Widget> children = (widget as StatelessWidget).build(this);
    updateChild(children);
  }

  @override
  void dispatchUpdated(Widget oldWidget) {
    super.dispatchUpdated(oldWidget);
    List<Widget> children = (widget as StatelessWidget).build(this);
    updateChild(children);
  }
}

abstract class StatefulWidget extends Widget {
  const StatefulWidget({Key? key}) : super(key: key);

  @override
  StatefulElement createElement() {
    return StatefulElement();
  }

  State<StatefulWidget> createState();
}

class StatefulElement extends PassthroughElement {
  State<StatefulWidget>? _state;

  @override
  void dispatchMounted() {
    super.dispatchMounted();
    _state = (widget as StatefulWidget).createState();
    _state!._element = this;
    _state!.initState();
    List<Widget> children = _state!.buildChildren(this);
    updateChild(children);
  }

  @override
  void dispatchUpdated(Widget oldWidget) {
    super.dispatchUpdated(oldWidget);
    _state!.didUpdateWidget(oldWidget as StatefulWidget);
    List<Widget> children = _state!.buildChildren(this);
    updateChild(children);
  }

  @override
  void dispatchUnmounted() {
    super.dispatchUnmounted();
    _state!.dispose();
  }

  @override
  void dispatchChangeDependencies() {
    super.dispatchChangeDependencies();
    _state!.didChangeDependencies();
  }
}

abstract class SingleChildState<T extends StatefulWidget> extends State<T> {
  Widget buildChild(BuildContext context);

  @override
  List<Widget> buildChildren(BuildContext context) {
    return [
      buildChild(context),
    ];
  }
}

abstract class State<T extends StatefulWidget> {
  T get widget {
    if (_element == null) {
      throw Exception('State is not mounted');
    }
    return _element!.widget as T;
  }

  StatefulElement? _element;
  BuildContext get context => _element!;

  void initState() {}
  void didUpdateWidget(T oldWidget) {}
  void dispose() {}
  void didChangeDependencies() {}
  void setState(VoidCallback callback) {
    callback();
    _element!.updateChild(buildChildren(_element!));
  }

  List<Widget> buildChildren(BuildContext context);
}
