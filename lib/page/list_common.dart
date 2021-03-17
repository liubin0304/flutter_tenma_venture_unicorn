import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListCommon {
  /// 默认Header
  static Widget createDefaultHeader() {
    return ClassicHeader(
      releaseText: '松开手刷新',
      refreshingText: '刷新中',
      completeText: '刷新完成',
      failedText: '刷新失败',
      idleText: '下拉刷新',
    );
  }

  /// 默认Footer
  static Widget createDefaultFooter() {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = Text("上拉加载更多");
        } else if (mode == LoadStatus.loading) {
          body = CircularProgressIndicator();
        } else if (mode == LoadStatus.failed) {
          body = Text("加载失败，点击重试");
        } else if (mode == LoadStatus.canLoading) {
          body = Text("释放以加载更多");
        } else {
          body = Text("没有更多的数据");
        }
        return Container(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
  }
}
