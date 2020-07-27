import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  int _createdDate;
  String _id;
  String _adminId;
  String _cityID;
  String _city;
  String _name;
  String _categoryId;
  String _category;

  int get createdDate => _createdDate;
  String get adminId => _adminId;
  String get cityID => _cityID;
  String get name => _name;
  String get city => _city;
  String get id =>_id;
  String get categoryId =>_categoryId;
  String get category =>_category;

  ProductModel({
    int createdDate,
    String adminId,
    String cityID,
    String name}){
    _createdDate = createdDate;
    _adminId = adminId;
    _cityID = cityID;
    _name = name;
  }

  ProductModel.fromJson(dynamic json) {
    _createdDate = json["createdDate"];
    _adminId = json["adminId"];
    _cityID = json["cityID"];
    _name = json["name"];
    _city = json["city"];
  }
  ProductModel.fromSnapshot({DocumentSnapshot snapshot}) {
    _createdDate = snapshot.data["createdDate"];
    _adminId = snapshot.data["adminId"];
    _cityID = snapshot.data["cityID"];
    _name = snapshot.data["name"];
    _city = snapshot.data["city"];
    _categoryId = snapshot.data["categoryId"];
    _category = snapshot.data["category"];
    _id=snapshot.documentID;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["createdDate"] = _createdDate;
    map["adminId"] = _adminId;
    map["cityID"] = _cityID;
    map["name"] = _name;
    return map;
  }

}