import 'framework.dart';
import 'key.dart';
import 'widgets.dart';

class DebugOptions {
  final bool showTooltip;
  final bool showWidgetUpdate;

  const DebugOptions({
    this.showTooltip = false,
    this.showWidgetUpdate = false,
  });
}

class DebugWidget extends StatefulWidget {
  final Widget child;

  const DebugWidget({Key? key, required this.child}) : super(key: key);

  @override
  State createState() {
    return DebugWidgetState();
  }
}

class DebugWidgetState extends State<DebugWidget> {
  final HtmlController controller = HtmlController.div();

  @override
  List<Widget> buildChildren(BuildContext context) {
    return [
      HtmlWidget(
        controller: controller,
        children: [
          widget.child,
        ],
      ),
    ];
  }
}
