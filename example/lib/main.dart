import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_appusage/awareframework_appusage.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:permission_handler/permission_handler.dart';


void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  late AppUsageSensor sensor;
  AppUsageData data = AppUsageData();
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool sensorState = true;


  @override
  void initState() {
    super.initState();

    var config = AppUsageSensorConfig();
    // config.usageAppDisplaynames = ["com.twitter.android", "com.facebook.orca", "com.facebook.katana", "com.instagram.android", "jp.naver.line.android", "com.ss.android.ugc.trill"];
    // config.usageAppEventTypes = [1,2];

    // // init sensor without a context-card
    widget.sensor = new AppUsageSensor.init(config);

    // card = new AccelerometerCard(sensor: sensor,);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin Example App'),
        ),
        body: Column(
          children: [
            Text("最新のデータ"),

            Text("packageName: ${widget.data.packageName}"),
            Text("eventType: ${widget.data.eventType}"),
            Text("Timestamp: ${widget.data.timestamp}"),
            Text("TimeZone: ${widget.data.timezone}"),

            TextButton(
                onPressed: () {
                  widget.sensor.start();
                  widget.sensor.onDataChanged.listen((data) {
                    setState(() {
                      widget.data = data;
                    });
                  });
                },
                child: Text("Start")),
            TextButton(
                onPressed: () {
                  widget.sensor.stop();
                },
                child: Text("Stop")),
            TextButton(
                onPressed: () {
                  widget.sensor.sync();
                },
                child: Text("Sync")),
          ],
        ),
      ),
    );
  }
}


//
// void main() => runApp(new MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late AppUsageSensor sensor;
//   late AppUsageSensorConfig config;
//
//   @override
//   void initState() {
//     super.initState();
//
//     config = AppUsageSensorConfig()..debug = true;
//
//     sensor = new AppUsageSensor.init(config);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new Scaffold(
//         appBar: new AppBar(
//           title: const Text('Plugin Example App'),
//         ),
//         body: Text('App Usage'),
//       ),
//     );
//   }
// }
