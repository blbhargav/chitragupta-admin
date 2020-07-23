import 'dart:async';
import 'dart:io';

import 'package:chitragupta/app/editProfile.dart';
import 'package:chitragupta/models/Member.dart';
import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:chitragupta/extension/util.dart';
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
  Member user;
  StreamSubscription _subscriptionTodo;
  List<Member> membersList = new List();
  _ProfileState(Repository repository)
      : repository = repository ?? Repository();
  @override
  void initState() {
    super.initState();

    repository.getProfile().then((value) {
      this.user = new Member.fromSnapshot(snapshot: value);
      setState(() {
        _laoding = false;
        userName = user.name;
        email = user.email;
      });
    });

    repository.getTeamMembers().listen((event) {
      List<Member> tempMembersList = new List();
      if (event.documents.length > 0) {
        event.documents.forEach((element) {
          tempMembersList.add(Member.fromSnapshot(snapshot: element));
        });
      }
      setState(() {
        membersList = tempMembersList;
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
          padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
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
            Align(
              child: Text("Team Members",
                  style: TextStyle(
                    fontSize: 24,
                    color: Utils.headingColor,
                  )),
              alignment: Alignment.centerLeft,
            ),
            Align(
              child: membersList.length == 0
                  ? Container(
                      height: 100,
                      child: Center(child: Text("No data found"),),
                    )
                  : Container(
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 10,
                            );
                          },
                          padding: EdgeInsets.all(5),
                          scrollDirection: Axis.vertical,
                          itemCount: membersList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: Card(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text("${index+1}"),
                                      Text("${membersList[index].name}"),
                                      Text("${membersList[index].mobile}"),
                                      Text("${membersList[index].email}"),
                                    ],
                                  ),
                                  padding: EdgeInsets.only(top: 10,bottom: 10,),
                                ),
                              ),
                            );
                          }),
                    ),
              alignment: Alignment.centerLeft,
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
            //showAddMemberAlertDialog(context);
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => EditProfile(user, repository)),
//            );
          },
        ),
      ),
    );
  }

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var mobileController = TextEditingController();
  String nameErrorTV, emailErrorTV, mobileErrorTv;
  showAddMemberAlertDialog(BuildContext contxt) {
    return showDialog(
        context: contxt,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 500.0,
              padding:
                  EdgeInsets.only(top: 10, right: 15, bottom: 10, left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Add Team Member",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this.nameController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.calendar_today),
                        errorText: nameErrorTV,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: new TextField(
                      controller: this.emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        errorText: emailErrorTV,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: new TextField(
                      controller: this.mobileController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                        labelText: "Mobile",
                        prefixIcon: Icon(Icons.phone_android),
                        errorText: mobileErrorTv,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: RaisedButton(
                      child: Text(
                        "Add",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      color: Colors.blue[900],
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      onPressed: () {
                        Navigator.pop(contxt);
                        nameErrorTV = null;
                        if (nameController.text.trim().length == 0) {
                          nameErrorTV = "Please enter Name";
                          return;
                        }
                        if (emailController.text.trim().length == 0) {
                          emailErrorTV = "Please enter Email";
                          return;
                        }
                        if (mobileController.text.trim().length == 0) {
                          mobileErrorTv = "Please enter Mobile";
                          return;
                        }

                        setState(() {
                          _laoding = true;
                        });
                        repository
                            .signUp(emailController.text.trim(), "12345678")
                            .then((value) {
                          var name = nameController.text.trim();
                          var email = emailController.text.trim();
                          var mobile = mobileController.text.trim();
                          repository
                              .addTeamMember(
                                  value.user.uid, name, email, mobile)
                              .then((value) {
                            setState(() {
                              _laoding = false;
                            });
                          }).whenComplete(() {
                            setState(() {
                              _laoding = false;
                            });
                          });
                        }).catchError((onError) {
                          setState(() {
                            _laoding = false;
                          });
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
