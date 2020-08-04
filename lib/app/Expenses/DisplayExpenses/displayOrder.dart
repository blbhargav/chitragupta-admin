import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chitragupta/Invoice/invoice.dart';
import 'package:chitragupta/extension/hover_extensions.dart';
import 'package:chitragupta/models/Member.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/models/Product.dart';
import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:chitragupta/extension/util.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:chitragupta/models/ExtraData.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../login.dart';

class DisplayOrderScreen extends StatefulWidget {
  Repository repository;
  Order order;
  Function() callback;
  DisplayOrderScreen(Repository repository, Order order,Function function)
      : repository = repository ?? Repository(),
        order=order,callback=function;
  @override
  _DisplayOrderScreenState createState() =>
      _DisplayOrderScreenState(repository: repository);
}

class _DisplayOrderScreenState extends State<DisplayOrderScreen> {
  Repository repository;

  _DisplayOrderScreenState({Repository repository})
      : repository = repository ?? Repository();

  bool _loading = false,_showSearchClearIcon=false;
  Order order;

  final _extraDataKeyController = TextEditingController();
  final _extraDataValueController = TextEditingController();

  final _extraSpentKeyController = TextEditingController();
  final _extraSpentValueController = TextEditingController();

  final _extraEarnedKeyController = TextEditingController();
  final _extraEarnedValueController = TextEditingController();

  final ScrollController _scrollController=ScrollController();
  TextEditingController _productSearchControllers = TextEditingController();

  String _extraDataKeyErrorTV, _extraDataValueErrorTV;
  String _extraSpentKeyErrorTV, _extraSpentValueErrorTV;
  String _extraEarnedKeyErrorTV, _extraEarnedValueErrorTV;

  TextEditingController _deliveredQtyController = new TextEditingController();
  TextEditingController _purchasedQtyController = new TextEditingController();
  TextEditingController _actualExcessQtyController = new TextEditingController();
  TextEditingController _EODExcessController = new TextEditingController();
  TextEditingController _amountSpentController = new TextEditingController();
  TextEditingController _returnQtyController = new TextEditingController();
  TextEditingController _invoiceAmountController = new TextEditingController();
  TextEditingController _remarksController = new TextEditingController();


