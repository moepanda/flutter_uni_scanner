import 'package:flutter/material.dart';
import 'package:flutter_uni_scanner/flutter_uni_scanner.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Test Scan'),
        ),
        body: Center(
          child: InkWell(
            onTap: () async{
              Map map = await FlutterUniScanner.startScan(tipText: "测试文字");
              print(map.toString());
            },
            child: Text("Start Scan",style: TextStyle(fontSize: 18, color: Colors.black),),
          ),
        ),
      ),
    );
  }

}
