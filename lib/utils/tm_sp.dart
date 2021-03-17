import 'package:flustars/flustars.dart';

class TMSp {
  factory TMSp() => _getInstance();

  static TMSp _instance;

  bool _initialized = false;

  static TMSp _getInstance() {
    if (_instance == null) {
      _instance = TMSp._init();
    }
    return _instance;
  }

  TMSp._init() {
    print("TMSp._init");
  }

  init() async {
    if (!_initialized) {
      await SpUtil.getInstance();
      _initialized = true;
    }
  }

  /// string
  static Future<bool> putString(String key, String value) async {
    return SpUtil.putString(key, value);
  }

  static String getString(String key, {String defValue = ''}) {
    return SpUtil.getString(key, defValue: defValue);
  }

  /// int
  static Future<bool> putInt(String key, int value) async {
    return SpUtil.putInt(key, value);
  }

  static int getInt(String key, {int defValue = 0}) {
    return SpUtil.getInt(key, defValue: defValue);
  }

  /// bool
  static Future<bool> putBool(String key, bool value) async {
    return SpUtil.putBool(key, value);
  }

  static bool getBool(String key, {bool defValue = false}) {
    return SpUtil.getBool(key, defValue: defValue);
  }

  /// double
  static Future<bool> putDouble(String key, double value) async {
    return SpUtil.putDouble(key, value);
  }

  static double getDouble(String key, {double defValue = 0.0}) {
    return SpUtil.getDouble(key, defValue: defValue);
  }

  /// double
  static Future<bool> putObject(String key, Object value) async {
    return SpUtil.putObject(key, value);
  }

  static Object getObject(String key) {
    return SpUtil.getObject(key);
  }

  /// StringList
  static Future<bool> putStringList(String key, List<String> value) async {
    return SpUtil.putStringList(key, value);
  }

  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    return SpUtil.getStringList(key, defValue: defValue);
  }

  /// ObjectList
  static Future<bool> putObjectList(String key, List<Object> value) async {
    return SpUtil.putObjectList(key, value);
  }

  static List<Object> getObjectList(String key) {
    return SpUtil.getObjectList(key);
  }
}
