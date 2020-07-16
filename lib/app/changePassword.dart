import 'dart:math';

import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../login.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword(Repository repository): repository = repository ?? Repository();
  Repository repository;
  @override
  _ChangePasswordState createState() => _ChangePasswordState(repository);
}

class _ChangePasswordState extends State<ChangePassword> {
  Repository repository;
  List<Color> saveGradient = [
    Color(0xFF0EDED2),
    Color(0xFF03A0FE),
  ];

  String oldErrorTV, newErrorTV, confirmErrorTV;
  bool _oldPass = true, _newPass = true, _loading = false;

  TextEditingController _oldController = new TextEditingController();
  TextEditingController _newController = new TextEditingController();
  TextEditingController _confirmController = new TextEditingController();

  _ChangePasswordState(Repository repository): repository = repository ?? Repository();

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        appBar: AppBar(
            title: Text("Change Password"),
            centerTitle: true,
            backgroundColor: Colors.lightBlue[900]),
        body: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: new TextField(
                  controller: this._oldController,
                  obscureText: _oldPass,
                  decoration: InputDecoration(
                      labelText: "Old Password",
                      suffixIcon: InkWell(
                        child: _oldPass
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onTap: () {
                          setState(() {
                            if (_oldPass)
                              _oldPass = false;
                            else
                              _oldPass = true;
                          });
                        },
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                      errorText: oldErrorTV),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: new TextField(
                  controller: this._newController,
                  obscureText: _newPass,
                  decoration: InputDecoration(
                      labelText: "New Password",
                      //prefixIcon: Icon(Icons.info),
                      suffixIcon: InkWell(
                        child: _newPass
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                        onTap: () {
                          setState(() {
                            if (_newPass)
                              _newPass = false;
                            else
                              _newPass = true;
                          });
                        },
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                      errorText: newErrorTV),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: new TextField(
                  controller: this._confirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Confirm Password",
                      //prefixIcon: Icon(Icons.info),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.cyan),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                      errorText: confirmErrorTV),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 60),
              ),
              GestureDetector(
                child: Center(
                  child: roundedRectButton("Submit", saveGradient, false),
                ),
                onTap: () {
                  validate();
                },
              )
            ],
          ),
        ),
      ),
      opacity: 0.3,
      inAsyncCall: _loading,
    );
  }

  void validate() {
    String old = _oldController.text;
    String newPass = _newController.text;
    String confirmPass = _confirmController.text;

    setState(() {
      oldErrorTV = null;
      newErrorTV = null;
      confirmErrorTV = null;
    });

    if (old.isEmpty) {
      setState(() {
        oldErrorTV = "Please enter old password";
      });
    } else if (newPass.isEmpty) {
      setState(() {
        newErrorTV = "Please enter new password";
      });
    } else if (confirmPass.isEmpty) {
      setState(() {
        confirmErrorTV = "Please re-enter new password";
      });
    } else if (confirmPass.length < 6) {
      setState(() {
        confirmErrorTV = "Password too short";
      });
    } else if (!newPass.contains(confirmPass)) {
      setState(() {
        confirmErrorTV = "Password doesn't match with new password";
      });
    } else {
      submitDetails(old, newPass);
    }
  }

  Future<void> submitDetails(String old, String newPass) async {
    setState(() {
      _loading = true;
    });

    repository.reAuthenticateUser(old).then((res) {
      repository.updatePassword(newPass, res).then((result) {
        setState(() {
          _loading = false;
        });
        showAlertDialog("Success","Password successfully changed.");
      }).catchError((e) {
        setState(() {
          _loading = false;
        });
        showAlertDialog("Error","Something went wrong. Please try again later.");
      });
    }).catchError((e) {
      setState(() {
        _loading = false;
        oldErrorTV = "Wrong password";
      });
    });
  }

  showAlertDialog(title, body) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(title),
            content: Text(body),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
