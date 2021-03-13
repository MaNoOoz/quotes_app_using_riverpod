


import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

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
  static Future<bool> OnWillPop(BuildContext context) async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Expanded(child: Text('Are you sure?')),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }

}
