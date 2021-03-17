import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tenma_venture_unicorn/page/tm_base_list_page.dart';
import 'package:flutter_tenma_venture_unicorn/permission/tm_permission.dart';
import 'package:flutter_tenma_venture_unicorn/utils/tm_toast.dart';

class BaseListExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BaseListExampleState();
  }
}

class _BaseListExampleState extends State<BaseListExample>
    with TMBaseListPageState {
  @override
  void initState() {
    super.initState();
    title = "页面标题";

    TMPermission()
        .checkHasPermission(TMPermissionGroup.STORAGE)
        .then((value) => {print(value)});
    TMPermission().requestPermission(TMPermissionGroup.STORAGE);
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }

  @override
  Widget itemBuild(BuildContext context, int position) {
    return Container(
      height: 48,
      child: Text("测试"),
    );
  }

  @override
  loadData(int pageIndex) {
    print("开始加载数据");
    TMToast.showLoadingToast();
    List data = new List();
    data.add("");
    data.add("");
    data.add("");
    data.add("");
    addAll(data);

    Future.delayed(Duration(milliseconds: 1000), () {
      TMToast.dismiss();
    });
  }

  @override
  Widget initChildView() {
    return GridView.builder(
        itemCount: dataList.length,
        //SliverGridDelegateWithFixedCrossAxisCount 构建一个横轴固定数量Widget
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //横轴元素个数
            crossAxisCount: 3,
            //纵轴间距
            mainAxisSpacing: 20.0,
            //横轴间距
            crossAxisSpacing: 10.0,
            //子组件宽高长度比例
            childAspectRatio: 1.0),
        itemBuilder: (BuildContext context, int index) {
          //Widget Function(BuildContext context, int index)
          return getItemContainer(dataList[index]);
        });
  }

  Widget getItemContainer(String item) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        item,
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
      color: Colors.blue,
    );
  }
}
