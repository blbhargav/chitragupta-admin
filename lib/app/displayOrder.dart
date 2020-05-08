import 'dart:convert';
import 'dart:typed_data';

import 'package:chitragupta/models/Member.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/models/Product.dart';
import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:chitragupta/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:chitragupta/models/ExtraData.dart';
import 'dart:html' as html;

import '../login.dart';

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

  final _extraDataKeyController = TextEditingController();
  final _extraDataValueController = TextEditingController();

  final _extraSpentKeyController = TextEditingController();
  final _extraSpentValueController = TextEditingController();

  final _extraEarnedKeyController = TextEditingController();
  final _extraEarnedValueController = TextEditingController();

  String _extraDataKeyErrorTV = null, _extraDataValueErrorTV = null;
  String _extraSpentKeyErrorTV = null, _extraSpentValueErrorTV = null;
  String _extraEarnedKeyErrorTV = null, _extraEarnedValueErrorTV = null;

  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _poQtyController = new TextEditingController();
  TextEditingController _ourQtyController = new TextEditingController();
  TextEditingController _usedQtyController = new TextEditingController();
  TextEditingController _purchasedQtyController = new TextEditingController();
  TextEditingController _actualExcessQtyController =
      new TextEditingController();
  TextEditingController _EODExcessController = new TextEditingController();
  TextEditingController _amountSpentController = new TextEditingController();
  TextEditingController _returnQtyController = new TextEditingController();
  TextEditingController _invoiceAmountController = new TextEditingController();
  TextEditingController _remarksController = new TextEditingController();

  String _descriptionErrorTv = null, _poQtyErrorTv = null;

  List<Color> saveGradient = [
    Color(0xFF0EDED2),
    Color(0xFF03A0FE),
  ];
  var event;
  @override
  void initState() {
    super.initState();
    _loading = true;
    initScreen();
  }

  List<ExtraData> extraData = new List();
  List<ExtraData> extraSpent = new List();
  List<ExtraData> extraEarned = new List();

  List<Product> productsList = new List();
  List<Member> membersList = new List();
  String member1Name="-",member2Name="-",member3Name="-",member4Name="-";
  int member1Amount=0,member2Amount=0,member3Amount=0,member4Amount=0;

  List<int> _selectedFile;
  Uint8List _bytesData;
  void _handleResult(Object result) {
    setState(() {
      _bytesData = Base64Decoder().convert(result.toString().split(",").last);
      _selectedFile = _bytesData;
    });
  }

  void initScreen() {
    repository.getOrder(widget.orderId).listen((_event) {
      setState(() {
        _loading = false;
        event=_event;
        order = Order.fromSnapshot(snapshot: _event);
      });
    });

    repository.getOrderExtraData(widget.orderId).listen((event) {
      List<ExtraData> extraList = new List();
      if (event.documents.length > 0) {
        event.documents.forEach((element) {
          extraList.add(ExtraData.fromSnapshot(snapshot: element));
        });
      }
      setState(() {
        extraData = extraList;
      });
    });
    repository.getOrderExtraSpent(widget.orderId).listen((event) {
      List<ExtraData> extraList = new List();
      if (event.documents.length > 0) {
        event.documents.forEach((element) {
          extraList.add(ExtraData.fromSnapshot(snapshot: element));
        });
      }
      setState(() {
        extraSpent = extraList;
      });
    });
    repository.getOrderExtraEarned(widget.orderId).listen((event) {
      List<ExtraData> extraList = new List();
      if (event.documents.length > 0) {
        event.documents.forEach((element) {
          extraList.add(ExtraData.fromSnapshot(snapshot: element));
        });
      }
      setState(() {
        extraEarned = extraList;
      });
    });

    repository.getOrderProducts(widget.orderId).listen((event) {
      List<Product> productS = new List();
      if (event.documents.length > 0) {
        event.documents.forEach((element) {
          productS.add(Product.fromSnapshot(snapshot: element));
        });
      }
      setState(() {
        productsList = productS;
      });
    });

    repository.getTeamMembersOnce().then((value) {
      List<Member> tempMembersList = new List();
      if (value.documents.length > 0) {
        var i=0;
        value.documents.forEach((element) {
          Member member=Member.fromSnapshot(snapshot: element);
          tempMembersList.add(member);
          setState(() {
            if(i==0){
              member1Name=member.name;
              member1Amount= event.data[member.userId];
            }else if(i==1){
              member2Name=member.name;
              member2Amount= event.data[member.userId];
            }else if(i==2){
              member3Name=member.name;
              member3Amount= event.data[member.userId];
            }else if(i==3){
              member4Name=member.name;
              member4Amount= event.data[member.userId];
            }
          });
          i++;
        });
      }
      setState(() {
        membersList = tempMembersList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        appBar: AppBar(
          title: Text("#${widget.orderId}"),
          centerTitle: true,
          backgroundColor: Colors.lightBlue[900],
        ),
        body: MediaQuery.removePadding(
          context: context,
          child: order == null
              ? Center(
                  child: Text("No record found"),
                )
              : Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
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
                                                color: Utils.headingColor,
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
                                                color: Utils.headingColor,
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
                                                Text("${order.totalItems ?? 0}",
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
                                                color: Utils.headingColor,
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
                                                  "${order.procuredItems ?? 0}",
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
                                        MdiIcons.currencyInr,
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
                                                color: Utils.headingColor,
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
                                              Text("${order.amountSpent ?? 0}",
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
                                        MdiIcons.currencyInr,
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
                                                color: Utils.headingColor,
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
                                              Text("${order.amountEarned ?? 0}",
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
                                        MdiIcons.currencyInr,
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
                                                color: Utils.headingColor,
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
                                                  "${(order.amountEarned ?? 0) - (order.amountSpent ?? 0)}",
                                                  style: TextStyle(
                                                      fontSize: 18,
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
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(member1Name,style:TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                                  Padding(padding: EdgeInsets.all(2),),
                                  Text("₹ ${member1Amount}",style: TextStyle(color: Colors.blue[900]),)
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(member2Name,style:TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                                  Padding(padding: EdgeInsets.all(2),),
                                  Text("₹ ${member2Amount}",style: TextStyle(color: Colors.blue[900]),)
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(member3Name,style:TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                                  Padding(padding: EdgeInsets.all(2),),
                                  Text("₹ ${member3Amount}",style: TextStyle(color: Colors.blue[900]),)
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(member4Name,style:TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                                  Padding(padding: EdgeInsets.all(2),),
                                  Text("₹ ${member4Amount}",style: TextStyle(color: Colors.blue[900]),)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1, //
                                        color: Colors.grey,
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              15.0) //         <--- border radius here
                                          ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Extra Data",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Utils.headingColor,
                                                  fontSize: 16),
                                            ),
                                            RaisedButton(
                                              hoverColor: Colors.orange,
                                              child: Text("+Add"),
                                              onPressed: () {
                                                showExtraDataAlertDialog(
                                                    context);
                                              },
                                            )
                                          ],
                                        ),
                                        extraData.length == 0
                                            ? Container(
                                                height: 50,
                                                child: Center(
                                                  child: Text("No data"),
                                                ),
                                              )
                                            : Container(
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    itemCount: extraData.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Flexible(
                                                                child: Text(
                                                              extraData[index]
                                                                  .name,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54),
                                                            )),
                                                            Text(" : "),
                                                            Text(
                                                              "₹ ${extraData[index].amount}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            )
                                                          ],
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(5),
                                                      );
                                                    }),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  width: 15,
                                  color: Colors.red,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1, //
                                        color: Colors.grey,
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              15.0) //         <--- border radius here
                                          ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Extra Amount Spent",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Utils.headingColor,
                                                  fontSize: 16),
                                            ),
                                            RaisedButton(
                                              hoverColor: Colors.orange,
                                              child: Text("+Add"),
                                              onPressed: () {
                                                showExtraSpentAlertDialog(
                                                    context);
                                              },
                                            )
                                          ],
                                        ),
                                        extraSpent.length == 0
                                            ? Container(
                                                height: 50,
                                                child: Center(
                                                  child: Text("No data"),
                                                ),
                                              )
                                            : Container(
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    itemCount:
                                                        extraSpent.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Flexible(
                                                                child: Text(
                                                              extraSpent[index]
                                                                  .name,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54),
                                                            )),
                                                            Text(" : "),
                                                            Text(
                                                              "₹ ${extraSpent[index].amount}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            )
                                                          ],
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(5),
                                                      );
                                                    }),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                VerticalDivider(
                                  width: 15,
                                  color: Colors.red,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1, //
                                        color: Colors.grey,
                                      ),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              15.0) //         <--- border radius here
                                          ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "Extra Amount Earned",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: Utils.headingColor,
                                                  fontSize: 16),
                                            ),
                                            RaisedButton(
                                              hoverColor: Colors.orange,
                                              child: Text("+Add"),
                                              onPressed: () {
                                                showExtraEarnedAlertDialog(
                                                    context);
                                              },
                                            )
                                          ],
                                        ),
                                        extraEarned.length == 0
                                            ? Container(
                                                height: 50,
                                                child: Center(
                                                  child: Text("No data"),
                                                ),
                                              )
                                            : Container(
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    itemCount:
                                                        extraEarned.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Flexible(
                                                                child: Text(
                                                              extraEarned[index]
                                                                  .name,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54),
                                                            )),
                                                            Text(" : "),
                                                            Text(
                                                              "₹ ${extraEarned[index].amount}",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            )
                                                          ],
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(5),
                                                      );
                                                    }),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //End of Extra data
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Products (${productsList.length})",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                    color: Utils.headingColor,
                                  ),
                                ),
                                RaisedButton(child: Text("Import xlsx"),hoverColor: Colors.orange,onPressed: (){
                                  html.InputElement uploadInput = html.FileUploadInputElement();
                                  uploadInput.multiple = false;
                                  uploadInput.draggable = true;
                                  uploadInput.accept = '.xlsx';
                                  uploadInput.click();
                                  uploadInput.onChange.listen((e) {
                                    final files = uploadInput.files;
                                    final file = files[0];
                                    final reader = new html.FileReader();

                                    reader.onLoadEnd.listen((e) {
                                      _handleResult(reader.result);
                                    });
                                    reader.readAsDataUrl(file);
                                    print("BLB file ${_selectedFile.length}");
                                  });
                                },),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "Description",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "PO Qty",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "Our Qty",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "Used\nQty",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "Purchased",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "Actual\nExcess\nQty",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "Eod\nExcess",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "Amount\nSpent",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "Return\nQty",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "Invoice\nAmount",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "Remarks",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Text(
                                      "Payer",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            productsList.length == 0
                                ? Container(
                                    height: 200,
                                    child: Center(
                                      child: Text("No data found"),
                                    ),
                                  )
                                : Container(
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 1,
                                            color: Colors.grey,
                                          );
                                        },
                                        padding: EdgeInsets.all(5),
                                        scrollDirection: Axis.vertical,
                                        itemCount: productsList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            child: Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                          "${productsList[index].description}"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                          "${productsList[index].POQty}"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                          "${productsList[index].ourQty}"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                          "${productsList[index].usedQty}"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                          "${productsList[index].purchasedQty}"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                          "${productsList[index].actualExcessQty}"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                          "${productsList[index].EODExcess}"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                          "${productsList[index].amountSpent}"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                          "${productsList[index].returnQty}"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                          "${productsList[index].invoiceAmount}"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                          "${productsList[index].remarks ?? "-"}"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Text(
                                                          "${productsList[index].payer ?? "-"}"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              padding: EdgeInsets.only(
                                                  bottom: 10, top: 10),
                                            ),
                                            onTap: () {
                                              showEditProductAlertDialog(
                                                  context, productsList[index]);
                                            },
                                            onLongPress: () {
                                              showDeleteproductAlert(
                                                  context, productsList[index]);
                                            },
                                          );
                                        }),
                                  )
                          ],
                        ),
                      ),
                    ],
                  )),
        ),
        floatingActionButton: FloatingActionButton(
          child: Image.asset(
            'assets/feather.png',
            height: 35,
            width: 35,
          ),
          onPressed: () {
            showAddProductAlertDialog(context);
          },
        ),
      ),
      opacity: 0.4,
      inAsyncCall: _loading,
    );
  }

  showExtraDataAlertDialog(BuildContext contxt) {
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
                    "Enter Extra Data",
                    style: TextStyle(
                        fontSize: 18,
                        color: Utils.headingColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._extraDataKeyController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Data Name",
                        prefixIcon: Icon(Icons.info),
                        errorText: _extraDataKeyErrorTV,
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
                      controller: this._extraDataValueController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Data Value",
                        prefixIcon: Icon(MdiIcons.currencyInr),
                        errorText: _extraDataValueErrorTV,
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
                      color: Colors.lightBlue[900],
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      onPressed: () async {
                        Navigator.pop(context);
                        _extraDataKeyErrorTV = null;
                        _extraDataValueErrorTV = null;
                        if (_extraDataKeyController.text.trim().length == 0) {
                          _extraDataKeyErrorTV = "Enter this field";
                          showExtraDataAlertDialog(context);
                          return;
                        }

                        if (_extraDataValueController.text.trim().length == 0) {
                          _extraDataValueErrorTV = "Enter this field";
                          showExtraDataAlertDialog(context);
                          return;
                        }

                        setState(() {
                          _loading = true;
                        });

                        await repository.addExtraDataToOrder(
                            order.orderId,
                            ExtraData(
                                name: _extraDataKeyController.text,
                                amount:
                                    int.parse(_extraDataValueController.text)));
                        _extraDataValueController.text = "";
                        _extraDataKeyController.text = "";
                        setState(() {
                          _loading = false;
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

  showExtraSpentAlertDialog(BuildContext contxt) {
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
                    "Enter Extra Amount Spent",
                    style: TextStyle(
                        fontSize: 18,
                        color: Utils.headingColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._extraSpentKeyController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Spent for",
                        prefixIcon: Icon(Icons.info),
                        errorText: _extraSpentKeyErrorTV,
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
                      controller: this._extraSpentValueController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        prefixIcon: Icon(MdiIcons.currencyInr),
                        errorText: _extraSpentValueErrorTV,
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
                      color: Colors.lightBlue[900],
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      onPressed: () async {
                        Navigator.pop(context);
                        _extraSpentKeyErrorTV = null;
                        _extraSpentValueErrorTV = null;
                        if (_extraSpentKeyController.text.trim().length == 0) {
                          _extraSpentKeyErrorTV = "Enter this field";
                          showExtraDataAlertDialog(context);
                          return;
                        }

                        if (_extraSpentValueController.text.trim().length ==
                            0) {
                          _extraSpentValueErrorTV = "Enter this field";
                          showExtraDataAlertDialog(context);
                          return;
                        }

                        setState(() {
                          _loading = true;
                        });

                        await repository.addExtraSpentToOrder(
                            order.orderId,
                            ExtraData(
                                name: _extraSpentKeyController.text,
                                amount: int.parse(
                                    _extraSpentValueController.text)));
                        _extraSpentValueController.text = "";
                        _extraSpentValueController.text = "";
                        setState(() {
                          _loading = false;
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

  showExtraEarnedAlertDialog(BuildContext contxt) {
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
                    "Enter Extra Amount Earned",
                    style: TextStyle(
                        fontSize: 18,
                        color: Utils.headingColor,
                        fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._extraEarnedKeyController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Amount Earned From",
                        prefixIcon: Icon(Icons.info),
                        errorText: _extraEarnedKeyErrorTV,
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
                      controller: this._extraEarnedValueController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Amount",
                        prefixIcon: Icon(MdiIcons.currencyInr),
                        errorText: _extraEarnedValueErrorTV,
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
                      color: Colors.lightBlue[900],
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      onPressed: () async {
                        Navigator.pop(context);
                        _extraEarnedKeyErrorTV = null;
                        _extraEarnedValueErrorTV = null;
                        if (_extraEarnedKeyController.text.trim().length == 0) {
                          _extraEarnedKeyErrorTV = "Enter this field";
                          showExtraDataAlertDialog(context);
                          return;
                        }

                        if (_extraEarnedValueController.text.trim().length ==
                            0) {
                          _extraEarnedValueErrorTV = "Enter this field";
                          showExtraDataAlertDialog(context);
                          return;
                        }

                        setState(() {
                          _loading = true;
                        });

                        await repository.addExtraEarnedToOrder(
                            order.orderId,
                            ExtraData(
                                name: _extraEarnedKeyController.text,
                                amount: int.parse(
                                    _extraEarnedValueController.text)));
                        _extraEarnedKeyController.text = "";
                        _extraEarnedValueController.text = "";
                        setState(() {
                          _loading = false;
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

  showAddProductAlertDialog(BuildContext contxt) {
    return showDialog(
        context: contxt,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Center(
              child: Container(
                width: 500,
                padding: EdgeInsets.all(10),
                child: MediaQuery.removePadding(
                    context: contxt,
                    child: ListView(
                      reverse: false,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 5, right: 5),
                      children: <Widget>[
                        Padding(
                          child: Center(
                            child: Text(
                              "Add Product",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Utils.headingColor,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.all(5),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._descriptionController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: "Description",
                              prefixIcon: Icon(Icons.description),
                              errorText: _descriptionErrorTv,
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
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._poQtyController,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Po Qty",
                              errorText: _poQtyErrorTv,
                              prefixIcon: Icon(Icons.description),
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
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._ourQtyController,
                            decoration: InputDecoration(
                              labelText: "Our Qty",
                              prefixIcon: Icon(Icons.star),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._usedQtyController,
                            decoration: InputDecoration(
                              labelText: "Used Qty",
                              prefixIcon: Icon(Icons.star),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._purchasedQtyController,
                            decoration: InputDecoration(
                              labelText: "Purchased Qty",
                              prefixIcon: Icon(Icons.shopping_basket),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._actualExcessQtyController,
                            decoration: InputDecoration(
                              labelText: "Actual Excess Qty",
                              prefixIcon: Icon(Icons.star),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._EODExcessController,
                            decoration: InputDecoration(
                              labelText: "EOD Excess",
                              prefixIcon: Icon(MdiIcons.stackOverflow),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._amountSpentController,
                            decoration: InputDecoration(
                              labelText: "Amount Spent",
                              prefixIcon: Icon(MdiIcons.currencyInr),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._returnQtyController,
                            decoration: InputDecoration(
                              labelText: "Return Qty",
                              prefixIcon: Icon(Icons.assignment_returned),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._invoiceAmountController,
                            decoration: InputDecoration(
                              labelText: "Invoice Amount",
                              prefixIcon: Icon(MdiIcons.currencyInr),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._remarksController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: "Remarks",
                              prefixIcon: Icon(Icons.warning),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: titleErrorTV
                            ),
                            maxLength: 50,
                            maxLengthEnforced: true,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        GestureDetector(
                          child: Center(
                            child:
                                roundedRectButton("Save", saveGradient, false),
                          ),
                          onTap: () {
                            Navigator.pop(contxt);
                            validateNewProduct();
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        InkWell(
                          child: Center(
                            child: Container(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.red),
                              ),
                              padding: EdgeInsets.all(5),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(contxt);
                          },
                        )
                      ],
                    )),
              ),
            ),
          );
        });
  }

  void validateNewProduct() async {
    _descriptionErrorTv = null;
    _poQtyErrorTv = null;
    if (_descriptionController.text.trim().length == 0) {
      _descriptionErrorTv = "Enter description";
      showAddProductAlertDialog(context);
      return;
    }

    if (_poQtyController.text.trim().length == 0) {
      _poQtyErrorTv = "Enter PO Quantity";
      showAddProductAlertDialog(context);
      return;
    }

    setState(() {
      _loading = true;
    });

    var product = Product();
    product.description = _descriptionController.text;
    product.POQty = int.parse(_poQtyController.text);

    if (_ourQtyController.text.trim().length > 0) {
      product.ourQty = int.parse(_ourQtyController.text);
    } else {
      product.ourQty = 0;
    }

    if (_usedQtyController.text.trim().length > 0) {
      product.usedQty = int.parse(_usedQtyController.text);
    } else {
      product.usedQty = 0;
    }

    if (_purchasedQtyController.text.trim().length > 0) {
      product.purchasedQty = int.parse(_purchasedQtyController.text);
    } else {
      product.purchasedQty = 0;
    }

    if (_actualExcessQtyController.text.trim().length > 0) {
      product.actualExcessQty = int.parse(_actualExcessQtyController.text);
    } else {
      product.actualExcessQty = 0;
    }

    if (_EODExcessController.text.trim().length > 0) {
      product.EODExcess = int.parse(_EODExcessController.text);
    } else {
      product.EODExcess = 0;
    }

    if (_amountSpentController.text.trim().length > 0) {
      product.amountSpent = int.parse(_amountSpentController.text);
    } else {
      product.amountSpent = 0;
    }

    if (_returnQtyController.text.trim().length > 0) {
      product.returnQty = int.parse(_returnQtyController.text);
    } else {
      product.returnQty = 0;
    }

    if (_invoiceAmountController.text.trim().length > 0) {
      product.invoiceAmount = int.parse(_invoiceAmountController.text);
    } else {
      product.invoiceAmount = 0;
    }

    if (_remarksController.text.trim().length > 0) {
      product.remarks = _remarksController.text;
    }

    await repository.addProductToOrder(widget.orderId, product);
    setState(() {
      _loading = false;
    });
    _descriptionController.text = "";
    _poQtyController.text = "";
    _ourQtyController.text = "";
    _usedQtyController.text = "";
    _purchasedQtyController.text = "";
    _actualExcessQtyController.text = "";
    _EODExcessController.text = "";
    _amountSpentController.text = "";
    _returnQtyController.text = "";
    _invoiceAmountController.text = "";
    _remarksController.text = "";
  }

  showDeleteproductAlert(BuildContext contxt, Product product) {
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
                    "Delete ${product.description} ?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: RaisedButton(
                      child: Text(
                        "Delete",
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
                        deleteProduct(product.id);
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

  void deleteProduct(String id) async {
    setState(() {
      _loading = true;
    });
    await repository.removeProductFromOrder(widget.orderId, id);
    setState(() {
      _loading = false;
    });
  }

  showEditProductAlertDialog(BuildContext contxt, Product product) {
    _descriptionController.text = product.description;
    _poQtyController.text = product.POQty.toString();
    _ourQtyController.text = product.ourQty.toString();
    _usedQtyController.text = product.usedQty.toString();
    _purchasedQtyController.text = product.purchasedQty.toString();
    _actualExcessQtyController.text = product.actualExcessQty.toString();
    _EODExcessController.text = product.EODExcess.toString();
    _amountSpentController.text = product.amountSpent.toString();
    _returnQtyController.text = product.returnQty.toString();
    _invoiceAmountController.text = product.invoiceAmount.toString();
    _remarksController.text = product.remarks.toString();
    return showDialog(
        context: contxt,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Center(
              child: Container(
                width: 500,
                padding: EdgeInsets.all(10),
                child: MediaQuery.removePadding(
                    context: contxt,
                    child: ListView(
                      reverse: false,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 5, right: 5),
                      children: <Widget>[
                        Padding(
                          child: Center(
                            child: Text(
                              "Edit Product",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Utils.headingColor,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.all(5),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._descriptionController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: "Description",
                              prefixIcon: Icon(Icons.description),
                              errorText: _descriptionErrorTv,
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
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._poQtyController,
                            textCapitalization: TextCapitalization.sentences,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Po Qty",
                              errorText: _poQtyErrorTv,
                              prefixIcon: Icon(Icons.description),
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
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._ourQtyController,
                            decoration: InputDecoration(
                              labelText: "Our Qty",
                              prefixIcon: Icon(Icons.star),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._usedQtyController,
                            decoration: InputDecoration(
                              labelText: "Used Qty",
                              prefixIcon: Icon(Icons.star),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._purchasedQtyController,
                            decoration: InputDecoration(
                              labelText: "Purchased Qty",
                              prefixIcon: Icon(Icons.shopping_basket),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._actualExcessQtyController,
                            decoration: InputDecoration(
                              labelText: "Actual Excess Qty",
                              prefixIcon: Icon(Icons.star),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._EODExcessController,
                            decoration: InputDecoration(
                              labelText: "EOD Excess",
                              prefixIcon: Icon(MdiIcons.stackOverflow),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._amountSpentController,
                            decoration: InputDecoration(
                              labelText: "Amount Spent",
                              prefixIcon: Icon(MdiIcons.currencyInr),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._returnQtyController,
                            decoration: InputDecoration(
                              labelText: "Return Qty",
                              prefixIcon: Icon(Icons.assignment_returned),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._invoiceAmountController,
                            decoration: InputDecoration(
                              labelText: "Invoice Amount",
                              prefixIcon: Icon(MdiIcons.currencyInr),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._remarksController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              labelText: "Remarks",
                              prefixIcon: Icon(Icons.warning),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: titleErrorTV
                            ),
                            maxLength: 50,
                            maxLengthEnforced: true,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        GestureDetector(
                          child: Center(
                            child:
                                roundedRectButton("Save", saveGradient, false),
                          ),
                          onTap: () {
                            Navigator.pop(contxt);
                            validateEditProduct(product);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),
                        InkWell(
                          child: Center(
                            child: Container(
                              child: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.red),
                              ),
                              padding: EdgeInsets.all(5),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(contxt);
                          },
                        )
                      ],
                    )),
              ),
            ),
          );
        });
  }

  void validateEditProduct(Product product) async {
    _descriptionErrorTv = null;
    _poQtyErrorTv = null;
    if (_descriptionController.text.trim().length == 0) {
      _descriptionErrorTv = "Enter description";
      showAddProductAlertDialog(context);
      return;
    }

    if (_poQtyController.text.trim().length == 0) {
      _poQtyErrorTv = "Enter PO Quantity";
      showAddProductAlertDialog(context);
      return;
    }

    setState(() {
      _loading = true;
    });
    product.description = _descriptionController.text;
    product.POQty = int.parse(_poQtyController.text);

    if (_ourQtyController.text.trim().length > 0) {
      product.ourQty = int.parse(_ourQtyController.text);
    } else {
      product.ourQty = 0;
    }

    if (_usedQtyController.text.trim().length > 0) {
      product.usedQty = int.parse(_usedQtyController.text);
    } else {
      product.usedQty = 0;
    }

    if (_purchasedQtyController.text.trim().length > 0) {
      product.purchasedQty = int.parse(_purchasedQtyController.text);
    } else {
      product.purchasedQty = 0;
    }

    if (_actualExcessQtyController.text.trim().length > 0) {
      product.actualExcessQty = int.parse(_actualExcessQtyController.text);
    } else {
      product.actualExcessQty = 0;
    }

    if (_EODExcessController.text.trim().length > 0) {
      product.EODExcess = int.parse(_EODExcessController.text);
    } else {
      product.EODExcess = 0;
    }

    if (_amountSpentController.text.trim().length > 0) {
      product.amountSpent = int.parse(_amountSpentController.text);
    } else {
      product.amountSpent = 0;
    }

    if (_returnQtyController.text.trim().length > 0) {
      product.returnQty = int.parse(_returnQtyController.text);
    } else {
      product.returnQty = 0;
    }

    if (_invoiceAmountController.text.trim().length > 0) {
      product.invoiceAmount = int.parse(_invoiceAmountController.text);
    } else {
      product.invoiceAmount = 0;
    }

    if (_remarksController.text.trim().length > 0) {
      product.remarks = _remarksController.text;
    }

    await repository.updateProductInOrder(widget.orderId, product);
    setState(() {
      _loading = false;
    });
    _descriptionController.text = "";
    _poQtyController.text = "";
    _ourQtyController.text = "";
    _usedQtyController.text = "";
    _purchasedQtyController.text = "";
    _actualExcessQtyController.text = "";
    _EODExcessController.text = "";
    _amountSpentController.text = "";
    _returnQtyController.text = "";
    _invoiceAmountController.text = "";
    _remarksController.text = "";
  }
}
