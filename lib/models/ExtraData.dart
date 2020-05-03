import 'package:cloud_firestore/cloud_firestore.dart';

/// name : ""
/// amount : 0

class ExtraData {
  String name,id;
  int amount;

  String get _name => name;
  int get _amount =>amount;

  ExtraData({this.name, this.amount});

  ExtraData.map(dynamic obj) {
    this.name = obj["name"];
    this.amount = obj["amount"];
  }

  ExtraData.fromSnapshot({DocumentSnapshot snapshot})
      : name = snapshot.data['name'],
        amount=snapshot.data['amount'],
        id = snapshot.documentID;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["amount"] = amount;
    return map;
  }
  toJson(){
    return {
      "name":name,
      "amount":amount
    };
  }

}