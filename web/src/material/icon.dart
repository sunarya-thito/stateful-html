import 'package:collection/collection.dart';

import '../basic.dart';
import '../framework.dart';
import '../meta.dart';
import '../style.dart';
import '../widgets.dart';

class IconStyle extends StyleSheet {
  @override
  final bool inherit;
  final bool? filled;
  final IconWeight? weight;
  final IconGrade? grade;
  final IconOpticalSize? opticalSize;
  final Color? color;
  final double? size;
  final IconType? type;

  const IconStyle({
    this.inherit = true,
    this.filled,
    this.weight,
    this.grade,
    this.opticalSize,
    this.color,
    this.size,
    this.type,
  });

  @override
  Map<String, String> get css {
    List<String> settings = [];
    if (filled != null) {
      settings.add('\'FILL\' ${filled! ? '1' : '0'}');
    }
    if (weight != null) {
      settings.add('\'wght\' ${weight!.value}');
    }
    if (grade != null) {
      settings.add('\'GRAD\' ${grade!.value}');
    }
    if (opticalSize != null) {
      settings.add('\'opsz\' ${opticalSize!.value}');
    }
    return {
      // 'font-variation-settings': settings.join(', '),
      if (settings.isNotEmpty) 'font-variation-settings': settings.join(', '),
      if (color != null) 'color': color!.css,
      if (size != null) 'font-size': '${size!}px',
    };
  }
}

enum IconWeight {
  w100(100),
  w200(200),
  w300(300),
  w400(400),
  w500(500),
  w600(600),
  w700(700);

  final int value;
  const IconWeight(this.value);
}

enum IconGrade {
  lowEmphasis(-25),
  defaultEmphasis(0),
  highEmphasis(200);

  final int value;
  const IconGrade(this.value);
}

enum IconOpticalSize {
  s20(20),
  s24(24),
  s40(40),
  s48(48);

  final int value;
  const IconOpticalSize(this.value);
}

enum IconType {
  outlined('Material Symbols Outlined', 'material-symbols-outlined'),
  rounded('Material Symbols Rounded', 'material-symbols-rounded'),
  sharp('Material Symbols Sharp', 'material-symbols-sharp');

  final String value;
  final String className;
  const IconType(this.value, this.className);
}

abstract class IconData {
  const IconData();
}

class NamedIconData extends IconData {
  final String name;

  const NamedIconData(this.name);
}

const kMaterialSymbolsOutlined = Metadata(
  tag: 'link',
  attributes: {
    'rel': 'stylesheet',
    'href':
        'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200',
  },
);

const kMaterialSymbolsRounded = Metadata(
  tag: 'link',
  attributes: {
    'rel': 'stylesheet',
    'href':
        'https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200',
  },
);

const kMaterialSymbolsSharp = Metadata(
  tag: 'link',
  attributes: {
    'rel': 'stylesheet',
    'href':
        'https://fonts.googleapis.com/css2?family=Material+Symbols+Sharp:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200',
  },
);

class Icon extends StatefulWidget {
  final IconData icon;
  final Object? _style;

  const Icon(this.icon, {IconStyle? style}) : _style = style;

  const Icon.styled(this.icon, {Type? style}) : _style = style;

  @override
  State<StatefulWidget> createState() {
    return _IconState();
  }
}

class _IconState extends State<Icon> {
  final HtmlController controller = HtmlController.tag('span');

