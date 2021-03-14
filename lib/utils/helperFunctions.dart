import 'dart:developer';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class helperFunctions {
  static Future<bool> checkNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        log('connected');
        return true;
      }
      return false;
    } on SocketException catch (_) {
      log('not connected');
    }
  }

  static Future<bool> checkNetwork2() async {
    try {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.none) {
        Fluttertoast.showToast(
            msg: "لا يوجد إنترنت",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return true;
      } else if (result == ConnectivityResult.wifi) {
        Fluttertoast.showToast(
            msg: "متصل عن طريق الوايفاي",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        return true;
      }else if (result == ConnectivityResult.mobile){
        Fluttertoast.showToast(
            msg: "متصل عن طريق البيانات",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        return true;
      }
      return false;
    } on SocketException catch (_) {
      log('not connected');
      Fluttertoast.showToast(
          msg: "not connected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  static  checkNetwork3(result)  {
    try {
      if (result == ConnectivityResult.none) {
        Fluttertoast.showToast(
            msg: "لا يوجد إنترنت",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return true;
      } else if (result == ConnectivityResult.wifi) {
        Fluttertoast.showToast(
            msg: "متصل عن طريق الوايفاي",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }else if (result == ConnectivityResult.mobile){
        Fluttertoast.showToast(
            msg: "متصل عن طريق البيانات",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on SocketException catch (_) {
      log('not connected');
      Fluttertoast.showToast(
          msg: "not connected",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
