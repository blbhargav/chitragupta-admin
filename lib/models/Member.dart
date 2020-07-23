import 'package:cloud_firestore/cloud_firestore.dart';

/// createdDate : "int"
/// adminId : ""
/// uid : ""
/// type : ""
/// name : ""
/// mobile : ""
/// email : ""
/// address : ""
/// cityID : ""
/// city : ""
/// state : ""
/// status : 1

class Member {
  int _createdDate;

  set createdDate(int value) {
    _createdDate = value;
  }

  String _adminId;
  String _uid;
  String _type;
  String _name;
  String _mobile;
  String _email;
  String _address;
  String _cityID;
  String _city;
  String _state;
  int _status;

  int get createdDate => _createdDate;
  String get adminId => _adminId;
  String get uid => _uid;
  String get type => _type;
  String get name => _name;
  String get mobile => _mobile;
  String get email => _email;
  String get address => _address;
  String get cityID => _cityID;
  String get city => _city;
  String get state => _state;
  int get status => _status;

  Member({
    int createdDate,
      String adminId, 
      String uid, 
      String type, 
      String name, 
      String mobile, 
      String email, 
      String address, 
      String cityID, 
      String city, 
      String state, 
      int status}){
    _createdDate = createdDate;
    _adminId = adminId;
    _uid = uid;
    _type = type;
    _name = name;
    _mobile = mobile;
    _email = email;
    _address = address;
    _cityID = cityID;
    _city = city;
    _state = state;
    _status = status;
}

  Member.fromJson(dynamic json) {
    _createdDate = json["createdDate"];
    _adminId = json["adminId"];
    _uid = json["uid"];
    _type = json["type"];
    _name = json["name"];
    _mobile = json["mobile"];
    _email = json["email"];
    _address = json["address"];
    _cityID = json["cityID"];
    _city = json["city"];
    _state = json["state"];
    _status = json["status"];
  }

  Member.fromSnapshot({DocumentSnapshot snapshot}){
    _createdDate = snapshot.data["createdDate"];
    _adminId = snapshot.data["adminId"];
    _uid = snapshot.data["uid"];
    _type = snapshot.data["type"];
    _name = snapshot.data["name"];
    _mobile = snapshot.data["mobile"];
    _email = snapshot.data["email"];
    _address = snapshot.data["address"];
    _cityID = snapshot.data["cityID"];
    _city = snapshot.data["city"];
    _state = snapshot.data["state"];
    _status = snapshot.data["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["createdDate"] = _createdDate;
    map["adminId"] = _adminId;
    map["uid"] = _uid;
    map["type"] = _type;
    map["name"] = _name;
    map["mobile"] = _mobile;
    map["email"] = _email;
    map["address"] = _address;
    map["cityID"] = _cityID;
    map["city"] = _city;
    map["state"] = _state;
    map["status"] = _status;
    return map;
  }

  set adminId(String value) {
    _adminId = value;
  }

  set uid(String value) {
    _uid = value;
  }

  set type(String value) {
    _type = value;
  }

  set name(String value) {
    _name = value;
  }

  set mobile(String value) {
    _mobile = value;
  }

  set email(String value) {
    _email = value;
  }

  set address(String value) {
    _address = value;
  }

  set cityID(String value) {
    _cityID = value;
  }

  set city(String value) {
    _city = value;
  }

  set state(String value) {
    _state = value;
  }

  set status(int value) {
    _status = value;
  }
}