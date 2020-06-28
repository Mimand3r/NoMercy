import 'package:NoMercySender/ModuleGPS/firebase_gps_writer.dart';
import 'package:geolocator/geolocator.dart';

class GPSManager {
  GPSManager._internal();
  static GPSManager _instance = GPSManager._internal();
  static GPSManager get instance => _instance;

  // GPSManager.initWithIntervals(Duration intervall) {
  //   if (instance != null) throw Exception("GPS Manager already exists");
  //   instance = this;
  //   this.intervall = intervall;
  //   _sendLocationDataInIntervals();
  // }

  bool active = true;
  var locator = Geolocator();

  // Future startLocationSending(Duration intervall) async {
  //   print(
  //       "Sending GPS Data eingerichtet - Intervall: ${intervall.inSeconds} sekunden");
  //   // var permission = await locator.checkGeolocationPermissionStatus();
  //   // print(permission);
  //   // locator
  //   //     .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //   //     .then((value) {
  //   //   print("ready");
  //   // });
  //   // // print(positionData);
  //   while (active) {
  //     await Future.delayed(new Duration(seconds: 1));
  //     print("inertvall passed, ${DateTime.now().toIso8601String()}");
  //     var positionData = await locator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.best);
  //     await FirebaseGPSWriter.sendGPSDataToFirebase(positionData);
  //   }
  // }

  Future sendCurrentLocationToFirebase() async {
    await Future.delayed(new Duration(seconds: 1));
    print("inertvall passed, ${DateTime.now().toIso8601String()}");
    var positionData = await locator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    print(positionData);
    await FirebaseGPSWriter.sendGPSDataToFirebase(positionData);
  }
}
