import 'package:cloud_firestore/cloud_firestore.dart';

/// id : ""
/// product : ""
/// productId : ""
/// category : ""
/// categoryId : ""
/// orderId : ""
/// employee : ""
/// employeeId : ""
/// purchaseOrderQty : 1
/// purchaseQty : 2

class Indent {
  String _id;
  String _product;
  String _productId;
  String _category;
  int _categoryId;
  String _orderId;
  int _createdDate;

  set id(String value) {
    _id = value;
  }

  String _employee;
  String _employeeId;
  int _purchaseOrderQty;
  int _purchaseQty;

  String get id => _id;
  String get product => _product;
  String get productId => _productId;
  String get category => _category;
  int get categoryId => _categoryId;
  String get orderId => _orderId;
  String get employee => _employee;
  String get employeeId => _employeeId;
  int get purchaseOrderQty => _purchaseOrderQty;
  int get purchaseQty => _purchaseQty;
  int get createdDate=>_createdDate;

  Indent({
      String id, 
      String product, 
      String productId, 
      String category,
    int categoryId,
      String orderId, 
      String employee, 
      String employeeId, 
      int purchaseOrderQty, 
      int purchaseQty,int createdDate}){
    _id = id;
    _product = product;
    _productId = productId;
    _category = category;
    _categoryId = categoryId;
    _orderId = orderId;
    _employee = employee;
    _employeeId = employeeId;
    _purchaseOrderQty = purchaseOrderQty;
    _purchaseQty = purchaseQty;
    _createdDate=createdDate;
}

  Indent.fromJson(dynamic json) {
    _id = json["id"];
    _product = json["product"];
    _productId = json["productId"];
    _category = json["category"];
    _categoryId = json["categoryId"];
    _orderId = json["orderId"];
    _employee = json["employee"];
    _employeeId = json["employeeId"];
    _purchaseOrderQty = json["purchaseOrderQty"];
    _purchaseQty = json["purchaseQty"];
  }

  Indent.fromSnapshot({DocumentSnapshot snapshot}) {
    _id=snapshot.documentID;
    _product = snapshot.data["product"];
    _productId = snapshot.data["productId"];
    _category = snapshot.data["category"];
    _categoryId = snapshot.data["categoryId"];
    _orderId = snapshot.data["orderId"];
    _employee = snapshot.data["employee"];
    _employeeId = snapshot.data["employeeId"];
    _purchaseOrderQty = snapshot.data["purchaseOrderQty"];
    _purchaseQty = snapshot.data["purchaseQty"];
    _createdDate=snapshot.data["createdDate"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["product"] = _product;
    map["productId"] = _productId;
    map["category"] = _category;
    map["categoryId"] = _categoryId;
    map["orderId"] = _orderId;
    map["employee"] = _employee;
    map["employeeId"] = _employeeId;
    map["purchaseOrderQty"] = _purchaseOrderQty;
    map["purchaseQty"] = _purchaseQty;
    return map;
  }

  set product(String value) {
    _product = value;
  }

  set productId(String value) {
    _productId = value;
  }

  set category(String value) {
    _category = value;
  }

  set categoryId(int value) {
    _categoryId = value;
  }

  set orderId(String value) {
    _orderId = value;
  }

  set employee(String value) {
    _employee = value;
  }

  set employeeId(String value) {
    _employeeId = value;
  }

  set purchaseOrderQty(int value) {
    _purchaseOrderQty = value;
  }

  set purchaseQty(int value) {
    _purchaseQty = value;
  }
}