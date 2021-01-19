import 'package:flutter/material.dart';

class TMAppTitleBarConfig {
  // N是无，C自定义布局，I图片，E文本框，T文本
  static const int TITLE_BAR_STYLE_NCN = 1;
  static const int TITLE_BAR_STYLE_NTN = 2;
  static const int TITLE_BAR_STYLE_ITN = 3;
  static const int TITLE_BAR_STYLE_ITT = 4;
  static const int TITLE_BAR_STYLE_ITI = 5;
  static const int TITLE_BAR_STYLE_TTI = 6;
  static const int TITLE_BAR_STYLE_TTT = 7;
  static const int TITLE_BAR_STYLE_IEI = 8;
  static const int TITLE_BAR_STYLE_IET = 9;
  static const int TITLE_BAR_STYLE_IEN = 10;
  static const int TITLE_BAR_STYLE_NEN = 11;
  static const int TITLE_BAR_STYLE_CEC = 12;
  static const int TITLE_BAR_STYLE_NET = 13;
  static const int TITLE_BAR_STYLE_NEI = 14;
}

/// 标题栏
class TMAppTitleBar extends StatefulWidget implements PreferredSizeWidget {
  // 风格
  final int style;

  // 高度
  final double height;

  // 背景颜色
  final Color backgroundColor;

  // 自定义
  final Widget rightCustom;
  final Widget centerCustom;
  final Widget leftCustom;

  // 左布局
  final String leftText;
  final String leftAssetName;
  final Icon leftIcon;
  final ImageProvider leftImageProvider;
  final Function leftClick;

  // 中间布局
  final String centerTitle;

  // 右侧布局
  final String rightText;

  TMAppTitleBar({
    this.style = TMAppTitleBarConfig.TITLE_BAR_STYLE_ITN,
    this.height = kToolbarHeight,
    this.backgroundColor = Colors.blueAccent,
    this.leftCustom,
    this.centerCustom,
    this.rightCustom,
    this.leftText,
    this.leftAssetName,
    this.leftIcon,
    this.leftImageProvider,
    this.leftClick,
    this.centerTitle,
    this.rightText,
  });

  @override
  State<StatefulWidget> createState() {
    return new _TMAppTitleBarState();
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}

class _TMAppTitleBarState extends State<TMAppTitleBar> {
  static const int LEFT_TYPE_NONE = 0;
  static const int LEFT_TYPE_TEXT = 1;
  static const int LEFT_TYPE_IMAGE = 2;
  static const int LEFT_TYPE_CUSTOM = 3;

  static const int RIGHT_TYPE_NONE = 0;
  static const int RIGHT_TYPE_TEXT = 1;
  static const int RIGHT_TYPE_IMAGE = 2;
  static const int RIGHT_TYPE_CUSTOM = 3;

  static const int CENTER_TYPE_NONE = 0;
  static const int CENTER_TYPE_TEXT = 1;
  static const int CENTER_TYPE_EDIT = 2;
  static const int CENTER_TYPE_CUSTOM = 3;

  int leftType;
  int centerType;
  int rightType;

  @override
  void initState() {
    super.initState();

    buildType();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.backgroundColor,
      leading: buildLeftWidget(),
      title: buildCenterWidget(),
      actions: buildRightWidget(),
    );
  }

