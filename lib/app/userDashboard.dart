import 'dart:async';

import 'package:chitragupta/app/addTransaction.dart';
import 'package:chitragupta/app/displaySpend.dart';
import 'package:chitragupta/models/spends_model.dart';
import 'package:chitragupta/models/user.dart';
import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chitragupta/globals.dart' as globals;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class userDashBoardScreen extends StatefulWidget {
  Repository repository;
  userDashBoardScreen(Repository repository)
      : repository = repository ?? Repository();

  @override
  _userDashBoardScreenState createState() => _userDashBoardScreenState(repository);
}

class _userDashBoardScreenState extends State<userDashBoardScreen>
    with TickerProviderStateMixin {
  _userDashBoardScreenState(Repository repository)
      : repository = repository ?? Repository();

  String userName = "Hi Guest";
  String currency = "₹", noDataTV = "";
  StreamSubscription _subscriptionTodo;
  List<Spend> recentSpends = new List();
  double today = 0, yesterday = 0, month = 0;
  bool _laoding = true;
  Repository repository;
  @override
  void initState() {
    super.initState();
    repository
        .getRecentRecords(_updateRecentSpends)
        .then((StreamSubscription s) => _subscriptionTodo = s)
        .catchError((err) {
      setState(() {
        _laoding = false;
        noDataTV = "No spends in this month yet";
      });
    });


  }

  _updateRecentSpends(SpendsList spendsList) {
    if (spendsList == null) {
      setState(() {
        _laoding = false;
      });
      return;
    }
    List<Spend> spendList = spendsList.spendList;
    List<Spend> tempRecentSpends = new List();
    double tempToday = 0, tempYesterday = 0, tempMonth = 0;

    spendList.sort((a, b) {
      var adate = a.dateTime;
      var bdate = b.dateTime;
      return -adate.compareTo(bdate);
    });
    var currentDate = DateTime.now();
    var yesterdayDate =
    new DateTime(currentDate.year, currentDate.month, currentDate.day - 1);

    spendList.forEach((spend) {
      int i = 0;
      if (i < 20) {
        i++;
        tempRecentSpends.add(spend);
      }
      String todayDate = DateFormat('dd-MM-yyyy').format(currentDate);
      String yesterdayDateString =
      DateFormat('dd-MM-yyyy').format(yesterdayDate);

      if (todayDate == DateFormat('dd-MM-yyyy').format(spend.dateTime)) {
        tempToday += spend.amount;
      } else if (yesterdayDateString ==
          DateFormat('dd-MM-yyyy').format(spend.dateTime)) {
        tempYesterday += spend.amount;
      }

      tempMonth += spend.amount;
    });

    setState(() {
      recentSpends = tempRecentSpends;
      today = tempToday;
      yesterday = tempYesterday;
      month = tempMonth;
      _laoding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  // Box decoration takes a gradient
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      // Colors are easy thanks to Flutter's Colors class.
                      Colors.lightBlue[900],
                      Colors.lightBlue[900],
                      Colors.lightBlue[900],
                      Colors.lightBlue[900],
                    ],
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            userName,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      flex: 4,
                    ),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text("Spent",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14)),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Text("₹ ${month}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "Today",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Text("₹ ${today}",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "Earned",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                      Text("₹ ${yesterday}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                      Padding(
                                        padding: EdgeInsets.all(5),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      flex: 6,
                    )
                  ],
                ),
              ),
              flex: 3,
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            child: Card(
                              child: Container(
                                color: Colors.white,
                                padding:EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Text("0",style: TextStyle(fontSize: 18),),
                                    Text("Today's Orders", style: TextStyle(color: Colors.black54),)
                                  ],
                                ),
                              ),
                            ),
                            onTap: (){

                            },
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Card(
                              child: Container(
                                color: Colors.white,
                                padding:EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    Text("0",style: TextStyle(fontSize: 18),),
                                    Text("Stocks", style: TextStyle(color: Colors.black54),)
                                  ],
                                ),
                              ),
                            ),
                            onTap: (){

                            },
                          ),
                          flex: 1,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      inAsyncCall: _laoding,
      opacity: 0.3,
    );
  }

  void addTransactionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTransactionScreen(repository)),
    );
  }

  @override
  void dispose() {
    if (_subscriptionTodo != null) {
      _subscriptionTodo.cancel();
    }
    super.dispose();
  }

  void navigateToDisplaySpend(Spend recentSpend) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DisplaySpendScreen(recentSpend, repository)));
  }


}
