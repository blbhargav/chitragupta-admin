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
  String description;
  int POQty;
  int ourQty;
  int usedQty;
  int purchasedQty;
  int actualExcessQty;
  int EODExcess;
  int amountSpent;
  int returnQty;
  int invoiceAmount;
  int paid;
  String id,payer,remarks;

  Product({this.description, this.POQty, this.ourQty, this.usedQty, this.purchasedQty, this.actualExcessQty, this.EODExcess, this.amountSpent, this.returnQty, this.invoiceAmount, this.remarks, this.id});

  Product.fromSnapshot({DocumentSnapshot snapshot}) {
    this.description = snapshot.data["description"];
    this.POQty = snapshot.data["POQty"];
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
    this.payer=snapshot.data["payer"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["description"] = description;
    map["POQty"] = POQty;
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
      "description":description,
      "POQty":POQty,
      "ourQty":ourQty,
      "usedQty":usedQty,
      "purchasedQty":purchasedQty,
      "actualExcessQty":actualExcessQty,
      "EODExcess":EODExcess,
      "amountSpent":amountSpent,
      "returnQty":returnQty,
      "invoiceAmount":invoiceAmount,
      "remarks":remarks,
      "id":id
    };
  }

}