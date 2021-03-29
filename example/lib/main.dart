import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_uni_scanner/flutter_uni_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterUniScanner.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (mounted) setState(() {_platformVersion = platformVersion;});

  }

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
