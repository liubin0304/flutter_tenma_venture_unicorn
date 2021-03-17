import 'package:flutter/material.dart';
import 'package:flutter_tenma_venture_unicorn/config/tm_config.dart';
import 'package:flutter_tenma_venture_unicorn/routes/tm_router.dart';
import 'package:flutter_tenma_venture_unicorn/widget/refresh/tm_refresh_config.dart';
import 'package:flutter_tenma_venture_unicorn/widget/refresh/tm_refresh_layout.dart';
import 'package:flutter_tenma_venture_unicorn/widget/tm_app_title_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'list_common.dart';

/// 列表界面基类
mixin TMBaseListPageState<T extends StatefulWidget> on State<T> {
  /// 刷新控制器
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  /// 当前是否显示空布局
  bool isShowEmpty = false;

  /// 空布局
  Widget emptyView;

  /// 页面标题
  String title = "";

  /// 列表数据
  List dataList = new List();

  /// 加载数据索引
  int pageIndex = TMConfig.LIST_FIRST_PAGE;

  @override
  void initState() {
    super.initState();
    emptyView = initEmptyView();
    _refreshController = initRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: initAppBar(),
      body: createBody(),
    );
  }

  /// 创建内容Body
  Widget createBody() {
    if (isShowEmpty) {
      return emptyView ?? createDefaultEmptyView();
    }
    return TMRefreshLayout(
      config: TMRefreshConfig(
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          header: initRefreshHeader(),
          footer: initLoadingFooter(),
          enablePullDown: enablePullDown(),
          enablePullUp: enablePullUp(),
          child: isShowEmpty ? emptyView : initChildView(),
          controller: _refreshController),
    );
  }

  /// 列表控件（可以是ListView/GridView等等）
  Widget initChildView() {
    return ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int position) {
          return itemBuild(context, position);
        });
  }

  /// 标题栏
  TMAppTitleBar initAppBar() {
    return TMAppTitleBar(
      leftIcon: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      leftClick: () {
        TMRouter().pop(context);
      },
      centerTitle: title,
    );
  }

  /// 初始化刷新控制器
  RefreshController initRefreshController() {
    return RefreshController(initialRefresh: enableInitialRefresh());
  }

  /// 加载数据
  loadData(int pageIndex);

  /// 添加数据
  addAll(List data, {int index}) {
    isShowEmpty = false;
    if (pageIndex == TMConfig.LIST_FIRST_PAGE) {
      dataList.clear();

      if (data.isEmpty && enableEmptyView()) {
        isShowEmpty = true;
      }
    }
    dataList.addAll(data);

    _refreshController.refreshCompleted();
    _refreshController.loadComplete();

    if (dataList.isEmpty || data.length < TMConfig.LIST_PAGE_SIZE) {
      _refreshController.loadNoData();
    }

    setState(() {});
  }

  /// 替换数据
  replaceRange(int start, int end, List replacement) {
    dataList.replaceRange(start, end, replacement);
    setState(() {});
  }

  /// 清除数据
  clear() {
    dataList.clear();
    setState(() {});
  }

  _onRefresh() {
    pageIndex = TMConfig.LIST_FIRST_PAGE;
    loadData(pageIndex);
  }

  _onLoading() {
    pageIndex++;
    loadData(pageIndex);
  }

  /// 结束刷新
  finishRefresh() {
    _refreshController.refreshCompleted();
  }

  /// 结束加载
  finishLoading() {
    _refreshController.loadComplete();
  }

  /// 是否启用，初次自动加载，默认启用
  bool enableInitialRefresh() {
    return true;
  }

  /// 是否启用刷新，默认启用
  bool enablePullUp() {
    return true;
  }

  /// 是否启用加载，默认启用
  bool enablePullDown() {
    return true;
  }

  /// 是否启用无数据View，默认启用
  bool enableEmptyView() {
    return true;
  }

  /// 如果只是纯列表，复写此方法即可
  Widget itemBuild(BuildContext context, int position);

  /// 初始化刷新header
  Widget initRefreshHeader() {
    return ListCommon.createDefaultHeader();
  }

  /// 初始化加载footer
  Widget initLoadingFooter() {
    return ListCommon.createDefaultFooter();
  }

  /// 初始化无数据View
  Widget initEmptyView() {
    return createDefaultEmptyView();
  }

  /// 创建默认无数据View
  Widget createDefaultEmptyView() {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("images/ic_empty_core.png"),
              width: 152,
              height: 100,
            ),
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(top: 10),
              child: Text(
                "暂无数据，点击重新加载",
                style: TextStyle(fontSize: 16, color: Color(0xFFA2A4A8)),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        _onRefresh();
      },
    );
  }
}
