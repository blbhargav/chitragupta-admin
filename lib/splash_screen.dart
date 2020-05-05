import 'dart:async';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, _checkUserHistory);
  }
  Repository repository;
  @override
  void initState() {
    super.initState();
    repository=Repository();
    startTime();
  }
  Future<void> _checkUserHistory() async {

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => loginRoot()
        ),
        ModalRoute.withName("/login")
    );

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset('assets/logo.png',height: 100),
            new Text("Chitragupta",style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color:Colors.blue ),
            ),
            Container(
              child: new CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              margin: EdgeInsets.only(top: 50),
            ),
          ],
        ),
      ),
    );
  }
}

