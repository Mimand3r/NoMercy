import 'package:NoMercySender/firebase_worker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoMercySender',
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
  Future _testSendKlicked() async {
    setState(() => isLoading = true);
    await FirebaseWorker.testWriteToFirebase(DateTime.now().toIso8601String());
    setState(() => isLoading = false);
  }

  var isLoading = false;

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
                Builder(
                  builder: (context) {
                    if (!isLoading)
                      return RaisedButton(
                        onPressed: _testSendKlicked,
                        child: Text("TestSend To Firebase"),
                      );
                    return CircularProgressIndicator();
                  },
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
