import 'package:common_utils/common_utils.dart';

class TMLogger {
  factory TMLogger() => _getInstance();

  static TMLogger _instance;

  bool _initialized = false;

  static TMLogger _getInstance() {
    if (_instance == null) {
      _instance = TMLogger._init();
    }
    return _instance;
  }

  TMLogger._init() {
    print("TMLogger._init");
  }

  init(
      {String tag = "TMLogger", bool isDebug = false, int maxLen = 128}) async {
    if (!_initialized) {
      LogUtil.init(tag: tag, isDebug: isDebug, maxLen: maxLen);
      _initialized = true;
    }
  }

  static void e(Object object, {String tag}) {
    LogUtil.e(object, tag: tag);
  }

  static void v(Object object, {String tag}) {
    LogUtil.v(object, tag: tag);
  }
}
