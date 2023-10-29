import 'framework.dart';
import 'key.dart';
import 'widgets.dart';

enum ConnectionState {
  none,
  waiting,
  active,
  done,
}

class AsyncSnapshot<T> {
  final ConnectionState connectionState;
  final T? data;
  final Object? error;
  final StackTrace? stackTrace;
  bool get hasData => data != null;
  bool get hasError => error != null;

  T get requiredData {
    if (hasData) {
      return data!;
    }
    if (hasError) {
      Error.throwWithStackTrace(error!, stackTrace!);
    }
    throw StateError('Snapshot has neither data nor error');
  }

  const AsyncSnapshot._(
      this.connectionState, this.data, this.error, this.stackTrace);

  const AsyncSnapshot.nothing()
      : this._(ConnectionState.none, null, null, null);

  const AsyncSnapshot.waiting()
      : this._(ConnectionState.waiting, null, null, null);

  const AsyncSnapshot.withData(ConnectionState connectionState, T data)
      : this._(connectionState, data, null, null);

  const AsyncSnapshot.withError(Object error, [StackTrace? stackTrace])
      : this._(ConnectionState.done, null, error, stackTrace);

  AsyncSnapshot<T> inState(ConnectionState connectionState) {
    return AsyncSnapshot<T>._(connectionState, data, error, stackTrace);
  }
}

typedef SingleFutureWidgetBuilder<T> = Widget Function(
    BuildContext context, AsyncSnapshot<T> snapshot);
typedef FutureWidgetBuilder<T> = List<Widget> Function(
    BuildContext context, AsyncSnapshot<T> snapshot);

class FutureBuilder<T> extends StatefulWidget {
  static const bool debugRethrowError = true;
  final Object _builder;
  final Future<T>? future;
  final T? initialData;

  const FutureBuilder.single({
    Key? key,
    required SingleFutureWidgetBuilder<T> builder,
    this.future,
    this.initialData,
  })  : _builder = builder,
        super(key: key);

  const FutureBuilder({
    Key? key,
    required FutureWidgetBuilder<T> builder,
    required this.future,
    this.initialData,
  })  : _builder = builder,
        super(key: key);

  List<Widget> builder(BuildContext context, AsyncSnapshot<T> snapshot) {
    if (_builder is SingleFutureWidgetBuilder<T>) {
      return [(_builder as SingleFutureWidgetBuilder<T>)(context, snapshot)];
    } else {
      return (_builder as FutureWidgetBuilder<T>)(context, snapshot);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _FutureBuilderState<T>();
  }
}

class _FutureBuilderState<T> extends State<FutureBuilder<T>> {
  Object? _activeCallbackIdentity;
  late AsyncSnapshot<T> _snapshot;

  @override
  void initState() {
    super.initState();
    _snapshot = widget.initialData == null
        ? AsyncSnapshot.nothing()
        : AsyncSnapshot.withData(ConnectionState.none, widget.initialData as T);
    _subscribe();
  }

  @override
  void didUpdateWidget(FutureBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.future != oldWidget.future) {
      if (_activeCallbackIdentity != null) {
        _unsubscribe();
        _snapshot = _snapshot.inState(ConnectionState.none);
      }
      _subscribe();
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.future != null) {
      final Object callbackIdentity = Object();
      widget.future!.then<void>((T data) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() {
            _snapshot = AsyncSnapshot.withData(ConnectionState.done, data);
          });
        }
      }, onError: (Object error, StackTrace stackTrace) {
        if (_activeCallbackIdentity == callbackIdentity) {
          setState(() {
            _snapshot = AsyncSnapshot.withError(error, stackTrace);
          });
        }
        assert(() {
          if (FutureBuilder.debugRethrowError) {
            Future<Object>.error(error, stackTrace);
          }
          return true;
        }());
      });

      if (_snapshot.connectionState != ConnectionState.done) {
        _snapshot = _snapshot.inState(ConnectionState.waiting);
      }
    }
  }

  void _unsubscribe() {
    _activeCallbackIdentity = null;
  }

  @override
  List<Widget> buildChildren(BuildContext context) {
    return widget.builder(context, _snapshot);
  }
}
