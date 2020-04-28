import 'dart:async';
import 'package:chitragupta/app/home.dart';
import 'package:chitragupta/models/user.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';

import 'app/dashboard.dart';
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
  void _checkUserHistory() async {

    bool signedInLocal=await repository.isUserSignedLocally();
    bool signedInFirebase=await repository.isSignedIn();

    if(signedInFirebase && signedInLocal){
      User user;
      await repository.getProfile().then((value){
        user = new User.fromSnapshot(snapshot: value);
      }) .whenComplete((){
        Repository.user=user;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => homeScreen(repository)
            ),
            ModalRoute.withName("/Home")
        );
      });

    }else{
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => loginRoot()
          ),
          ModalRoute.withName("/login")
      );
    }

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

