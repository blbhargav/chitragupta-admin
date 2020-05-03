import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DisplayOrderScreen extends StatefulWidget {
  Repository repository;
  String orderId;
  DisplayOrderScreen(Repository repository, String orderId)
      : repository = repository ?? Repository(),
        orderId = orderId;
  @override
  _DisplayOrderScreenState createState() =>
      _DisplayOrderScreenState(repository: repository);
}

class _DisplayOrderScreenState extends State<DisplayOrderScreen> {
  Repository repository;

  _DisplayOrderScreenState({Repository repository})
      : repository = repository ?? Repository();

  bool _loading = false;
  Order order;

  @override
  void initState() {
    super.initState();
    _loading = true;
    initScreen();
  }

  void initScreen() {
    repository.getOrder(widget.orderId).listen((event) {
      setState(() {
        _loading = false;
        order = Order.fromSnapshot(snapshot: event);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("#${widget.orderId}"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[900],
      ),
      body: ProgressHUD(
        child: MediaQuery.removePadding(
            context: context,
            child: order == null
                ? Center(
                    child: Text("No record found"),
                  )
                : Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                ),
                Card(
                  elevation: 2,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              "assets/logo.png",
                              width: 70,
                              height: 70,
                            ),
                            Padding(
                              padding: EdgeInsets.all(2),
                            ),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${order.name}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(3),
                                ),
                                Text(
                                    "@ ${DateFormat("dd-MMM-yyyy hh:mm a").format(order.createdDate)}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.w500)),
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
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.cyan,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Order Date",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
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
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                            "${DateFormat("dd-MMM-yyyy").format(order.date)}",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
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
                                Icon(
                                  Icons.bubble_chart,
                                  color: Colors.blueAccent,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Total Items",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
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
                                      child: Row(
                                        children: <Widget>[
                                          Text("0",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black)),
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
                                Icon(
                                  Icons.timelapse,
                                  color: Colors.deepOrangeAccent,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Procured Items",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
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
                                    child: Row(
                                      children: <Widget>[
                                        Text("0",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.monetization_on,
                                  color: Colors.red,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Spent",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
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
                                    child: Row(
                                      children: <Widget>[
                                        Text("0",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.monetization_on,
                                  color: Colors.green,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Earned",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
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
                                    child: Row(
                                      children: <Widget>[
                                        Text("0",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.monetization_on,
                                  color: Colors.green,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Total",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700),
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
                                    child: Row(
                                      children: <Widget>[
                                        Text("0",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black)),
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
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[

                    ],
                  ),
                ),
              ],
            )),
        opacity: 0.4,
        inAsyncCall: _loading,
      ),
    );
  }
}
