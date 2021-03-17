import 'dart:async';

import 'package:event_bus/event_bus.dart';

class TMEventBus {
  factory TMEventBus() => _getInstance();

  static TMEventBus _instance;

  bool _initialized = false;

  static EventBus _eventBus;

  static TMEventBus _getInstance() {
    if (_instance == null) {
      _instance = TMEventBus._init();
    }
    return _instance;
  }

  TMEventBus._init() {
    print("TMEventBus._init");
  }

  init() async {
    if (!_initialized) {
      _eventBus = EventBus();
      _initialized = true;
    }
  }

  /// 添加时间
  static StreamSubscription addEvent<T>(Function(dynamic event) eventCallback) {
    if (_eventBus == null) {
      throw Exception("EventBus not init!!");
    }
    StreamSubscription streamSubscription = _eventBus.on<T>().listen((event) {
      if (eventCallback != null) {
        eventCallback(event);
      }
    });

    return streamSubscription;
  }

  /// 取消事件
  static cancelEvent(StreamSubscription streamSubscription) {
    if (streamSubscription != null) {
      streamSubscription.cancel();
    }
  }

  /// 发送事件
  static fireEvent(dynamic event) {
    if (_eventBus == null) {
      throw Exception("EventBus not init!!");
    }
    _eventBus.fire(event);
  }
}
