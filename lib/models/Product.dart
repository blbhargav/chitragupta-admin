import 'package:cloud_firestore/cloud_firestore.dart';

/// description : ""
/// POQty : 0
/// ourQty : 0
/// usedQty : 0
/// purchasedQty : 0
/// actualExcessQty : 0
/// EODExcess : 0
/// amountSpent : 0
/// returnQty : 0
/// invoiceAmount : 0
/// remarks : 0
/// id : ""

class Product {
  int ourQty;
  int usedQty;
  int purchasedQty;
  int actualExcessQty;
  int EODExcess;
  int amountSpent;
  int returnQty;
  int invoiceAmount;
  int paid;
  String remarks;

  String id;
  String product;
  String productId;
  String category;
  int categoryId;
  String orderId;
  int createdDate;
  String employee;
  String employeeId;
  int purchaseOrderQty;
  int purchaseQty;

  Product({this.ourQty, this.usedQty, this.purchasedQty, this.actualExcessQty, this.EODExcess, this.amountSpent,
    this.returnQty, this.invoiceAmount, this.remarks, this.id});

  Product.fromSnapshot({DocumentSnapshot snapshot}) {
    this.ourQty = snapshot.data["ourQty"];
    this.usedQty = snapshot.data["usedQty"];
    this.purchasedQty = snapshot.data["purchasedQty"];
    this.actualExcessQty = snapshot.data["actualExcessQty"];
    this.EODExcess = snapshot.data["EODExcess"];
    this.amountSpent = snapshot.data["amountSpent"];
    this.returnQty = snapshot.data["returnQty"];
    this.invoiceAmount = snapshot.data["invoiceAmount"];
    this.remarks = snapshot.data["remarks"];
    this.id = snapshot.documentID;

    this.product = snapshot.data["product"];
    this.productId = snapshot.data["productId"];
    this.category = snapshot.data["category"];
    this.categoryId = snapshot.data["categoryId"];
    this.orderId = snapshot.data["orderId"];
    this.employee = snapshot.data["employee"];
    this.employeeId = snapshot.data["employeeId"];
    this.purchaseOrderQty = snapshot.data["purchaseOrderQty"];
    this.purchaseQty = snapshot.data["purchaseQty"];
    this.createdDate=snapshot.data["createdDate"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["ourQty"] = ourQty;
    map["usedQty"] = usedQty;
    map["purchasedQty"] = purchasedQty;
    map["actualExcessQty"] = actualExcessQty;
    map["EODExcess"] = EODExcess;
    map["amountSpent"] = amountSpent;
    map["returnQty"] = returnQty;
    map["invoiceAmount"] = invoiceAmount;
    map["remarks"] = remarks;
    map["id"] = id;
    return map;
  }

  toJson(){
    return {
      "product":product,
      "productId":productId,
      "purchaseQty":purchaseQty,
      "purchaseOrderQty":purchaseOrderQty,
      "employeeId":employeeId,
      "employee":employee,
      "categoryId":categoryId,
      "category":category,
      "ourQty":ourQty,
      "usedQty":usedQty,
      "actualExcessQty":actualExcessQty,
      "EODExcess":EODExcess,
      "returnQty":returnQty,
      "invoiceAmount":invoiceAmount,
      "remarks":remarks,
      "createdDate":createdDate,
      "id":id
    };
  }

}