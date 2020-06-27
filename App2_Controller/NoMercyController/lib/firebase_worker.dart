import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseWorker {
  static Future<Stream<String>> testListenToFirestore() async {
    print("Test - Listening to Firebase");
    _streamController = StreamController<String>.broadcast();
    _subscription = Firestore.instance
        .collection("testColl")
        .document("testDoc")
        .snapshots()
        .listen((event) {
      print("event arrived - ${event.data}");
      _streamController.add(event.data["time"]);
    });
    return _streamController.stream;
  }

  static StreamController<String> _streamController;
  static StreamSubscription _subscription;

  static Future stopListening() async {
    await _streamController.close();
    await _subscription.cancel();
  }
}
