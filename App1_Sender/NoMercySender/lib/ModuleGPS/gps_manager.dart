import 'package:NoMercySender/ModuleGPS/firebase_gps_writer.dart';
import 'package:geolocator/geolocator.dart';

class GPSManager {
  GPSManager._internal();
  static GPSManager _instance = GPSManager._internal();
  static GPSManager get instance => _instance;

  var locator = Geolocator();
  Position lastPosition;

  // Configs
  final int updateIntervallWhenStanding =
      60; // steht das Fahrzeug so wird nur einmal pro minute gesendet
  final int lowestUpdateIntervall =
      10; // fährt das Fahrzeug so wird maximal alle 10 sekunden gesendet

  Future checkAndMaybeSendLocationToFirebase() async {
    var positionData = await locator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    if (_checkIfSendingIsNescessarry(positionData)) {
      await FirebaseGPSWriter.sendGPSDataToFirebase(positionData);
      lastPosition = positionData;
    }
  }

  bool _checkIfSendingIsNescessarry(Position newPosition) {
    if (lastPosition == null) return true;
    var passedTimeSeconds =
        newPosition.timestamp.difference(lastPosition.timestamp).inSeconds;
    if (passedTimeSeconds < lowestUpdateIntervall) return false;
    if (passedTimeSeconds > updateIntervallWhenStanding) return true;

    // Next: Check for difference in Distance and compare to threshold
  }
}
