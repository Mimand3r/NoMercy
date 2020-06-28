import 'dart:async';
import 'package:NoMercySender/ModuleGPS/gps_manager.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:geolocator/geolocator.dart';

import 'ModuleGPS/firebase_gps_writer.dart';

void fgFunction() {
  if (!ForegroundService.isIsolateCommunicationSetup)
    ForegroundService.setupIsolateCommunication((_) {});

  ForegroundService.sendToPort("");
}

var locator = Geolocator();

class ForegroundServiceManager {
  ForegroundServiceManager._internal() {
    ForegroundService.foregroundServiceIsStarted()
        .then((value) => isRunning = value);
  }
  static ForegroundServiceManager _instance =
      ForegroundServiceManager._internal();
  static ForegroundServiceManager get instance => _instance;

  var _streamCtrlr = StreamController.broadcast();
  var _isRunning = false;
  bool get isRunning => _isRunning;
  set isRunning(bool value) {
    _isRunning = value;
    _streamCtrlr.add(value);
  }

  Stream get isRunningStream => _streamCtrlr.stream;
  final frequency = 5; // in seconds

  Future startForegroundService() async {
    if (!isRunning) {
      await ForegroundService.setServiceIntervalSeconds(frequency);

      //necessity of editMode is dubious (see function comments)
      await ForegroundService.notification.startEditMode();

      await ForegroundService.notification
          .setTitle("Example Title: ${DateTime.now()}");
      await ForegroundService.notification
          .setText("Example Text: ${DateTime.now()}");

      await ForegroundService.notification.finishEditMode();

      await ForegroundService.startForegroundService(fgFunction);
      await ForegroundService.getWakeLock();
      isRunning = true;
    }

    ///this exists solely in the main app/isolate,
    ///so needs to be redone after every app kill+relaunch
    await ForegroundService.setupIsolateCommunication(
        (_) => _foregroundServiceWantsInvocation());
  }

  Future _foregroundServiceWantsInvocation() async {
    // if (!await ForegroundService.isBackgroundIsolateSetupComplete()) return;
    print("angekommen");
    await GPSManager.instance.sendCurrentLocationToFirebase();
  }

  Future stopForegroundService() async {
    await ForegroundService.stopForegroundService();
    isRunning = false;
  }
}