  @override
  void dispose() {
    _scrollController.dispose();
    _extraDataKeyController.dispose();
    _extraDataValueController.dispose();
    _extraSpentKeyController.dispose();
    _extraSpentValueController.dispose();
    _productSearchControllers.dispose();
    _deliveredQtyController.dispose();
    _purchasedQtyController.dispose();
    _actualExcessQtyController.dispose();
    _EODExcessController.dispose();
    _amountSpentController.dispose();
    _returnQtyController.dispose();
    _invoiceAmountController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

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

  final List<Product> productsList = new List();
  List<Product> displayProductsList = new List();
  List<Member> membersList = new List();

  void initScreen() {
    repository.getOrder(widget.order.orderId).listen((_event) {
      setState(() {
        _loading = false;
        event=_event;
        order = Order.fromSnapshot(snapshot: _event);
        widget.order=order;
      });
    });

    repository.getOrderExtraData(widget.order.orderId).listen((event) {
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
    repository.getOrderExtraSpent(widget.order.orderId).listen((event) {
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
    repository.getOrderExtraEarned(widget.order.orderId).listen((event) {
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

    repository.getOrderProducts(widget.order.orderId).listen((event) {
      List<Product> products = new List();
      if (event.documents.length > 0) {
        event.documents.forEach((element) {
          products.add(Product.fromSnapshot(snapshot: element));
        });
      }
      setState(() {
        productsList.addAll(products);
        displayProductsList=products;
      });
    });

    repository.getEmployeesOnceByCity(widget.order.cityID).then((value) {
      setState(() {
        membersList = value;
      });
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
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
                      ExpandablePanel(
                        header: Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/logo.png",
                                      width: 60,
                                      height: 60,
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
                                          padding: EdgeInsets.all(5),
                                        ),
                                        Text(
                                            "Created @ ${DateFormat("dd-MMM-yyyy hh:mm a").format(order.createdDate)}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black45,
                                                fontWeight: FontWeight.w500)),
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                        ),
                                        getOrderStatus()
                                      ],
                                    ),
                                  ],
                                ),
                                flex: 2,
                              ),
                              Padding(padding: EdgeInsets.all(5),),
                              Expanded(
                                child: getHeaderWidget("Order Date","${DateFormat("dd-MMM-yyyy").format(order.date)}",Icons.calendar_today,Colors.blue ),
                                flex: 1,
                              ),
                              Padding(padding: EdgeInsets.all(5),),
                              Expanded(
                                child: getHeaderWidget("Total Items", "${productsList.length ?? 0}", Icons.bubble_chart, Colors.blueAccent),
                                flex: 1,
                              ),
                              Padding(padding: EdgeInsets.all(5),),
                              Expanded(
                                child: getHeaderWidget("Procured Items", "${order.procuredItems ?? 0}", Icons.timelapse, Colors.deepOrangeAccent),
                                flex: 1,
                              ),
                              Padding(padding: EdgeInsets.all(5),),
                              Expanded(
                                child: getHeaderWidget("Spent", "${order.amountSpent ?? 0}", MdiIcons.currencyInr, Colors.red),
                                flex: 1,
                              ),
                              Padding(padding: EdgeInsets.all(5),),
                              Expanded(
                                child: getHeaderWidget("Earned", "${order.amountEarned ?? 0}", MdiIcons.currencyInr, Colors.green),
                                flex: 1,
                              ),
                              Padding(padding: EdgeInsets.all(5),),
                              Expanded(
                                child: getHeaderWidget("Total","${(order.amountEarned ?? 0) - (order.amountSpent ?? 0)}", MdiIcons.currencyInr, Colors.green),
                                flex: 1,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(5),
                        ),
                        expanded: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 0,
                              child: Container(
                                height: 120,
                                width: double.maxFinite,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      child: Text("Employees Expenses",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20,color: Colors.lightBlue[900]),),
                                      padding: EdgeInsets.only(top: 5,bottom: 5),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                          itemCount: membersList.length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (BuildContext context,int index){
                                            return Container(
                                              width: 120,
                                              padding: EdgeInsets.all(5),
                                              margin: EdgeInsets.only(left:5,right: 5),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:EdgeInsets.all(5),
                                                    child: Text("${membersList[index].name}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
                                                  ),
                                                  Padding(
                                                    padding:EdgeInsets.all(5),
                                                    child: Text("₹ ${event.data[membersList[index].uid] ?? 0}",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 22),),
                                                  )
                                                ],
                                              ),
                                            );
                                          }
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
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
                                                            extraData[index].name,
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
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10,bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 400,
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
                              child: ListTile(
                                leading: Icon(Icons.search),
                                title: TextField(
                                  controller: _productSearchControllers,
                                  decoration: InputDecoration(
                                      hintText: 'Search Product', border: InputBorder.none),
                                  onChanged: onSearchTextChanged,
                                ),
                                trailing: _showSearchClearIcon? IconButton(icon:  Icon(Icons.cancel), onPressed: () {
                                  _productSearchControllers.clear();
                                  onSearchTextChanged('');
                                },):null,
                              ),
                            ),
                            Spacer(),
                            RaisedButton(
                              child: Text("Back",style: TextStyle(color: Colors.white),),
                              color: Colors.lightBlue[900],
                              onPressed: (){
                                widget.callback();
                              },
                            ),
                            Padding(padding: EdgeInsets.all(10),),
                            RaisedButton(
                              child: Text("Cancel",style: TextStyle(color: Colors.white),),
                              color: Colors.red[500],
                              onPressed: (){
                                showCancelOrderAlert(context);
                              },
                            ),
                            Padding(padding: EdgeInsets.all(10),),
                            RaisedButton(
                              child: Text("Complete",style: TextStyle(color: Colors.white),),
                              color: Colors.green[500],
                              onPressed: (){
                                showCompleteOrderAlert(context);
                              },
                            ),
                            Padding(padding: EdgeInsets.all(10),),
                            
                            RaisedButton(
                              child: Text("Invoice"),
                              onPressed: (){
                                showInvoicePreview(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "Product",
                                  style: TextStyle(
                                      fontSize: 16,color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Purchase\nOrder Qty",textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Expected\nPurchase Qty",textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              flex: 1,
                            ),
                            Padding(padding: EdgeInsets.all(3),),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Employee",
                                  style: TextStyle(
                                      fontSize: 16,color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Purchased",textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Amount\nSpent",textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Delivered\nQty",textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              flex: 1,
                            ),

                            Expanded(
                              child: Container(
                                child: Text(
                                  "Actual\nExcess Qty",textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Eod\nExcess",textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              flex: 1,
                            ),

                            Expanded(
                              child: Container(
                                child: Text(
                                  "Return\nQty",textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Invoice\nAmount",textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Remarks",textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Action",textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child:  displayProductsList.length == 0
                            ? Center(
                          child: Text("No data found"),
                        )
                            : Container(
                          child: Scrollbar(
                            isAlwaysShown: true,
                            controller: _scrollController,
                            child: ListView.separated(
                                controller: _scrollController,
                                shrinkWrap: true,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    width: MediaQuery.of(context)
                                        .size
                                        .width,
                                    height: 1,
                                    color: Colors.black12,
                                  );
                                },
                                padding: EdgeInsets.all(5),
                                scrollDirection: Axis.vertical,
                                itemCount: displayProductsList.length,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return Container(
                                    padding: EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                                "${displayProductsList[index].product}"),
                                          ),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              "${displayProductsList[index].purchaseOrderQty ??0}",textAlign: TextAlign.center,),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              "${displayProductsList[index].purchaseQty ?? 0}",textAlign: TextAlign.center,),
                                          ),
                                          flex: 1,
                                        ),
                                        Padding(padding: EdgeInsets.all(3),),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              "${displayProductsList[index].employee ?? "-"}",textAlign: TextAlign.start,),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              "${displayProductsList[index].purchasedQty ?? 0}",textAlign: TextAlign.center,),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              "${displayProductsList[index].amountSpent ??0}",textAlign: TextAlign.center,),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              "${displayProductsList[index].deliveredQty ??0}",textAlign: TextAlign.center,),
                                          ),
                                          flex: 1,
                                        ),

                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              "${displayProductsList[index].actualExcessQty ?? 0}",textAlign: TextAlign.center,),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              "${displayProductsList[index].EODExcess ?? 0}",textAlign: TextAlign.center,),
                                          ),
                                          flex: 1,
                                        ),

                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              "${displayProductsList[index].returnQty ?? 0}",textAlign: TextAlign.center,),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              "${displayProductsList[index].invoiceAmount ?? 0}",textAlign: TextAlign.center,),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              "${displayProductsList[index].remarks ?? "-"}",textAlign: TextAlign.center,),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: InkWellMouseRegion(
                                            child: Icon(Icons.edit,color: Colors.lightBlue[900],),
                                            onTap: (){
                                              showEditProductAlertDialog(context, displayProductsList[index]);
                                            },
                                          ),
                                          flex: 1,
                                        ),

                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                    ],
                  )),
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

  showCancelOrderAlert(BuildContext contxt) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "Cancel ${widget.order.name} ?",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,color: Colors.lightBlue[900]),
                          ),
                        ),
                      ),
                      HandCursor(
                        child: GestureDetector(
                          child: Icon(Icons.cancel,color: Colors.red,),
                          onTap: () async {
                            Navigator.pop(context);
                          },
                        ),
                      )

                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: RaisedButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      color: Colors.blue[900],
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      onPressed: () async {
                        Navigator.pop(contxt);
                        await widget.repository.cancelOrder(widget.order);
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
  showCompleteOrderAlert(BuildContext contxt) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "Complete ${widget.order.name} ?",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,color: Colors.lightBlue[900]),
                          ),
                        ),
                      ),
                      HandCursor(
                        child: GestureDetector(
                          child: Icon(Icons.cancel,color: Colors.red,),
                          onTap: () async {
                            Navigator.pop(context);
                            await widget.repository.completeOrder(widget.order);
                          },
                        ),
                      )

                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: RaisedButton(
                      child: Text(
                        "Completed",
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
                        widget.repository.completeOrder(widget.order);
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
    await repository.removeProductFromOrder(widget.order.orderId, id);
    setState(() {
      _loading = false;
    });
  }

  showEditProductAlertDialog(BuildContext contxt, Product product) {
    _deliveredQtyController.text="";
    _actualExcessQtyController.text="";
    _EODExcessController.text="";
    _returnQtyController.text="";
    _invoiceAmountController.text="";
    _remarksController.text="";

    if(product.deliveredQty!=null)
      _deliveredQtyController.text = product.deliveredQty.toString();
    
    if(product.actualExcessQty!=null)
      _actualExcessQtyController.text = product.actualExcessQty.toString();
    
    if(product.EODExcess!=null)
      _EODExcessController.text = product.EODExcess.toString();
    
    if(product.returnQty!=null)
    _returnQtyController.text = product.returnQty.toString();
    
    if(product.invoiceAmount !=null)
      _invoiceAmountController.text = product.invoiceAmount.toString();

    if(product.remarks!=null)
      _remarksController.text = product.remarks;

    return showDialog(
        context: contxt,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            content: Container(
              width: 500,
              padding: EdgeInsets.all(10),
              child: MediaQuery.removePadding(
                  context: contxt,
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _scrollController,
                    child: ListView(
                      reverse: false,
                      controller: _scrollController,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(left: 5, right: 5),
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Edit:- ${product.product}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.lightBlue[900]),
                                ),
                              ),
                            ),
                            HandCursor(
                              child: GestureDetector(
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      child: Text("Purchase Order Quantity",style: TextStyle(fontSize: 12,color: Colors.black54),),
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Padding(
                                      child: Text("${product.purchaseOrderQty}",style: TextStyle(fontSize: 18,color: Colors.black),),
                                      padding: EdgeInsets.all(5),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(5),),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      child: Text("Expected Purchase Quantity",style: TextStyle(fontSize: 12,color: Colors.black54),),
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Padding(
                                      child: Text("${product.purchaseQty}",style: TextStyle(fontSize: 18,color: Colors.black),),
                                      padding: EdgeInsets.all(5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      child: Text("Employee",style: TextStyle(fontSize: 12,color: Colors.black54),),
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Padding(
                                      child: Text("${product.employee ?? "-"}",style: TextStyle(fontSize: 18,color: Colors.black),),
                                      padding: EdgeInsets.all(5),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(5),),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      child: Text("Purchased Quantity",style: TextStyle(fontSize: 12,color: Colors.black54),),
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Padding(
                                      child: Text("${product.purchaseQty ?? 0}",style: TextStyle(fontSize: 18,color: Colors.black),),
                                      padding: EdgeInsets.all(5),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(padding: EdgeInsets.all(5),),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      child: Text("Amount Spent",style: TextStyle(fontSize: 12,color: Colors.black54),),
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Padding(
                                      child: Text("₹ ${product.amountSpent ?? 0}",style: TextStyle(fontSize: 18,color: Colors.black),),
                                      padding: EdgeInsets.all(5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5),),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10,top: 5),
                          child: new TextField(
                            controller: this._deliveredQtyController,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              labelText: "Delivered Quantity",
                              prefixIcon: Icon(Icons.star),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._actualExcessQtyController,
                            decoration: InputDecoration(
                              labelText: "Actual Excess Quantity",
                              prefixIcon: Icon(Icons.star),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._EODExcessController,
                            decoration: InputDecoration(
                              labelText: "EOD Excess Quantity",
                              prefixIcon: Icon(MdiIcons.stackOverflow),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: new TextField(
                            controller: this._returnQtyController,
                            decoration: InputDecoration(
                              labelText: "Return Quantity",
                              prefixIcon: Icon(Icons.assignment_returned),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo),
                              ),
                              //errorText: amountErrorTV
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
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
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
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
                        InkWellMouseRegion(
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
                      ],
                    ),
                  )),
            ),
          );
        });
  }

  void validateEditProduct(Product product) async {

    setState(() {
      _loading = true;
    });

    if (_deliveredQtyController.text.trim().length > 0) {
      product.deliveredQty = int.parse(_deliveredQtyController.text);
    } else {
      product.deliveredQty = 0;
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
    await repository.updateProductInOrder(widget.order.orderId, product);
    setState(() {
      _loading = false;
    });
    _deliveredQtyController.text = "";
    _purchasedQtyController.text = "";
    _actualExcessQtyController.text = "";
    _EODExcessController.text = "";
    _amountSpentController.text = "";
    _returnQtyController.text = "";
    _invoiceAmountController.text = "";
    _remarksController.text = "";
  }

  getHeaderWidget(String title, String data, var icon, var color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: color,
              ),
              Padding(
                padding: EdgeInsets.all(2),
              ),
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "$title",
                    style: TextStyle(
                        fontSize: 17,
                        color: Utils.headingColor,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
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
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                  "${data}",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black)),
            ),
          ),
        ),
      ],
    );
  }

  getOrderStatus() {
    if(widget.order.status==1){
      return Row(
        children: [
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text("Active"),)
        ],
      );
    }else if(widget.order.status==0){
      return Row(
        children: [
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text("Completed"),)
        ],
      );
    }else {
      return Row(
        children: [
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text("Cancelled"),)
        ],
      );
    }
  }

  void onSearchTextChanged(String text) {
    List<Product> tempProductsData=List();
    displayProductsList.clear();
    if (text.isEmpty) {
      tempProductsData.addAll(productsList);
    }else{
      productsList.forEach((product) {
        if (product.product.toLowerCase().contains(text.toLowerCase())){
          tempProductsData.add(product);
        }
      });
    }
    setState(() {
      _showSearchClearIcon=text.isNotEmpty;
      displayProductsList.addAll(tempProductsData);
    });
  }


  void _printDocument() {
    Printing.layoutPdf(
      onLayout: (PdfPageFormat format){
        return generateInvoice(format);
      },
    );
  }

  showInvoicePreview(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          final actions = <PdfPreviewAction>[
            if (!kIsWeb)
              PdfPreviewAction(
                icon: const Icon(Icons.save),
                onPressed: _saveAsFile,
              )
          ];
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: MediaQuery.of(context).size.width/0.9,
              padding: EdgeInsets.only(top: 10, right: 15, bottom: 10, left: 15),
              child: PdfPreview(
                maxPageWidth: 700,
                build: generateInvoice,
                actions: actions,
                onPrinted: _showPrintedToast,
                onShared: _showSharedToast,
              ),
            ),
          );
        });
  }
  void _showPrintedToast(BuildContext context) {
    final ScaffoldState scaffold = Scaffold.of(context);

    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    final ScaffoldState scaffold = Scaffold.of(context);

    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }


  Future<void> _saveAsFile(BuildContext context, LayoutCallback build, PdfPageFormat pageFormat) async {
    final Uint8List bytes = await build(pageFormat);

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final File file = File(appDocPath + '/' + 'document.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    OpenFile.open(file.path);
  }
}
