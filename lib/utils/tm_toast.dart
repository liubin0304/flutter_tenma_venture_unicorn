import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum TMToastGravity { TOP, BOTTOM, CENTER }

class TMToast {
  static showBottomToast(String msg) {
    TMToast.showToast(msg, TMToastGravity.BOTTOM);
  }

  static showCenterToast(String msg) {
    TMToast.showToast(msg, TMToastGravity.CENTER);
  }

  static showToast(String msg, TMToastGravity toastGravity,
      {int duration = 2}) {
    EasyLoading.dismiss();
    ToastGravity location;
    if (toastGravity == TMToastGravity.TOP) {
      location = ToastGravity.TOP;
    } else if (toastGravity == TMToastGravity.BOTTOM) {
      location = ToastGravity.BOTTOM;
    } else {
      location = ToastGravity.CENTER;
    }
    Fluttertoast.showToast(
        msg: msg,
        gravity: location,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        timeInSecForIosWeb: 2);
  }

  static showErrorToast(String msg) {
    TMToast.showToast(msg, TMToastGravity.CENTER);
  }

  static showLoadingToast({String message = ""}) {
    EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.circle;
    EasyLoading.show(status: message.isEmpty ? '加载中...' : message);
  }

  static dismiss() {
    EasyLoading.dismiss();
  }
}
