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
  int deliveredQty=0;
  int purchasedQty=0;
  int actualExcessQty=0;
  int EODExcess=0;
  int amountSpent=0;
  int returnQty=0;
  int invoiceAmount=0;
  String remarks;

  String id;
  String product;
  String productId;
  String category;
  String categoryId;
  String orderId;
  int createdDate;
  String employee;
  String employeeId;
  int purchaseOrderQty=0;
  int purchaseQty=0;

  Product({this.deliveredQty, this.purchasedQty, this.actualExcessQty, this.EODExcess, this.amountSpent,
    this.returnQty, this.invoiceAmount, this.remarks, this.id,this.orderId,this.purchaseQty,this.purchaseOrderQty,this.categoryId,this.createdDate});

  Product.fromSnapshot({DocumentSnapshot snapshot}) {
    this.deliveredQty = snapshot.data["deliveredQty"];
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
    map["usedQty"] = deliveredQty;
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
      "purchasedQty":purchasedQty,
      "purchaseOrderQty":purchaseOrderQty,
      "employeeId":employeeId,
      "employee":employee,
      "categoryId":categoryId,
      "category":category,
      "deliveredQty":deliveredQty,
      "actualExcessQty":actualExcessQty,
      "EODExcess":EODExcess,
      "returnQty":returnQty,
      "invoiceAmount":invoiceAmount,
      "remarks":remarks,
      "createdDate":createdDate,
      "id":id,
      "amountSpent":amountSpent,
      "invoiceAmount":invoiceAmount
    };
  }

}