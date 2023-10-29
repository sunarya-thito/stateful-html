import 'framework.dart';
import 'key.dart';
import 'widgets.dart';

class Metadata {
  final String tag;
  final Map<String, String>? attributes;
  final String? text;

  const Metadata({
    this.tag = 'meta',
    this.attributes,
    this.text,
  });

  Metadata.meta({
    required String name,
    required String content,
    this.text,
  })  : tag = 'meta',
        attributes = {
          'name': name,
          'content': content,
        };

  Metadata.charset({
    required String charset,
    this.text,
  })  : tag = 'meta',
        attributes = {
          'charset': charset,
        };
}

class MetaStorage extends StatefulWidget {
  static void addMeta(BuildContext context, Metadata meta) {
    Metadatable? data = Metadatable.of(context);
    if (data != null) {
      data._addMeta(meta);
    }
  }

  static void removeMeta(BuildContext context, Metadata meta) {
    Metadatable? data = Metadatable.of(context);
    if (data != null) {
      data._removeMeta(meta);
    }
  }

  final Set<Metadata>? initialMeta;
  final Object? _children;
  const MetaStorage({
    Key? key,
    this.initialMeta,
    List<Widget>? children,
  })  : _children = children,
        super(key: key);

  const MetaStorage.single({
    Key? key,
    this.initialMeta,
    required Widget child,
  })  : _children = child,
        super(key: key);

  List<Widget> get children {
    if (_children == null) {
      return [];
    } else if (_children is Widget) {
      return [
        _children as Widget,
      ];
    } else {
      return _children as List<Widget>;
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _MetaStorageState();
  }
}

class _MetaStorageState extends State<MetaStorage> {
  late Set<Metadata> _meta;

  @override
  void initState() {
    super.initState();
    _meta = widget.initialMeta ?? {};
  }

  bool addMeta(Metadata meta) {
    bool added = _meta.add(meta);
    if (added) {
      setState(() {});
    }
    return added;
  }

  bool removeMeta(Metadata meta) {
    bool removed = _meta.remove(meta);
    if (removed) {
      setState(() {});
    }
    return removed;
  }

  @override
  List<Widget> buildChildren(BuildContext context) {
    return [
      ..._meta.map((meta) {
        return MetadataWidget(
          metadata: meta,
        );
      }).toList(),
      Metadatable(
          children: widget.children, addMeta: addMeta, removeMeta: removeMeta),
    ];
  }
}

class MetadataWidget extends StatefulWidget {
  final Metadata metadata;

  const MetadataWidget({
    Key? key,
    required this.metadata,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MetadataWidgetState();
  }
}

class _MetadataWidgetState extends State<MetadataWidget> {
  late HtmlController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HtmlController.tag(widget.metadata.tag);
    if (widget.metadata.attributes != null) {
      _controller.element.attributes = widget.metadata.attributes ?? {};
    }
    if (widget.metadata.text != null) {
      _controller.element.text = widget.metadata.text ?? '';
    }
  }

  @override
  void didUpdateWidget(MetadataWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.metadata.tag != oldWidget.metadata.tag) {
      _controller = HtmlController.tag(widget.metadata.tag);
    }
    if (widget.metadata.attributes != oldWidget.metadata.attributes) {
      _controller.element.attributes = widget.metadata.attributes ?? {};
    }
    if (widget.metadata.text != oldWidget.metadata.text) {
      _controller.element.text = widget.metadata.text ?? '';
    }
  }

  @override
  List<Widget> buildChildren(BuildContext context) {
    return [
      HtmlWidget(
        controller: _controller,
      ),
    ];
  }
}

class Metadatable extends DataWidget {
  static Metadatable? of(BuildContext context) {
    return context.lookUpData<Metadatable>();
  }

  final bool Function(Metadata widget) _addMeta;
  final bool Function(Metadata widget) _removeMeta;

  const Metadatable({
    super.key,
    required super.children,
    required bool Function(Metadata widget) addMeta,
    required bool Function(Metadata widget) removeMeta,
  })  : _addMeta = addMeta,
        _removeMeta = removeMeta;

  @override
  bool updateShouldNotify(covariant Metadatable old) {
    return _addMeta != old._addMeta || _removeMeta != old._removeMeta;
  }
}
