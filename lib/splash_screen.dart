import 'dart:async';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  final Repository repository;
  SplashScreen({this.repository});
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, _checkUserHistory);
  }
  bool isAppUpToDate=true;
  @override
  void initState() {
    super.initState();
    startTime();
  }
  Future<void> _checkUserHistory() async {
    var result=await widget.repository.checkForUpdate();
    setState(() {
      isAppUpToDate=result;
    });
    if(isAppUpToDate){
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => loginRoot(repository: widget.repository,)
          ),
          ModalRoute.withName("/login")
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if(isAppUpToDate){
      return Scaffold(
        body: Center(
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
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset('assets/logo.png',height: 100),
            Padding(padding: EdgeInsets.all(10),),
            new Text("Cache Problem",style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color:Colors.red ),
            ),
            Padding(padding: EdgeInsets.all(5),),
            Text("Browser cache is avoiding you to use latest version of this Application. Please clear browser cache or open in 'Incognito Mode'."),

          ],
        ),
      ),
    );
  }
}

