import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';

class AppUsageSensor extends AwareSensor {

  static const MethodChannel _appUsageMethod =
      const MethodChannel('awareframework_appusage/method');

  static const EventChannel _onDataChangedStream =
      const EventChannel('awareframework_appusage/event_on_data_changed');

  static AppUsageData data = AppUsageData();

  static StreamController<AppUsageData> streamController =
      StreamController<AppUsageData>();

  AppUsageSensor() : super(null);
  AppUsageSensor.init(AppUsageSensorConfig config) : super(config) {
    super.setMethodChannel(_appUsageMethod);
  }

  Stream<AppUsageData> get onDataChanged {
    streamController.close();
    streamController = StreamController<AppUsageData>();
    return streamController.stream;
  }

  @override
  Future<Null> start() {
    // listen data update on sensor itself
    super
        .getBroadcastStream(_onDataChangedStream, "on_data_changed")
        .map((dynamic event) =>
            AppUsageData.from(Map<String, dynamic>.from(event)))
        .listen((event) {
      data = event;
      if (!streamController.isClosed) {
        streamController.add(data);
      }
    });
    return super.start();
  }

  @override
  Future<Null> stop() {
    super.cancelBroadcastStream("on_data_changed");
    return super.stop();
  }
}

class AppUsageSensorConfig extends AwareSensorConfig {
  int interval = 10000;
  List<String> usageAppDisplaynames = [""];
  List<int> usageAppEventTypes = [];

  AppUsageSensorConfig();
  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}
///
/// This class converts sensor data that is Map<String,dynamic> format, to a
/// sensor data object.
///
class AppUsageData extends AwareData {
  AppUsageData() : this.from({});
  String packageName = "";
  String eventType = "";
  int timestamp = 0;
  int timezone = 0;

  AppUsageData.from(Map<String, dynamic>? data) : super(data ?? {}) {
    if (data != null) {
      packageName = data["packageName"] ?? "";
      timestamp = data["timeStamp"] ?? 0;
      timezone = data["timeZone"] ?? 0;
      switch(data["eventType"]){
        case 1:
          eventType = "ACTIVITY_RESUMED";
          break;
        case 2:
          eventType = "ACTIVITY_PAUSED";
          break;

      }
    }
  }
}