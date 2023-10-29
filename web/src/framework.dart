import 'dart:html' as html;
import 'dart:math';

import 'foundation.dart';
import 'key.dart';
import 'widgets.dart';

List<html.Element> buildWidget(Widget widget) {
  var element = _buildHtmlElement(null, widget);
  element.dispatchMounted();
  return element.findRenderObject()!;
}

void runApp(Widget widget, [html.Element? output]) {
  List<html.Element> outputElements = buildWidget(widget);
  output ??= html.document.body!;
  output.children = outputElements;
}

Element _buildHtmlElement(Element? parent, Widget widget) {
  var element = widget.createElement();
  element._parent = parent;
  element._widget = widget;
  return element;
}

abstract class Widget {
  const Widget({this.key});

  final Key? key;

  Element createElement();

  static bool canUpdate(Widget oldWidget, Widget newWidget) {
    return oldWidget.runtimeType == newWidget.runtimeType &&
        oldWidget.key == newWidget.key;
  }
}

abstract class BuildContext {
  Widget get widget;
  bool get mounted;
  List<html.Element>? findRenderObject();
  Size? get size;
  T? lookUpData<T extends DataWidget>({bool exactType = true});
  T? lookUpElement<T extends Element>({bool exactType = true});
  DataWidget? lookUpDataExact(Type type);
  Element? lookUpElementExact(Type type);
}

abstract class Element implements BuildContext {
  Element? _parent;
  Widget? _widget;
  void dispatchMounted() {}
  void dispatchUpdated(Widget oldWidget) {}
  void dispatchUnmounted() {}
  void dispatchChangeDependencies() {}

  void updateChild(List<Widget> widgets);
  void updateRenderObject();

  @override
  T? lookUpData<T extends DataWidget>({bool exactType = true}) {
    Element? element = _parent;
    while (element != null) {
      var widget = element._widget;
      if (exactType) {
        if (widget!.runtimeType == T) {
          return widget as T;
        }
      } else {
        if (widget! is T) {
          return widget as T;
        }
      }
      element = element._parent;
    }
    return null;
  }

  @override
  T? lookUpElement<T extends Element>({bool exactType = true}) {
    Element? element = _parent;
    while (element != null) {
      var widget = element._widget;
      if (exactType) {
        if (widget!.runtimeType == T) {
          return element as T;
        }
      } else {
        if (widget! is T) {
          return element as T;
        }
      }
      element = element._parent;
    }
    return null;
  }

  @override
  DataWidget? lookUpDataExact(Type type) {
    Element? element = _parent;
    while (element != null) {
      var widget = element._widget;
      if (widget!.runtimeType == type) {
        return widget as DataWidget;
      }
      element = element._parent;
    }
    return null;
  }

  @override
  Element? lookUpElementExact(Type type) {
    Element? element = _parent;
    while (element != null) {
      var widget = element._widget;
      if (widget!.runtimeType == type) {
        return element;
      }
      element = element._parent;
    }
    return null;
  }

  @override
  bool get mounted => _parent != null;

  @override
  Widget get widget => _widget!;
}

class ParentElement extends Element {
  html.Element _renderObject;

  ParentElement(this._renderObject);

  final List<Element> _children = [];

  html.Element get renderObject => _renderObject;
  set renderObject(html.Element value) {
    _renderObject.replaceWith(value);
    _renderObject = value;
    updateRenderObject();
  }

  @override
  void dispatchChangeDependencies() {
    super.dispatchChangeDependencies();
    for (var child in _children) {
      child.dispatchChangeDependencies();
    }
  }

  @override
  void dispatchUnmounted() {
    super.dispatchUnmounted();
    for (var child in _children) {
      child.dispatchUnmounted();
    }
  }

  @override
  List<html.Element>? findRenderObject() {
    return [_renderObject];
  }

  @override
  Size? get size => Size(
        Unit.px(_renderObject.clientWidth.toDouble()),
        Unit.px(_renderObject.clientHeight.toDouble()),
      );

  @override
  void updateChild(List<Widget> widgets) {
    // update existing children
    bool childrenChange = false;
    for (var i = 0; i < min(widgets.length, _children.length); i++) {
      var oldChild = _children[i];
      var newChild = widgets[i];
      if (Widget.canUpdate(oldChild._widget!, newChild)) {
        Widget oldWidget = oldChild._widget!;
        oldChild._widget = newChild;
        oldChild.dispatchUpdated(oldWidget);
      } else {
        var newElement = _buildHtmlElement(this, newChild);
        _children[i] = newElement;
        newElement.dispatchMounted();
        childrenChange = true;
      }
    }
    // remove extra children
    for (var i = _children.length - 1; i >= widgets.length; i--) {
      var child = _children[i];
      child.dispatchUnmounted();
      _children.removeAt(i);
      childrenChange = true;
    }
    // add new children
    for (var i = _children.length; i < widgets.length; i++) {
      var child = _buildHtmlElement(this, widgets[i]);
      _children.add(child);
      child.dispatchMounted();
      childrenChange = true;
    }
    if (childrenChange) {
      updateRenderObject();
    }
  }

  @override
  void updateRenderObject() {
    // update render object
    _renderObject.children.clear();
    for (var child in _children) {
      var childRenderObjects = child.findRenderObject();
      if (childRenderObjects != null) {
        _renderObject.children.addAll(childRenderObjects);
      }
    }
  }
}

class PassthroughElement extends Element {
  final List<Element> _children = [];

  @override
  void dispatchUnmounted() {
    super.dispatchUnmounted();
    for (var child in _children) {
      child.dispatchUnmounted();
    }
  }

  @override
  void dispatchChangeDependencies() {
    super.dispatchChangeDependencies();
    for (var child in _children) {
      child.dispatchChangeDependencies();
    }
  }

  @override
  List<html.Element>? findRenderObject() {
    return _children
        .map((e) => e.findRenderObject())
        .nonNulls
        .expand((e) => e)
        .toList();
  }

  @override
  Size? get size => _parent?.size;

  @override
  void updateChild(List<Widget> widgets) {
    // update existing children
    bool childrenChange = false;
    for (var i = 0; i < min(widgets.length, _children.length); i++) {
      var oldChild = _children[i];
      var newChild = widgets[i];
      if (Widget.canUpdate(oldChild._widget!, newChild)) {
        Widget oldWidget = oldChild._widget!;
        oldChild._widget = newChild;
        oldChild.dispatchUpdated(oldWidget);
      } else {
        var newElement = _buildHtmlElement(this, newChild);
        _children[i] = newElement;
        newElement.dispatchMounted();
        childrenChange = true;
      }
    }
    // remove extra children
    for (var i = _children.length - 1; i >= widgets.length; i--) {
      var child = _children[i];
      child.dispatchUnmounted();
      _children.removeAt(i);
      childrenChange = true;
    }
    // add new children
    for (var i = _children.length; i < widgets.length; i++) {
      var child = _buildHtmlElement(this, widgets[i]);
      _children.add(child);
      child.dispatchMounted();
      childrenChange = true;
    }
    if (childrenChange) {
      updateRenderObject();
    }
  }

  @override
  void updateRenderObject() {
    // update render object (at the parent)
    Element? parent = _parent;
    if (parent != null) {
      parent.updateRenderObject();
    }
  }
}
