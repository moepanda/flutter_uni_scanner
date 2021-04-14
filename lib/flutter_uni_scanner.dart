import 'dart:async';

import 'package:flutter/services.dart';

class FlutterUniScanner {
  static const String PLUGIN_NAME = "com.moepanda00.flutter_uni_scanner";

  static const MethodChannel _channel = const MethodChannel(PLUGIN_NAME);

  static Future<Map> startScan({String imagePath,String tipText}) async {
    Map arguments = {"imagePath":imagePath,"tipText":tipText};
    final Map result = await _channel.invokeMethod('startScan',arguments);
    return result;
  }
}