  void buildType() {
    if (widget.style == TMAppTitleBarConfig.TITLE_BAR_STYLE_NCN) {
      leftType = LEFT_TYPE_NONE;
      centerType = CENTER_TYPE_CUSTOM;
      rightType = RIGHT_TYPE_NONE;
    } else if (widget.style == TMAppTitleBarConfig.TITLE_BAR_STYLE_NTN) {
      leftType = LEFT_TYPE_NONE;
      centerType = CENTER_TYPE_TEXT;
      rightType = RIGHT_TYPE_NONE;
    } else if (widget.style == TMAppTitleBarConfig.TITLE_BAR_STYLE_ITN) {
      leftType = LEFT_TYPE_IMAGE;
      centerType = CENTER_TYPE_TEXT;
      rightType = RIGHT_TYPE_NONE;
    } else if (widget.style == TMAppTitleBarConfig.TITLE_BAR_STYLE_ITT) {
      leftType = LEFT_TYPE_IMAGE;
      centerType = CENTER_TYPE_TEXT;
      rightType = RIGHT_TYPE_TEXT;
    } else if (widget.style == TMAppTitleBarConfig.TITLE_BAR_STYLE_ITI) {
      leftType = LEFT_TYPE_IMAGE;
      centerType = CENTER_TYPE_TEXT;
      rightType = RIGHT_TYPE_IMAGE;
    } else if (widget.style == TMAppTitleBarConfig.TITLE_BAR_STYLE_TTT) {
      leftType = LEFT_TYPE_TEXT;
      centerType = CENTER_TYPE_TEXT;
      rightType = RIGHT_TYPE_TEXT;
    } else if (widget.style == TMAppTitleBarConfig.TITLE_BAR_STYLE_IEI) {
      leftType = LEFT_TYPE_IMAGE;
      centerType = CENTER_TYPE_EDIT;
      rightType = RIGHT_TYPE_IMAGE;
    } else if (widget.style == TMAppTitleBarConfig.TITLE_BAR_STYLE_IET) {
      leftType = LEFT_TYPE_IMAGE;
      centerType = CENTER_TYPE_EDIT;
      rightType = RIGHT_TYPE_TEXT;
    } else if (widget.style == TMAppTitleBarConfig.TITLE_BAR_STYLE_IEN) {
      leftType = LEFT_TYPE_IMAGE;
      centerType = CENTER_TYPE_EDIT;
      rightType = RIGHT_TYPE_NONE;
    } else if (widget.style == TMAppTitleBarConfig.TITLE_BAR_STYLE_NEN) {
      leftType = LEFT_TYPE_NONE;
      centerType = CENTER_TYPE_EDIT;
      rightType = RIGHT_TYPE_NONE;
    } else if (widget.style == TMAppTitleBarConfig.TITLE_BAR_STYLE_CEC) {
      leftType = LEFT_TYPE_CUSTOM;
      centerType = CENTER_TYPE_EDIT;
      rightType = RIGHT_TYPE_CUSTOM;
    } else if (widget.style == TMAppTitleBarConfig.TITLE_BAR_STYLE_NET) {
      leftType = LEFT_TYPE_NONE;
      centerType = CENTER_TYPE_EDIT;
      rightType = RIGHT_TYPE_TEXT;
    } else if (widget.style == TMAppTitleBarConfig.TITLE_BAR_STYLE_NEI) {
      leftType = LEFT_TYPE_NONE;
      centerType = CENTER_TYPE_EDIT;
      rightType = RIGHT_TYPE_IMAGE;
    }
  }

  /// 构建左侧布局
  Widget buildLeftWidget() {
    if (leftType == LEFT_TYPE_NONE) {
      return buildNoneWidget();
    } else if (leftType == LEFT_TYPE_CUSTOM) {
      return widget.leftCustom ?? buildNoneWidget();
    } else if (leftType == LEFT_TYPE_TEXT) {
      return Container(
        height: widget.height,
        child: Center(
          child: Text(
            widget.leftText,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      );
    } else if (leftType == LEFT_TYPE_IMAGE) {
      if (widget.leftIcon != null) {
        return Container(
          height: widget.height,
          child: IconButton(icon: widget.leftIcon, onPressed: widget.leftClick),
        );
      } else if (widget.leftAssetName != null) {
        return GestureDetector(
          child: Container(
            height: widget.height,
            alignment: Alignment.center,
            child: Image(
              width: 20,
              height: 20,
              image: AssetImage(widget.leftAssetName),
            ),
          ),
          onTap: widget.leftClick,
        );
      } else if (widget.leftImageProvider != null) {
        return GestureDetector(
          child: Container(
            height: widget.height,
          ),
          onTap: widget.leftClick,
        );
      }

      return buildNoneWidget();
    }

    return buildNoneWidget();
  }

  /// 构建中间布局
  Widget buildCenterWidget() {
    if (centerType == CENTER_TYPE_NONE) {
      return buildNoneWidget();
    } else if (centerType == CENTER_TYPE_TEXT) {
      return Center(
        child: Text(
          widget.centerTitle,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      );
    }
    return buildNoneWidget();
  }

  /// 构建右侧布局
  List<Widget> buildRightWidget() {
    List<Widget> widgets = new List();

    if (rightType == RIGHT_TYPE_NONE) {
      widgets.add(buildNoneWidget());
    } else if (rightType == RIGHT_TYPE_TEXT) {
      Widget rightWidget = Container(
        height: widget.height,
        padding: EdgeInsets.only(left: 5, right: 15),
        child: Center(
          child: Text(
            widget.rightText,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      );

      widgets.add(rightWidget);
    } else {
      widgets.add(buildNoneWidget());
    }

    return widgets;
  }

  Widget buildNoneWidget() {
    return Container(
      width: kToolbarHeight > widget.height ? widget.height : kToolbarHeight,
      color: Colors.transparent,
      child: Divider(
        height: 0.1,
        color: Colors.transparent,
      ),
    );
  }
}
