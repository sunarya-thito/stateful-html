import 'dart:html' as html;

import 'framework.dart';
import 'material/icons.dart';

typedef OnClickCallback = void Function();
typedef OnDoubleClickCallback = void Function();
typedef OnMouseDownCallback = void Function();
typedef OnMouseMoveCallback = void Function();
typedef OnMouseUpCallback = void Function();
typedef OnMouseOverCallback = void Function();
typedef OnWheelCallback = void Function();

enum DeltaMode {
  pixels,
  lines,
  pages,
}

class Event {
  final html.Event _event;
  final BuildContext target;

  Event(this._event, this.target);

  bool get bubbles =>
      _event.bubbles ==
      true; // _event.bubbles is bool? so we need to check if it's true
  bool get cancelable => _event.cancelable == true;
  bool get composed => _event.composed == true;

  void preventDefault() {
    _event.preventDefault();
  }

  void stopPropagation() {
    _event.stopPropagation();
  }

  void stopImmediatePropagation() {
    _event.stopImmediatePropagation();
  }

  bool get defaultPrevented => _event.defaultPrevented;
}

class MouseEvent extends Event {
  MouseEvent(html.MouseEvent event, BuildContext target) : super(event, target);
  @override
  html.MouseEvent get _event => super._event as html.MouseEvent;

  num get clientX => _event.client.x;
  num get clientY => _event.client.y;
  num get offsetX => _event.offset.x;
  num get offsetY => _event.offset.y;
  num get pageX => _event.page.x;
  num get pageY => _event.page.y;
  num get screenX => _event.screen.x;
  num get screenY => _event.screen.y;
  bool get altKey => _event.altKey;
  bool get ctrlKey => _event.ctrlKey;
  bool get metaKey => _event.metaKey;
  bool get shiftKey => _event.shiftKey;
  int get button => _event.button;
}

class WheelEvent {
  final double deltaX;
  final double deltaY;
  final double deltaZ;
  final DeltaMode deltaMode;

  const WheelEvent({
    required this.deltaX,
    required this.deltaY,
    required this.deltaZ,
    required this.deltaMode,
  });
}

class GestureDetector extends StatefulWidget {
  final Object _child;
}
