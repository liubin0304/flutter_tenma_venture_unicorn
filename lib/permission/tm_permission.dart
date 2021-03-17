import 'package:permission_handler/permission_handler.dart';

/// 权限
/// 使用具体权限需要在原生工程里面进行配置，详见：https://github.com/Baseflow/flutter-permission-handler
class TMPermission {
  factory TMPermission() => _getInstance();

  static TMPermission _instance;

  static TMPermission _getInstance() {
    if (_instance == null) {
      _instance = TMPermission._init();
    }
    return _instance;
  }

  TMPermission._init() {
    print("TMPermission._init");
  }

  /// 请求权限，按需请求
  Future<bool> requestPermission(TMPermissionGroup permissionGroup) async {
    if (permissionGroup == TMPermissionGroup.CAMERA) {
      return await Permission.camera.request().isGranted;
    } else if (permissionGroup == TMPermissionGroup.STORAGE) {
      return await Permission.storage.request().isGranted;
    } else if (permissionGroup == TMPermissionGroup.LOCATION) {
      return await Permission.location.request().isGranted;
    } else if (permissionGroup == TMPermissionGroup.CONTACTS) {
      return await Permission.contacts.request().isGranted;
    } else if (permissionGroup == TMPermissionGroup.MICROPHONE) {
      return await Permission.microphone.request().isGranted;
    } else if (permissionGroup == TMPermissionGroup.PHONE) {
      return await Permission.phone.request().isGranted;
    }
    return await Permission.unknown.request().isGranted;
  }

  /// 检测是否已有对应权限
  Future<bool> checkHasPermission(TMPermissionGroup permissionGroup) async {
    if (permissionGroup == TMPermissionGroup.CAMERA) {
      return await Permission.camera.isGranted;
    } else if (permissionGroup == TMPermissionGroup.STORAGE) {
      return await Permission.storage.isGranted;
    } else if (permissionGroup == TMPermissionGroup.LOCATION) {
      return await Permission.location.isGranted;
    } else if (permissionGroup == TMPermissionGroup.CONTACTS) {
      return await Permission.contacts.isGranted;
    } else if (permissionGroup == TMPermissionGroup.MICROPHONE) {
      return await Permission.microphone.isGranted;
    } else if (permissionGroup == TMPermissionGroup.PHONE) {
      return await Permission.phone.isGranted;
    }
    return await Permission.unknown.isGranted;
  }
}

enum TMPermissionGroup {
  CAMERA,
  STORAGE,
  LOCATION,
  CONTACTS,
  MICROPHONE,
  PHONE
}
