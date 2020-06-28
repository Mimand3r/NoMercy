import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class FirebaseGPSWriter {
  static Future sendGPSDataToFirebase(Position pos) async {
    var posJson = pos.toJson();
    print("Sending new Position to Firebase");
    Firestore.instance
        .collection("SendModules")
        .document("GPS")
        .updateData({"positions": FieldValue.arrayUnion([posJson])});
  }
}
