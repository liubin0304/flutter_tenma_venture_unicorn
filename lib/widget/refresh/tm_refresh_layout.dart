import 'package:flutter/material.dart';
import 'package:flutter_tenma_venture_unicorn/page/list_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'tm_refresh_config.dart';

class TMRefreshLayout extends StatefulWidget {
  final TMRefreshConfig config;

  @override
  State<StatefulWidget> createState() {
    return _TMRefreshLayoutState();
  }

  const TMRefreshLayout({
    Key key,
    @required this.config,
  }) : super(key: key);
}

class _TMRefreshLayoutState extends State<TMRefreshLayout> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: widget.config.enablePullDown,
      enablePullUp: widget.config.enablePullUp,
      header: widget.config.header ?? ListCommon.createDefaultHeader(),
      footer: widget.config.footer ?? ListCommon.createDefaultFooter(),
      onRefresh: widget.config.onRefresh ?? _onRefresh,
      onLoading: widget.config.onLoading ?? _onLoading,
      controller: widget.config.controller,
      child: widget.config.child,
    );
  }

  _onRefresh() {
    widget.config.controller.refreshCompleted();
    widget.config.controller.loadComplete();
  }

  _onLoading() {
    widget.config.controller.refreshCompleted();
    widget.config.controller.loadComplete();
  }
}
