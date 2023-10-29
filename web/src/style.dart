import 'framework.dart';
import 'key.dart';
import 'widgets.dart';

abstract class StyleSheet {
  const StyleSheet();
  bool get inherit;
  Map<String, String> get css;
  static StyleSheetData? of(BuildContext context) {
    return StyleSheetData.of(context);
  }

  static List<String> classNames(BuildContext context, Type type) {
    List<String> classNames = [];
    StyleSheetData? data = StyleSheetData.of(context);
    while (data != null) {
      StyleSheet sheet = data.sheet;
      if (sheet.runtimeType == type) {
        classNames.add(data._className);
        if (!sheet.inherit) {
          break;
        }
      }
      data = data.parent;
    }
    return classNames;
  }
}

class InheritedStyle extends StatefulWidget {
  final StyleSheet styleSheet;
  final Object _child;

  const InheritedStyle.single({
    Key? key,
    required this.styleSheet,
    required Widget child,
  })  : _child = child,
        super(key: key);

  const InheritedStyle({
    Key? key,
    required this.styleSheet,
    required List<Widget> children,
  })  : _child = children,
        super(key: key);

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
  State<StatefulWidget> createState() {
    return _InheritedStyleSheetState();
  }
}

class _InheritedStyleSheetState extends State<InheritedStyle> {
  static int _counter = 0;
  static String _generateClassName() {
    return 'style-sheet-${_counter++}';
  }

  final String generatedClassName = _generateClassName();
  final StyleController _controller = HtmlController.styleSheet();

  String _buildCss() {
    String css = '';
    for (var entry in widget.styleSheet.css.entries) {
      css += '${entry.key}: ${entry.value};';
    }
    return css;
  }

  @override
  void initState() {
    super.initState();
    _controller.element.text = '.$generatedClassName {${_buildCss()}}';
  }

  @override
  void didUpdateWidget(InheritedStyle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.styleSheet != oldWidget.styleSheet) {
      _controller.element.text = '.$generatedClassName {${_buildCss()}}';
    }
  }

  @override
  List<Widget> buildChildren(BuildContext context) {
    return [
      HtmlWidget(controller: _controller),
      StyleSheetData(
        StyleSheetData.of(context),
        generatedClassName,
        widget.styleSheet,
        children: widget.children,
      ),
    ];
  }
}

class StyleSheetData extends DataWidget {
  static StyleSheetData? of(BuildContext context) {
    return context.lookUpData<StyleSheetData>();
  }

  final StyleSheetData? parent;
  final String _className;
  final StyleSheet sheet;
  StyleSheetData(this.parent, this._className, this.sheet,
      {required super.children});

  @override
  bool updateShouldNotify(StyleSheetData old) {
    return sheet != old.sheet;
  }
}