  @override
  void initState() {
    super.initState();
    Object? style = widget._style;
    if (style is IconStyle) {
      Map<String, String> sheet = style.css;
      for (var entry in sheet.entries) {
        controller.style.setProperty(entry.key, entry.value);
      }
      Color? color = style.color;
      if (color != null) {
        controller.element.style.setProperty('color', color.css);
      }
      double? size = style.size;
      if (size != null) {
        controller.element.style.setProperty('font-size', '${size}px');
      }
      List<String> classNames =
          StyleSheet.classNames(context, style.runtimeType);
      IconType? type = style.type;
      if (type == null) {
        StyleSheetData? sheetData = StyleSheet.of(context);
        while (sheetData != null) {
          var sheet = sheetData.sheet;
          if (sheet.runtimeType == style.runtimeType) {
            var iconType = (sheet as IconStyle).type;
            if (iconType != null) {
              type = iconType;
              break;
            }
            if (!sheet.inherit) {
              break;
            }
          }
          sheetData = sheetData.parent;
        }
      }
      type ??= IconType.outlined;
      _prepareType(type);
      classNames.insert(0, type.className);
      if (!IterableEquality().equals(controller.element.classes, classNames)) {
        controller.element.classes = classNames;
      }
    } else if (style is Type) {
      List<String> classNames = StyleSheet.classNames(context, style);
      StyleSheetData? sheetData = StyleSheet.of(context);
      IconType? foundType;
      while (sheetData != null) {
        var sheet = sheetData.sheet;
        if (sheet.runtimeType == style) {
          var iconType = (sheet as IconStyle).type;
          if (iconType != null) {
            foundType = iconType;
            break;
          }
          if (!sheet.inherit) {
            break;
          }
        }
        sheetData = sheetData.parent;
      }
      foundType ??= IconType.outlined;
      _prepareType(foundType);
      classNames.insert(0, foundType.className);
      if (!IterableEquality().equals(controller.element.classes, classNames)) {
        controller.element.classes = classNames;
      }
    } else {
      StyleSheetData? sheetData = StyleSheet.of(context);
      IconType? foundType;
      while (sheetData != null) {
        var sheet = sheetData.sheet;
        if (sheet is IconStyle) {
          var iconType = sheet.type;
          if (iconType != null) {
            foundType = iconType;
            break;
          }
          if (!sheet.inherit) {
            break;
          }
        }
        sheetData = sheetData.parent;
      }
      foundType ??= IconType.outlined;
      _prepareType(foundType);
      List<String> singleton = [foundType.className];
      if (!IterableEquality().equals(controller.element.classes, singleton)) {
        controller.element.classes = singleton;
      }
    }
    IconData icon = widget.icon;
    if (icon is NamedIconData) {
      controller.element.text = icon.name;
    }
    controller.element.style.width = '1em';
    controller.element.style.height = '1em';
    controller.element.style.userSelect = 'none';
  }

  void _prepareType(IconType type) {
    if (type == IconType.outlined) {
      MetaStorage.addMeta(context, kMaterialSymbolsOutlined);
    } else if (type == IconType.rounded) {
      MetaStorage.addMeta(context, kMaterialSymbolsRounded);
    } else if (type == IconType.sharp) {
      MetaStorage.addMeta(context, kMaterialSymbolsSharp);
    }
  }

  @override
  void didUpdateWidget(Icon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.icon != oldWidget.icon) {
      IconData icon = widget.icon;
      if (icon is NamedIconData) {
        controller.element.text = icon.name;
      }
    }
    if (widget._style != oldWidget._style) {
      Object? style = widget._style;
      if (style is IconStyle) {
        Map<String, String> sheet = style.css;
        for (var entry in sheet.entries) {
          controller.style.setProperty(entry.key, entry.value);
        }
        List<String> classNames =
            StyleSheet.classNames(context, style.runtimeType);
        IconType? type = style.type;
        if (type == null) {
          StyleSheetData? sheetData = StyleSheet.of(context);
          while (sheetData != null) {
            var sheet = sheetData.sheet;
            if (sheet.runtimeType == style.runtimeType) {
              var iconType = (sheet as IconStyle).type;
              if (iconType != null) {
                type = iconType;
                break;
              }
              if (!sheet.inherit) {
                break;
              }
            }
            sheetData = sheetData.parent;
          }
        }
        type ??= IconType.outlined;
        _prepareType(type);
        classNames.insert(0, type.className);
        if (!IterableEquality()
            .equals(controller.element.classes, classNames)) {
          controller.element.classes = classNames;
        }
      } else if (style is Type) {
        List<String> classNames = StyleSheet.classNames(context, style);
        StyleSheetData? sheetData = StyleSheet.of(context);
        IconType? foundType;
        while (sheetData != null) {
          var sheet = sheetData.sheet;
          if (sheet.runtimeType == style) {
            var iconType = (sheet as IconStyle).type;
            if (iconType != null) {
              foundType = iconType;
              break;
            }
            if (!sheet.inherit) {
              break;
            }
          }
          sheetData = sheetData.parent;
        }
        foundType ??= IconType.outlined;
        _prepareType(foundType);
        classNames.insert(0, foundType.className);
        if (!IterableEquality()
            .equals(controller.element.classes, classNames)) {
          controller.element.classes = classNames;
        }
      } else {
        StyleSheetData? sheetData = StyleSheet.of(context);
        IconType? foundType;
        while (sheetData != null) {
          var sheet = sheetData.sheet;
          if (sheet is IconStyle) {
            var iconType = sheet.type;
            if (iconType != null) {
              foundType = iconType;
              break;
            }
            if (!sheet.inherit) {
              break;
            }
          }
          sheetData = sheetData.parent;
        }
        foundType ??= IconType.outlined;
        _prepareType(foundType);
        List<String> singleton = [foundType.className];
        if (!IterableEquality().equals(controller.element.classes, singleton)) {
          controller.element.classes = singleton;
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
