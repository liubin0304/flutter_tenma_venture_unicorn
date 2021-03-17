import 'dart:async';
import 'dart:convert';

import 'package:example/base_list_example.dart';
import 'package:example/event/event.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tenma_venture_unicorn/database/tm_db_helper.dart';
import 'package:flutter_tenma_venture_unicorn/database/tm_field.dart';
import 'package:flutter_tenma_venture_unicorn/database/tm_insert_field.dart';
import 'package:flutter_tenma_venture_unicorn/database/tm_query_delete_field.dart';
import 'package:flutter_tenma_venture_unicorn/download/tm_downloader.dart';
import 'package:flutter_tenma_venture_unicorn/event/tm_event_bus.dart';
import 'package:flutter_tenma_venture_unicorn/routes/tm_router.dart';
import 'package:flutter_tenma_venture_unicorn/utils/tm_sp.dart';
import 'package:flutter_tenma_venture_unicorn/utils/tm_logger.dart';
import 'package:flutter_tenma_venture_unicorn/widget/refresh/tm_refresh_config.dart';
import 'package:flutter_tenma_venture_unicorn/widget/refresh/tm_refresh_layout.dart';
import 'package:flutter_tenma_venture_unicorn/widget/tm_app_title_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() async {
  // 初始化路由管理器
  Map<String, Handler> routesMap = new Map();
  routesMap['root'] = new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return Scaffold(
          body: Container(
            child: Center(
              child: Text("This is root!!"),
            ),
          ),
        );
      });

  routesMap['baseListExamplePage'] = new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return BaseListExample();
      });

  // 初始化路由
  await TMRouter().init(routesMap);

  // 初始化下载器
  await TMDownloader().init();

  // 初始化SP
  await TMSp().init();

  // 初始化Logger
  await TMLogger().init();

  // 初始化数据库
  await TMDbHelper().init();

  // 初始化EventBus
  await TMEventBus().init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      builder: (BuildContext context, Widget child) {
        /// 确保 loading 组件能覆盖在其他组件之上.
        return FlutterEasyLoading(child: child);
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  int _counter = 0;

  StreamSubscription streamSubscription;

  void _incrementCounter() async {
    // setState(() {
    //   // This call to setState tells the Flutter framework that something has
    //   // changed in this State, which causes it to rerun the build method below
    //   // so that the display can reflect the updated values. If we changed
    //   // _counter without calling setState(), then the build method would not be
    //   // called again, and so nothing would appear to happen.
    //   _counter++;
    // });

    // TMRouterHelper().navigateTo(context, "baseListExamplePage");

    // TMDownloaderHelper().downloadFile(context,
    //     url: "http://www.edusc.cn/uploadfile/2020/0424/20200424051744943.jpg",
    //     savedDir: "/TMDownloader");

    TMSp.putString("key", "value");
    TMLogger.e(TMSp.getString("key"));
    TMLogger.v(TMSp.getString("key"));

    // List<TMField> fields = new List();
    // fields.add(TMField("id", TMFieldType.INTEGER, isPrimaryKey: true));
    // fields.add(TMField("name", TMFieldType.TEXT));
    // fields.add(TMField("num", TMFieldType.REAL));
    // TMDbHelper().createTable("Test", fields);
    //
    // List<TMInsertField> insertFields = new List();
    // insertFields.add(TMInsertField("id", 1));
    // insertFields.add(TMInsertField("name", "zhangsan"));
    // insertFields.add(TMInsertField("num", 9527));
    // TMDbHelper().insert("Test", insertFields);

    // List<TMQueryDelField> whereArgs = new List();
    // whereArgs.add(TMQueryDelField(
    //   "name",
    //   "zhangsan11",
    //   TMQueryDelFieldType.EQ,
    // ));
    // // var queryResult = await TMDbHelper()
    // //     .query("Test", whereArgs: whereArgs, limit: 10, offset: 0);
    // var queryResult = await TMDbHelper().delete("Test", whereArgs: whereArgs);
    // print(jsonEncode(queryResult));

    List<TMQueryDelField> whereArgs = new List();

    List<TMInsertField> fields = new List();
    fields.add(TMInsertField("name", "zhangsan"));

    whereArgs.add(TMQueryDelField(
      "name",
      "zhangsan11",
      TMQueryDelFieldType.EQ,
    ));
    // var queryResult = await TMDbHelper()
    //     .query("Test", whereArgs: whereArgs, limit: 10, offset: 0);
    var queryResult =
    await TMDbHelper().update("Test", fields, whereArgs: whereArgs);
    print(jsonEncode(queryResult));

    TMEventBus.fireEvent(TestEvent());
  }

  @override
  void initState() {
    super.initState();

    TMDownloader().downloadProgress(downloadProgressCallback);

    streamSubscription = TMEventBus.addEvent<TestEvent>((event) => {
    print("event bus：$event");
    });
  }

  @override
  void dispose() {
    super.dispose();

    TMEventBus.cancelEvent(streamSubscription);
  }

  static void downloadProgressCallback(String id, DownloadTaskStatus status,
      int progress) {
    print("id = $id, status = $status, progress = $progress");
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      // appBar: AppBar(
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: Text(widget.title),
      // ),
      appBar: TMAppTitleBar(
        style: TMAppTitleBarConfig.TITLE_BAR_STYLE_TTT,
        leftIcon: Icon(Icons.add),
        centerTitle: widget.title,
        leftText: "左侧",
        rightText: "右侧",
      ),
      // body: TMRefreshLayout(
      //   controller: _refreshController,
      //   child: Center(
      //     // Center is a layout widget. It takes a single child and positions it
      //     // in the middle of the parent.
      //     child: Column(
      //       // Column is also a layout widget. It takes a list of children and
      //       // arranges them vertically. By default, it sizes itself to fit its
      //       // children horizontally, and tries to be as tall as its parent.
      //       //
      //       // Invoke "debug painting" (press "p" in the console, choose the
      //       // "Toggle Debug Paint" action from the Flutter Inspector in Android
      //       // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
      //       // to see the wireframe for each widget.
      //       //
      //       // Column has various properties to control how it sizes itself and
      //       // how it positions its children. Here we use mainAxisAlignment to
      //       // center the children vertically; the main axis here is the vertical
      //       // axis because Columns are vertical (the cross axis would be
      //       // horizontal).
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         Text(
      //           'You have pushed the button this many times:',
      //         ),
      //         Text(
      //           '$_counter',
      //           style: Theme.of(context).textTheme.headline4,
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

      body: TMRefreshLayout(
          config: TMRefreshConfig(
              controller: _refreshController,
              child: ListView.builder(
                  itemCount: 100,
                  itemBuilder: (BuildContext item, int position) {
                    return Container(
                        height: 48, child: Text(position.toString()));
                  }))),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
