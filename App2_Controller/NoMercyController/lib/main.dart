import 'package:flutter/material.dart';

import 'firebase_worker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoMercyController',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _startTestListener();
  }

  @override
  void dispose() {
    FirebaseWorker.stopListening();
    super.dispose();
  }

  Future _startTestListener() async {
    var stream = await FirebaseWorker.testListenToFirestore();
    stream.listen((event) {
      setState(() {
        txt = event;
      });
    });
  }

  var txt = "NoText";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
          ),
          SafeArea(
              child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Controller"),
                SizedBox(height: 20),
                Text(txt),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
