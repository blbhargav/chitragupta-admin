import 'dart:async';

import 'package:chitragupta/app/editProfile.dart';
import 'package:chitragupta/models/user.dart';
import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Profile extends StatefulWidget {
  Profile(Repository repository) : repository = repository ?? Repository();
  Repository repository;
  @override
  _ProfileState createState() => _ProfileState(repository);
}

class _ProfileState extends State<Profile> {
  Repository repository;
  var userName = "Name";
  var email = "Email";
  bool _laoding = true;
  User user;
  StreamSubscription _subscriptionTodo;

  _ProfileState(Repository repository)
      : repository = repository ?? Repository();
  @override
  void initState() {
    super.initState();

    repository.getProfile().then((value) {
      this.user = new User.fromSnapshot(snapshot: value);
      setState(() {
        _laoding = false;
        userName = user.name;
        email = user.email;
      });
    });
  }

  @override
  void dispose() {
    if (_subscriptionTodo != null) {
      _subscriptionTodo.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      opacity: 0.3,
      inAsyncCall: _laoding,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          backgroundColor: Colors.lightBlue[900],
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/profile.png'),
                        fit: BoxFit.fitHeight),
                  ),
                ),
                Container(
                  height: 200,
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                ),
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 25, left: 20),
                  child: Center(
                    child: CircleAvatar(
                      child: Image.asset('assets/user_avatar.png'),
                      maxRadius: 75,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        userName,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        email,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Image.asset(
            'assets/feather.png',
            height: 35,
            width: 35,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditProfile(user, repository)),
            );
          },
        ),
      ),
    );
  }
}
