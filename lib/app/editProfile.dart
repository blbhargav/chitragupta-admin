import 'dart:io';

import 'package:chitragupta/login.dart';
import 'package:chitragupta/models/user.dart';
import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  AdminUser user; Repository repository;
  EditProfile(AdminUser user, Repository repository){
    this.user=user;
    this.repository=repository;
  }

  @override
  _EditProfileState createState() => _EditProfileState(user,repository);
}

class _EditProfileState extends State<EditProfile> {
  File _file;
  var image;
  bool _loading = false;

  TextEditingController _nameController = new TextEditingController();

  String nameErrorTV;

  List<Color> saveGradient = [
    Color(0xFF0EDED2),
    Color(0xFF03A0FE),
  ];
  Repository repository;
  AdminUser user;
  _EditProfileState(AdminUser user, Repository repository){
    this.user=user;
    this.repository=repository;
    _nameController.text=user.name;
  }

  @override
  void initState() {
    super.initState();
    image = Image.asset('assets/user_avatar.png');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ProgressHUD(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit Profile"),
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
                      child: image,
                      maxRadius: 75,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
//            Container(
//              width: 200,
//              child: Center(
//                child: RaisedButton(
//                  child: Text("Change Image"),
//                  onPressed: () {
//                    showImageOptions();
//                  },
//                ),
//              ),
//            ),

            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: this._nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.info),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo),
                    ),
                    errorText: nameErrorTV),
                maxLength: 25,
                maxLengthEnforced: true,
              ),
            ),

//          Container(
//            margin: EdgeInsets.only(left: 10,right: 10),
//            child: TextField(
//              controller: this._spendController,
//              decoration: InputDecoration(
//                  labelText: "",
//                  prefixIcon: Icon(Icons.info),
//                  enabledBorder: UnderlineInputBorder(
//                    borderSide: BorderSide(color: Colors.cyan),
//                  ),
//                  focusedBorder: UnderlineInputBorder(
//                    borderSide: BorderSide(color: Colors.indigo),
//                  ),
//                  errorText: nameErrorTV),
//              maxLength: 25,
//              maxLengthEnforced: true,
//            ),
//          ),

            Padding(
              padding: EdgeInsets.only(top: 5),
            ),
            GestureDetector(
              child: Center(
                child: roundedRectButton("Save", saveGradient, false),
              ),
              onTap: () {
                validate(context);
              },
            )
          ],
        ),
      ),
      opacity: 0.3,
      inAsyncCall: _loading,
    );
  }

  Future getCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    _file = image;
    setState(() {
      this.image = Image.file(image);
    });
  }

  Future getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _file = image;
    setState(() {
      this.image = Image.file(image);
    });
  }

  void showImageOptions() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(
              "Select Image Options",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.camera_alt),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Text("Camera"),
                      ],
                    ),
                    padding: EdgeInsets.all(5),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    getCameraImage();
                  },
                ),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.image),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        Text("Gallery"),
                      ],
                    ),
                    padding: EdgeInsets.all(5),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    getGalleryImage();
                  },
                )
              ],
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void validate(BuildContext context) {
    setState(() {
      nameErrorTV = null;
    });
    if (_nameController.text.isEmpty) {
      setState(() {
        nameErrorTV = "Please enter your Name";
      });
    }else {
      setState(() {
        _loading=true;
      });
      user.name=_nameController.text;
//      repository.createUserProfile(user).then((res){
//        Navigator.of(context).pop();
//        setState(() {
//          _loading=true;
//        });
//      }).catchError((err){
//        setState(() {
//          _loading=true;
//        });
//        showAlertDialog("Error","Something went wrong. Please try again later.");
//      });
    }
  }
  showAlertDialog(title, body) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
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
