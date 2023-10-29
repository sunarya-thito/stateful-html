import 'dart:async';
import 'dart:html' as html;

import 'foundation.dart';

typedef TickerCallback = void Function(Duration elapsed);

abstract class TickerProvider {
  Ticker createTicker(TickerCallback onTick);
}

class Ticker {
  TickerFuture? _future;
  bool _muted = false;
  Duration? _startTime;
  int? _animationId;
  final TickerCallback _onTick;

  Ticker(this._onTick);

  bool get isActive => _future != null;
  bool get muted => _muted;
  bool get scheduled => _animationId != null;

  bool get _shouldScheduleTick => !muted && isActive && !scheduled;

  TickerFuture start() {
    _future = TickerFuture._();
    if (_shouldScheduleTick) {
      scheduleTick();
    }
    _startTime = Duration(milliseconds: DateTime.now().millisecondsSinceEpoch);
    return _future!;
  }

  void scheduleTick() {
    _animationId = html.window.requestAnimationFrame(_tick);
  }

  void _tick(num timestamp) {
    if (_shouldScheduleTick) {
      scheduleTick();
    } else {
      _animationId = null;
    }
    Duration elapsed =
        Duration(milliseconds: DateTime.now().millisecondsSinceEpoch) -
            _startTime!;
    _onTick(elapsed);
  }
}

class TickerFuture implements Future<void> {
  final Completer<void> _primaryCompleter = Completer<void>();
  Completer<void>? _secondaryCompleter;
  bool? _completed = false;

  TickerFuture._();

  TickerFuture.complete() {
    _complete();
  }

  void _complete() {
    assert(_completed == null);
    _completed = true;
    _primaryCompleter.complete();
    _secondaryCompleter?.complete();
  }

  void _cancel(Ticker ticker) {
    assert(_completed == null);
    _completed = false;
    _secondaryCompleter?.completeError(TickerCanceled(ticker));
  }

  void whenCompleteOrCancel(VoidCallback callback) {
    void thunk(dynamic value) {
      callback();
    }

    orCancel.then(thunk, onError: thunk);
  }

  Future<void> get orCancel {
    if (_secondaryCompleter == null) {
      _secondaryCompleter = Completer<void>();
      if (_completed != null) {
        if (_completed!) {
          _secondaryCompleter!.complete();
        } else {
          _secondaryCompleter!.completeError(TickerCanceled());
        }
      }
    }
    return _secondaryCompleter!.future;
  }

  @override
  Stream<void> asStream() {
    return _primaryCompleter.future.asStream();
  }

  @override
  Future<void> catchError(Function onError,
      {bool Function(Object error)? test}) {
    return _primaryCompleter.future.catchError(onError, test: test);
  }

  @override
  Future<R> then<R>(FutureOr<R> Function(void value) onValue,
      {Function? onError}) {
    return _primaryCompleter.future.then(onValue, onError: onError);
  }

  @override
  Future<void> timeout(Duration timeLimit,
      {FutureOr<void> Function()? onTimeout}) {
    return _primaryCompleter.future.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<void> whenComplete(FutureOr<void> Function() action) {
    return _primaryCompleter.future.whenComplete(action);
  }
}

class TickerCanceled implements Exception {
  final Ticker? ticker;
  TickerCanceled([this.ticker]);

  @override
  String toString() {
    if (ticker == null) {
      return 'This ticker was canceled before ever completing.';
    }
    return 'This ticker was canceled: $ticker';
  }
}
