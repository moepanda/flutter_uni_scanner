import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_uni_scanner/flutter_uni_scanner.dart';

///app入口
void main() {
  runApp(MyApp());
}

///首页
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

///状态class
class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  ///初始化页面状态
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  ///获取平台版本号
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterUniScanner.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (mounted) setState(() {_platformVersion = platformVersion;});

  }

  ///重写build方法
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Running on: $_platformVersion'),
        ),
        body: Center(
          child: InkWell(
            onTap: () async{
              Map map = await FlutterUniScanner.startScan;
              print("扫描结果为:"+map['code']);
            },
            child: Text("Start Scan",style: TextStyle(fontSize: 18, color: Colors.black),),
          ),
        ),
      ),
    );
  }
}
