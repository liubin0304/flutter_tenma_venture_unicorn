import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_tenma_venture_unicorn/permission/tm_permission.dart';
import 'package:path_provider/path_provider.dart';

/// 下载
/// iOS端配置：
/// 1、启用background mode
/// 2、添加 sqlite 依赖库
/// 3、设置 HTTP 请求支持
/// Android端配置：
/// <provider
///     android:name="vn.hunghd.flutterdownloader.DownloadedFileProvider"
///     android:authorities="${applicationId}.flutter_downloader.provider"
///     android:exported="false"
///     android:grantUriPermissions="true">
///     <meta-data
///         android:name="android.support.FILE_PROVIDER_PATHS"
///         android:resource="@xml/provider_paths"/>
/// </provider>
class TMDownloader {
  factory TMDownloader() => _getInstance();

  static TMDownloader _instance;

  bool _initialized = false;

  static TMDownloader _getInstance() {
    if (_instance == null) {
      _instance = TMDownloader._init();
    }
    return _instance;
  }

  TMDownloader._init() {
    print("TMDownloader._init");
  }

  init() async {
    if (!_initialized) {
      await FlutterDownloader.initialize();
      _initialized = true;
    }
  }

  /// 下载文件
  Future<String> downloadFile(BuildContext context,
      {@required String url,
      @required String savedDir,
      String fileName,
      Map<String, String> headers,
      bool showNotification = true,
      bool openFileFromNotification = true,
      bool requiresStorageNotLow = true}) async {
    if (await TMPermission()
        .requestPermission(TMPermissionGroup.STORAGE)) {
      // 权限获取成功
      var _localPath = (await _findLocalPath(context)) +
          (savedDir.startsWith("/") ? savedDir : "/$savedDir");
      final fileSavedDir = Directory(_localPath);
      // 判断下载路径是否存在
      bool hasExisted = await fileSavedDir.exists();
      // 不存在就新建路径
      if (!hasExisted) {
        fileSavedDir.create();
      }
      return await FlutterDownloader.enqueue(
          url: url,
          savedDir: fileSavedDir.path,
          fileName: fileName,
          showNotification: showNotification,
          openFileFromNotification: openFileFromNotification);
    } else {
      // 权限获取失败
      return "";
    }
  }

  /// 取消所有下载任务
  Future<Null> cancelAll() async {
    return FlutterDownloader.cancelAll();
  }

  /// 根据任务ID取消下载任务
  Future<Null> cancel({@required String taskId}) async {
    return FlutterDownloader.cancel(taskId: taskId);
  }

  /// 下载进度监听
  downloadProgress(Function downloadProgressCallback) {
    FlutterDownloader.registerCallback(downloadProgressCallback);
  }

  /// 获取存储路径
  Future<String> _findLocalPath(BuildContext context) async {
    // 因为Apple没有外置存储，所以第一步我们需要先对所在平台进行判断
    // 如果是android，使用getExternalStorageDirectory
    // 如果是iOS，使用getApplicationSupportDirectory
    final directory = Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    return directory.path;
  }
}
