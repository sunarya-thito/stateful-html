import 'basic.dart';
import 'fill.dart';
import 'widgets.dart';

class Rectangle extends StatefulWidget {
  final double? x;
  final double? y;
  final FrameSize width;
  final FrameSize height;
  final CornerRadius? cornerRadius;
  final List<Fill>? fills;
  final Stroke? stroke;

  const Rectangle({
    super.key,
    this.x,
    this.y,
    this.width = FrameSize.hugContent,
    this.height = FrameSize.hugContent,
    this.cornerRadius,
    this.fills,
    this.stroke,
  });

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }
}
