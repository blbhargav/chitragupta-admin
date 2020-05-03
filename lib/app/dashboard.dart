import 'dart:async';

import 'package:chitragupta/app/OrdersScreen.dart';
import 'package:chitragupta/app/addTransaction.dart';
import 'package:chitragupta/app/createOrder.dart';
import 'package:chitragupta/app/displayOrder.dart';
import 'package:chitragupta/app/displaySpend.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/models/spends_model.dart';
import 'package:chitragupta/models/user.dart';
import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:chitragupta/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chitragupta/globals.dart' as globals;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class dashBoardScreen extends StatefulWidget {
  Repository repository;
  dashBoardScreen(Repository repository)
      : repository = repository ?? Repository();

  @override
  _dashBoardScreenState createState() => _dashBoardScreenState(repository);
}

class _dashBoardScreenState extends State<dashBoardScreen>
    with TickerProviderStateMixin {
  _dashBoardScreenState(Repository repository)
      : repository = repository ?? Repository();

  String userName = "Hi Guest";
  String currency = "₹", noDataTV = "";
  StreamSubscription _subscriptionTodo;
  List<Spend> recentSpends = new List();
  bool _laoding = true;
  Repository repository;

  String _createOrderErrorTV = null,_createNameErrorTV = null;

  TextEditingController _orderDateController = new TextEditingController();
  TextEditingController _orderNameController = new TextEditingController();
  List<Order> monthOrdersList = new List();
  @override
  void initState() {
    userName = "Hi ${Repository.user.name}";
    super.initState();
    initScreen();
    _laoding = false;
  }

  void initScreen() {
    final todayData = [
      new LinearBudgets("Spent", 100),
      new LinearBudgets("Earned", 120),
    ];
    todaySeriesList = Utils.createPieData(todayData);
    final now = DateTime.now();
    _orderDateController.text = DateFormat("dd-MM-yyyy")
        .format(DateTime(now.year, now.month, now.day + 2));
    _orderNameController.text="Super Daily";
    _orderDateController.addListener(dateValidator());
    repository.getThisMonthOrders().listen((event) {
      List<Order> tempMonthOrdersList = new List();
      if (event.documents.length > 0) {
        event.documents.forEach((element) {
          tempMonthOrdersList.add(Order.fromSnapshot(snapshot: element));
        });
      }
      setState(() {
        monthOrdersList = tempMonthOrdersList;
        todaySeriesList = Utils.createPieData(todayData);
      });
    });
  }

//new code
  List<charts.Series> todaySeriesList = new List();

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  //margin: EdgeInsets.only(top: 30,),
                  padding:
                      EdgeInsets.only(top: 38, left: 10, right: 10, bottom: 10),
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
                              radius: 15.0,
                              backgroundImage: AssetImage(
                                "assets/logo.png",
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
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
                Container(
                  padding: EdgeInsets.only(
                    top: 15,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      // Box decoration takes a gradient
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Align(
                            child: Container(
                              child: Text(
                                "Today insights",
                                style: TextStyle(
                                    fontSize: 18, color: Utils.headingColor,fontWeight: FontWeight.w700),
                              ),
                              padding: EdgeInsets.only(left: 0),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    child: charts.PieChart(todaySeriesList,
                                        animate: true,
                                        animationDuration:
                                            Duration(milliseconds: 500),
                                        // Configure the width of the pie slices to 60px. The remaining space in
                                        // the chart will be left as a hole in the center.
                                        defaultRenderer:
                                            new charts.ArcRendererConfig(
                                          arcWidth: 25,
                                        )),
                                    height: 220,
                                    width: 220,
                                  ),
                                  Container(
                                    height: 220,
                                    width: 220,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Total Spent",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(2),
                                          ),
                                          Text(
                                            "120",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 10,
                                        height: 10,
                                        color: Colors.deepOrange,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(3),
                                      ),
                                      Text(
                                        "Spent",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(3),
                                      ),
                                      Text(
                                        "100",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black54),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 10,
                                        height: 10,
                                        color: Colors.green,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(3),
                                      ),
                                      Text(
                                        "Earned",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(3),
                                      ),
                                      Text(
                                        "80",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black54),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Align(
                            child: Container(
                              child: Text(
                                "${DateFormat('MMM, yyyy').format(DateTime.now())} insights",
                                style: TextStyle(
                                    fontSize: 18,color: Utils.headingColor, fontWeight: FontWeight.w700),
                              ),
                              padding: EdgeInsets.only(left: 0),
                            ),
                            alignment: Alignment.centerLeft,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    child: charts.PieChart(todaySeriesList,
                                        animate: true,
                                        animationDuration:
                                            Duration(milliseconds: 500),
                                        // Configure the width of the pie slices to 60px. The remaining space in
                                        // the chart will be left as a hole in the center.
                                        defaultRenderer:
                                            new charts.ArcRendererConfig(
                                          arcWidth: 25,
                                        )),
                                    height: 220,
                                    width: 220,
                                  ),
                                  Container(
                                    height: 220,
                                    width: 220,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "Total Spent",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.normal),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(2),
                                          ),
                                          Text(
                                            "120",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 10,
                                        height: 10,
                                        color: Colors.deepOrange,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(3),
                                      ),
                                      Text(
                                        "Spent",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(3),
                                      ),
                                      Text(
                                        "100",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black54),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(2),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 10,
                                        height: 10,
                                        color: Colors.green,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(3),
                                      ),
                                      Text(
                                        "Earned",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(3),
                                      ),
                                      Text(
                                        "80",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.black54),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Align(
                  child: Container(
                    child: Text(
                      "Upcoming Orders",
                      style:
                          TextStyle(fontSize: 18, color: Utils.headingColor,fontWeight: FontWeight.w700),
                    ),
                    padding: EdgeInsets.only(left: 15, top: 5, bottom: 5),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                monthOrdersList.length == 0
                    ? Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Center(
                          child: Text("No orders found"),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(top: 5),
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
                            itemCount: monthOrdersList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                child: Card(
                                  elevation: 2,
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Image.asset("assets/logo.png",width: 70,height: 70,),
                                            Padding(
                                              padding: EdgeInsets.all(2),
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "#${monthOrdersList[index].orderId}",
                                                  style: TextStyle(fontSize:18,fontWeight: FontWeight.w700),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(3),
                                                ),
                                                Text("${monthOrdersList[index].name}",
                                                    style: TextStyle(
                                                        fontSize: 16, color: Colors.black54,fontWeight: FontWeight.w500)),
                                                Padding(
                                                  padding: EdgeInsets.all(3),
                                                ),
                                                Text("Created @ ${DateFormat("dd-MMM-yyyy hh:mm a").format(monthOrdersList[index].createdDate)}",
                                                    style: TextStyle(
                                                        fontSize: 15, color: Colors.black45,fontWeight: FontWeight.w300)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.calendar_today,color: Colors.cyan,),
                                                Padding(
                                                  padding: EdgeInsets.all(2),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "Order Date",
                                                      style: TextStyle(fontSize:17,color: Utils.headingColor,fontWeight: FontWeight.w700),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(6),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Color(0XFFF5F5F5),
                                                borderRadius: BorderRadius.circular(10),
                                                //boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.all(7),
                                                    child:  Row(
                                                      children: <Widget>[
                                                        Text("${DateFormat("dd-MMM-yyyy").format(monthOrdersList[index].date)}",
                                                            style: TextStyle(
                                                                fontSize: 16, color: Colors.black)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.bubble_chart,color: Colors.blueAccent,),
                                                Padding(
                                                  padding: EdgeInsets.all(2),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "Total Items",
                                                      style: TextStyle(fontSize:17,color: Utils.headingColor,fontWeight: FontWeight.w700),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(6),
                                            ),
                                            Center(
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Color(0XFFF5F5F5),
                                                  borderRadius: BorderRadius.circular(10),
                                                  //boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.all(7),
                                                      child:  Row(
                                                        children: <Widget>[
                                                          Text("0",
                                                              style: TextStyle(
                                                                  fontSize: 16, color: Colors.black)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.timelapse,color: Colors.deepOrangeAccent,),
                                                Padding(
                                                  padding: EdgeInsets.all(2),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "Procured Items",
                                                      style: TextStyle(fontSize:17,color: Utils.headingColor,fontWeight: FontWeight.w700),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(6),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Color(0XFFF5F5F5),
                                                borderRadius: BorderRadius.circular(10),
                                                //boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.all(7),
                                                    child:  Row(
                                                      children: <Widget>[
                                                        Text("0",
                                                            style: TextStyle(
                                                                fontSize: 16, color: Colors.black)),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => DisplayOrderScreen(repository,monthOrdersList[index].orderId)),
                                  );
                                },
                              );
                            }),),
              ],
            )),
        floatingActionButton: FloatingActionButton(
          child: Image.asset(
            'assets/feather.png',
            height: 35,
            width: 35,
          ),
          onPressed: () {
            showAlertDialog(context);
          },
        ),
      ),
      inAsyncCall: _laoding,
      opacity: 0.3,
    );
  }

  void addTransactionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddOrderScreen(repository)),
    );
  }

  showAlertDialog(BuildContext contxt) {
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
                    "Create Order",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._orderDateController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Order Date(dd-MM-yyyy)",
                        prefixIcon: Icon(Icons.calendar_today),
                        errorText: _createOrderErrorTV,
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
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._orderNameController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Order Name",
                        prefixIcon: Icon(Icons.calendar_today),
                        errorText: _createNameErrorTV,
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
                        "Create",
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      color: Colors.blue[900],
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      onPressed: () {
                        Navigator.pop(contxt);
                        createOrder(_orderDateController.text);
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

  dateValidator() {
    setState(() {
      _createOrderErrorTV = null;
      _createNameErrorTV=null;
      if (_orderDateController.text.length < 10) {
        _createOrderErrorTV = "Please enter date in dd-MM-yyyy format";
      }
      if (_orderNameController.text.length < 0) {
        _createNameErrorTV = "Please enter order Name";
      }
    });
  }

  void createOrder(String date) {
    if (date.length < 10) {
      setState(() {
        _createOrderErrorTV = "Please enter date in dd-MM-yyyy format";
      });
      showAlertDialog(context);
    } else {
      setState(() {
        _laoding = false;
      });
      repository.createOrder(date,_orderNameController.text);
    }
  }
}
