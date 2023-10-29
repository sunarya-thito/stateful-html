import 'dart:html' as html;

import 'foundation.dart';
import 'framework.dart';
import 'key.dart';
import 'widgets.dart';

class CustomPaint extends StatefulWidget {
  const CustomPaint({
    Key? key,
    required this.painter,
    this.size,
  }) : super(key: key);

  final CustomPainter painter;
  final Size? size;

  @override
  State<StatefulWidget> createState() => _CustomPaintState();
}

class _CustomPaintState extends State<CustomPaint> {
  final CanvasController controller = HtmlController.canvas();

  @override
  void didUpdateWidget(CustomPaint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.painter != oldWidget.painter) {
      if (widget.painter.shouldRepaint(oldWidget.painter)) {
        widget.painter.paint(controller.context2D, context.size!);
      }
    }
  }

  @override
  List<Widget> buildChildren(BuildContext context) {
    return [
      HtmlWidget(
        controller: controller,
      ),
    ];
  }
}

abstract class CustomPainter {
  void paint(html.CanvasRenderingContext2D canvas, Size size) {}
  bool shouldRepaint(covariant CustomPainter oldDelegate);
}
