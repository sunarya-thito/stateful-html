import 'dart:html' as html;

import 'framework.dart';
import 'key.dart';
import 'widgets.dart';

typedef DOMEventListener = void Function(html.Event event);

class DOMElement extends StatefulWidget {
  final String tag;
  final Map<String, String>? attributes;
  final Map<String, String>? style;
  final Map<String, DOMEventListener>? events;
  final List<Widget>? children;

  const DOMElement({
    Key? key,
    required this.tag,
    this.attributes,
    this.style,
    this.events,
    this.children,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DOMElementState();
  }
}

class _DOMElementState extends State<DOMElement> {
  late HtmlController controller;

  @override
  void initState() {
    super.initState();
    controller = HtmlController.tag(widget.tag);
    html.Element element = controller.element;
    element = html.Element.tag(widget.tag);
    if (widget.attributes != null) {
      // element.attributes.addAll(widget.attributes!);
      element.attributes = widget.attributes!;
    }
    if (widget.style != null) {
      element.style.cssText = '';
      for (var entry in widget.style!.entries) {
        element.style.setProperty(entry.key, entry.value);
      }
    }
    if (widget.events != null) {
      // remove old events
      widget.events!.forEach((key, value) {
        element.addEventListener(key, value);
      });
    }
  }

  @override
  void didUpdateWidget(DOMElement oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tag != oldWidget.tag) {
      controller = HtmlController.tag(widget.tag);
    }
    html.Element element = controller.element;
    if (widget.attributes != null) {
      // element.attributes.addAll(widget.attributes!);
      element.attributes = widget.attributes!;
    }
    if (widget.style != null) {
      element.style.cssText = '';
      for (var entry in widget.style!.entries) {
        element.style.setProperty(entry.key, entry.value);
      }
    }
    if (widget.events != null) {
      // remove old events
      oldWidget.events!.forEach((key, value) {
        element.removeEventListener(key, value);
      });
      widget.events!.forEach((key, value) {
        element.addEventListener(key, value);
      });
    }
  }

  @override
  List<Widget> buildChildren(BuildContext context) {
    return [
      HtmlWidget(controller: controller),
    ];
  }
}
