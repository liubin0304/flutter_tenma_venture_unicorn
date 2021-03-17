import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

/// 路由管理器
class TMRouter {
  FluroRouter router;

  factory TMRouter() => _getInstance();

  static TMRouter _instance;

  static TMRouter _getInstance() {
    if (_instance == null) {
      _instance = TMRouter._init();
    }
    return _instance;
  }

  TMRouter._init() {
    print("TMRouter._init");
  }

  init(Map<String, Handler> routes,
      {TransitionType transitionType,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) async {
    final router = FluroRouter();
    this.router = router;
    // 配置未找到匹配时的路由
    _configNotFoundHandler(router);
    // 配置用户自定义的路由
    defineRoutes(routes,
        transitionType: transitionType,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder);
  }

  /// 返回上一级界面
  pop(BuildContext context) {
    router.pop(context);
  }

  /// 跳转界面
  /// 对参数进行encode，解决参数中有特殊字符，影响fluro路由匹配
  Future navigateTo(
    BuildContext context,
    String path, {
    Map<String, dynamic> params,
    TransitionType transition = TransitionType.native,
    bool replace = false,
    bool clearStack = false,
  }) {
    String query = "";
    if (params != null) {
      int index = 0;
      for (var key in params.keys) {
        var value = Uri.encodeComponent('${params[key]}');

        if (index == 0) {
          query = "?";
        } else {
          query = query + "\&";
        }
        query += "$key=$value";
        index++;
      }
    }
    print('我是navigateTo传递的参数：$query');

    path = path + query;
    return router.navigateTo(context, path,
        transition: transition, replace: replace, clearStack: clearStack);
  }

  /// 定义单个路由
  defineRoute(String routePath,
      {@required Handler handler,
      TransitionType transitionType,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
    router.define(routePath,
        handler: handler,
        transitionType: transitionType,
        transitionDuration: transitionDuration,
        transitionBuilder: transitionBuilder);
  }

  /// 定义多个路由
  defineRoutes(Map<String, Handler> routes,
      {TransitionType transitionType,
      Duration transitionDuration = const Duration(milliseconds: 250),
      RouteTransitionsBuilder transitionBuilder}) {
    routes.forEach((key, value) {
      defineRoute(key,
          handler: value,
          transitionType: transitionType,
          transitionDuration: transitionDuration,
          transitionBuilder: transitionBuilder);
    });
  }

  /// 配置未找到匹配时的路由
  void _configNotFoundHandler(FluroRouter router) {
    router.notFoundHandler = _createNotFoundHandler();
  }

  /// 未找到匹配路由显示的界面
  Handler _createNotFoundHandler() {
    return Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!!");
      return Scaffold(
        body: Container(
          child: Center(
            child: Text("ROUTE WAS NOT FOUND !!!"),
          ),
        ),
      );
    });
  }
}
