import 'dart:async';

import 'package:rxdart/rxdart.dart';

abstract class Bloc<E, S> {
  final _inputController = BehaviorSubject<E>();
  dynamic Function(E) get dispatch => _inputController.add;
  StreamSink<E> get sink => _inputController.sink;

  final _outputController = BehaviorSubject<S>();
  Stream<S> get state => _outputController.stream;

  S currentState;

  void dispose() {
    _inputController?.close();
    _outputController?.close();
  }
  
  S getInitialState();
  Future<void> mapEventToState(E event);

  Bloc() {
    _inputController.listen(_handleInput);
    currentState = getInitialState();
    _outputController.add(currentState);
  }

  void _handleInput(E event) async {
    await mapEventToState(event);
    _outputController.add(currentState);
    print(event.runtimeType);
  }
}