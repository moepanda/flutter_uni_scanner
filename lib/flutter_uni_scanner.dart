
import 'dart:async';

import 'package:flutter/services.dart';

class FlutterUniScanner {

  static const String PLUGIN_NAME = "com.moepanda00.flutter_uni_scanner";

  static const MethodChannel _channel = const MethodChannel(PLUGIN_NAME);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<Map> get startScan async {
    final Map result = await _channel.invokeMethod('startScan');
    return result;
  }

}
