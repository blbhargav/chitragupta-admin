import 'dart:async';

import 'package:chitragupta/app/analytics.dart';
import 'package:chitragupta/app/dashboard.dart';
import 'package:chitragupta/app/settings.dart';
import 'package:chitragupta/extension/hover_extensions.dart';
import 'package:chitragupta/models/user.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class homeScreen extends StatefulWidget {
  homeScreen(Repository repository) : repository = repository ?? Repository();
  Repository repository;

  @override
  _homeScreenState createState() => _homeScreenState(repository);
}

class _homeScreenState extends State<homeScreen> with TickerProviderStateMixin {
  var _selectedIndex = 0;
  DateTime currentBackPressTime;
  String userName = "Hi Guest";
  _homeScreenState(Repository repository)
      : repository = repository ?? Repository();

  Repository repository;
  StreamSubscription _subscriptionTodo;
  AdminUser user;
  @override
  void initState() {
    init();
    super.initState();
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
    return WillPopScope(
      child: Scaffold(
        body:Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              //margin: EdgeInsets.only(top: 30,),
              padding:
              EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
              color: Colors.lightBlue[900],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(4),
                  ),
                  Card(
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: AssetImage(
                            "assets/logo.png",
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                  Padding(
                    padding: EdgeInsets.all(4),
                  ),
                  Container(
                    child: Text(
                      "${userName}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    padding: EdgeInsets.only(top: 3),
                  ),
                  Spacer(),
                  GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        new Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                        new Positioned(
                          right: 0,
                          child: new Container(
                            padding: EdgeInsets.all(1),
                            decoration: new BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: new Text(
                              '',
                              style: new TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                    onTap: () {},
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                ],
              ),
            ),
            Expanded(
             child:  Row(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Container(
                   height: double.maxFinite,
                   color: Colors.lightBlue[900],
                   width: 200,
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         margin: EdgeInsets.only(top: 25),
                         width: double.maxFinite,
                         padding: EdgeInsets.only(left: 10,right: 10),
                         child: HandCursor(
                           child: GestureDetector(
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Padding(
                                   child: Icon(Icons.home,color: Colors.white,),
                                   padding: EdgeInsets.only(right: 5,left: 10),
                                 ),
                                 Text('Home',style: TextStyle(color: Colors.white,fontSize: 20),)
                               ],
                             ),
                             onTap: (){

                             },
                           ),
                         ),
                       ),
                       Container(
                         margin: EdgeInsets.only(top: 20),
                         width: double.maxFinite,
                         padding: EdgeInsets.only(left: 10,right: 10),
                         child: HandCursor(
                           child: GestureDetector(
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Padding(
                                   child: Icon(Icons.home,color: Colors.white,),
                                   padding: EdgeInsets.only(right: 5,left: 10),
                                 ),
                                 Text('Analytics',style: TextStyle(color: Colors.white,fontSize: 20),)
                               ],
                             ),
                             onTap: (){

                             },
                           ),
                         ),
                       ),
                       Container(
                         margin: EdgeInsets.only(top: 20),
                         width: double.maxFinite,
                         padding: EdgeInsets.only(left: 10,right: 10),
                         child: HandCursor(
                           child: GestureDetector(
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Padding(
                                   child: Icon(Icons.home,color: Colors.white,),
                                   padding: EdgeInsets.only(right: 5,left: 10),
                                 ),
                                 Text('History',style: TextStyle(color: Colors.white,fontSize: 20),)
                               ],
                             ),
                             onTap: (){

                             },
                           ),
                         ),
                       ),
                       Container(
                         margin: EdgeInsets.only(top: 20),
                         width: double.maxFinite,
                         padding: EdgeInsets.only(left: 10,right: 10),
                         child: HandCursor(
                           child: GestureDetector(
                             child: Row(
                               mainAxisSize: MainAxisSize.min,
                               mainAxisAlignment: MainAxisAlignment.start,
                               children: [
                                 Padding(
                                   child: Icon(Icons.home,color: Colors.white,),
                                   padding: EdgeInsets.only(right: 5,left: 10),
                                 ),
                                 Text('Settings',style: TextStyle(color: Colors.white,fontSize: 20),)
                               ],
                             ),
                             onTap: (){

                             },
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
                 Expanded(
                   child:_selectedIndex == 0
                       ? dashBoardScreen(repository)
                       : (_selectedIndex == 1
                       ? Container(child: Text("Spends"),)
                       : (_selectedIndex == 2
                       ? Analytics(repository)
                       : (_selectedIndex == 3 ? Settings(repository) : Container()))) ,
                   flex: 1,
                 ),
//                Expanded(
//                  child:Container() ,
//                  flex: 1,
//                )
               ],
             ),
           ),
          ],
        ),


//        bottomNavigationBar: BottomNavigationBar(
//          backgroundColor: Colors.lightBlue[900],
//          items: const <BottomNavigationBarItem>[
//            BottomNavigationBarItem(
//              icon: Icon(Icons.home),
//              title: Text('Home'),
//            ),
//            BottomNavigationBarItem(
//              icon: Icon(Icons.monetization_on),
//              title: Text('Spends'),
//            ),
//            BottomNavigationBarItem(
//              icon: Icon(Icons.insert_chart),
//              title: Text('Analytics'),
//            ),
//            BottomNavigationBarItem(
//              icon: Icon(Icons.settings),
//              title: Text('Settings'),
//            ),
//          ],
//          currentIndex: _selectedIndex,
//          selectedItemColor: Colors.white,
//          unselectedItemColor: Colors.grey[400],
//          type: BottomNavigationBarType.fixed,
//          onTap: _onItemTapped,
//        ),
      ),
      onWillPop: () async {
        if (_selectedIndex > 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        } else {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime) > Duration(seconds: 2)) {
            currentBackPressTime = now;
            Fluttertoast.showToast(msg: "Press again to exist.");
            return Future.value(false);
          }
          return Future.value(true);
        }
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void init() {
    repository.getUserId();
    repository.getProfile().then((value) {
      setState(() {
        user = new AdminUser.fromSnapshot(snapshot: value);
        userName=user.name;
      });
    });
  }
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];
