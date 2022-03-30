# awareframework_appusage
This plugin enables UsageStatsEvent data streaming, DB storage, storage on AWARE-micro server, etc. using AWARE Framework's Core infrastructure.
This plugin only works with the Android version.

## Install the plugin into project
1. Edit `pubspec.yaml`
```
dependencies:
    awareframework_appusage
```

2. Import the package on your source code
```
import 'package:awareframework_appusage/awareframework_appusage.dart';
import 'package:awareframework_core/awareframework_core.dart';
```

## Public functions
### appusage Sensor
- `start()`
- `stop()` 
- `sync(force: Boolean)`

### Configuration Keys
- `awareUsageAppNotificationTitle`: Title of the notification when the Foreground Service is activated
- `awareUsageAppNotificationDescription`: Description of the notification when the Foreground Service is activated
- `awareUsageAppNoticationId`: ID of the notification when the Foreground Service is activated
- `debug`: Boolean enable/disable logging to Logcat. (default = false)
- `label`: String Label for the data. (default = "")
- `deviceId`: String Id of the device that will be associated with the events and the sensor. (default = "")
- `dbEncryptionKey` Encryption key for the database. (default = null)
- `dbType`: Engine Which db engine to use for saving data. (default = 0) (0 = None, 1 = Room or Realm)
- `dbPath`: String Path of the database. (default = "aware_appusage")
- `dbHost`: String Host for syncing the database. (default = null)
- `interval`: Data samples to collect per msec (default = 10000)

## Data Representations
The data representations is different between Android and iOS. Following links provide the information.

### AppUsage Data
Contains the raw sensor data.
| Field           | Type   | Description                                                         |
| ---------       | ------ | ------------------------------------------------------------------- |
| eventTimestamp  | Long   | Unix Time for starting/stopping applications, etc.                  |
| appPackageName  | String | Application name of the event that occurred                         |
| eventType       | Int    | Event ID of UsageEvent. https://developer.android.com/reference/kotlin/android/app/usage/UsageEvents.Event |
| label           | String | Customizable label. Useful for data calibration or traceability     |
| deviceId        | String | AWARE device UUID                                                   |
| label           | String | Customizable label. Useful for data calibration or traceability     |
| timestamp       | Long   | unixtime milliseconds since 1970                                    |
| timezone        | Int    | Raw timezone offset of the device                              |
| os              | String | Operating system of the device (ex. android)                        |

## Example usage
```dart
var config = AppUsageSensorConfig();
    config.usageAppDisplaynames = ["com.twitter.android", "com.facebook.orca", "com.facebook.katana", "com.instagram.android", "jp.naver.line.android", "com.ss.android.ugc.trill"];
widget.sensor = new AppUsageSensor.init(config);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin Example App'),
        ),
        body: Column(
          children: [
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

```

## License
Copyright (c) 2021 AWARE Mobile Context Instrumentation Middleware/Framework (http://www.awareframework.com)

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LI
CENSE-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
