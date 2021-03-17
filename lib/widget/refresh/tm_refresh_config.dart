import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 下拉刷新配置项
class TMRefreshConfig {
  final RefreshController controller;
  final Widget child;

  final Widget header;
  final Widget footer;

  final VoidCallback onRefresh;
  final VoidCallback onLoading;

  final bool enablePullDown;
  final bool enablePullUp;

  const TMRefreshConfig({
    @required this.controller,
    @required this.child,
    this.header,
    this.footer,
    this.onRefresh,
    this.onLoading,
    this.enablePullDown = true,
    this.enablePullUp = true,
  });
}
