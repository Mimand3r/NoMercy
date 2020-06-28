import 'package:NoMercySender/foreground_manager.dart';
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
  @override
  void initState() {
    super.initState();
    ForegroundServiceManager.instance.isRunningStream.listen((newValue) {
      setState(() {
        didInit = true;
        isRunning = newValue;
      });
    });
  }

  _toggleService() {
    if (ForegroundServiceManager.instance.isRunning) {
      ForegroundServiceManager.instance.stopForegroundService();
    } else {
      ForegroundServiceManager.instance.startForegroundService();
    }
    setState(() {});
  }

  _terminate() {
    ForegroundServiceManager.instance.stopForegroundService();
    setState(() {});
  }

  var didInit = false;
  var isRunning = false;

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
            child: Builder(builder: (context) {
              if (!didInit) return Center(child: CircularProgressIndicator());
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Sender"),
                  Builder(builder: (c) {
                    if (isRunning) return Text("ist scharf");
                    return Text("deaktiviert");
                  }),
                  RaisedButton(
                    onPressed: _toggleService,
                    child: Text("Aktivieren/Deaktivieren"),
                  ),
                  RaisedButton(
                    onPressed: _terminate,
                    child: Text("Terminieren"),
                  ),
                ],
              );
            }),
          ))
        ],
      ),
    );
  }
}
