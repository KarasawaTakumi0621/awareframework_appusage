import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';

/// The accelerometer measures the acceleration applied to the sensor
/// built-in into the device, including the force of gravity.
///
/// Your can initialize this class by the following code.
/// ```dart
/// var sensor = AccelerometerSensor();
/// ```
///
/// If you need to initialize the sensor with configurations,
/// you can use the following code instead of the above code.
/// ```dart
/// var config =  AccelerometerSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
///
/// var sensor = AccelerometerSensor.init(config);
/// ```
///
/// Each sub class of AwareSensor provides the following method for controlling
/// the sensor:
/// - `start()`
/// - `stop()`
/// - `enable()`
/// - `disable()`
/// - `sync()`
/// - `setLabel(String label)`
///
/// `Stream<AccelerometerData>` allow us to monitor the sensor update
/// events as follows:
///
/// ```dart
/// sensor.onDataChanged.listen((data) {
///   print(data)
/// }
/// ```
///
/// In addition, this package support data visualization function on Cart Widget.
/// You can generate the Cart Widget by following code.
/// ```dart
/// var card = AccelerometerCard(sensor: sensor);
/// ```
class AppUsageSensor extends AwareSensor {
  /// Accelerometer Method Channel
  static const MethodChannel _appUsageMethod =
      const MethodChannel('awareframework_appusage/method');

  /// Accelerometer Event Channel
  // static const EventChannel  _accelerometerStream = const EventChannel('awareframework_accelerometer/event');

  static const EventChannel _onDataChangedStream =
      const EventChannel('awareframework_appusage/event_on_data_changed');

  static AppUsageData data = AppUsageData();

  static StreamController<AppUsageData> streamController =
      StreamController<AppUsageData>();

  /// Init Accelerometer Snew AppUsageSensoensor without a configuration file
  ///
  /// ```dart
  /// var sensor = AccelerometerSensor.init(null);
  /// ```
  AppUsageSensor() : super(null);

  /// Init Accelerometer Sensor with AccelerometerSensorConfig
  ///
  /// ```dart
  /// var config =  AccelerometerSensorConfig();
  /// config
  ///   ..debug = true
  ///   ..frequency = 100;
  ///
  /// var sensor = AccelerometerSensor.init(config);
  /// ```
  AppUsageSensor.init(AppUsageSensorConfig config) : super(config) {
    super.setMethodChannel(_appUsageMethod);
  }

  /// An event channel for monitoring sensor events.
  ///
  /// `Stream<AccelerometerData>` allow us to monitor the sensor update
  /// events as follows:
  ///
  /// ```dart
  /// sensor.onDataChanged.listen((data) {
  ///   print(data)
  /// }
  ///
  /// [Creating Streams](https://www.dartlang.org/articles/libraries/creating-streams)
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

/// A configuration class of AccelerometerSensor
///
/// You can initialize the class by following code.
///
/// ```dart
/// var config =  AccelerometerSensorConfig();
/// config
///   ..debug = true
///   ..frequency = 100;
/// ```
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

/// A data model of AccelerometerSensor
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
//
//
// int timestamp = 0;
// String deviceId = "";
// String label = "";
// int timezone = 0;
// String os = "";
// int jsonVersion = 0;
//
// AwareData(Map<String, dynamic> data) {
//   deviceId = data["deviceId"] ?? "";
//   timestamp = data["timestamp"] ?? 0;
//   label = data["label"] ?? "";
//   timezone = data["timezone"] ?? 0;
//   os = data["os"] ?? "";
//   jsonVersion = data["jsonVersion"] ?? 0;
//   source = data;
