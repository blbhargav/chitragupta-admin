import 'package:cloud_firestore/cloud_firestore.dart';

/// createdDate : 1
/// adminId : ""
/// name : ""
/// mobile : ""
/// email : ""
/// address : ""
/// cityID : 1
/// city : ""
/// state : ""
/// status : 1

class Customer {
  int _createdDate;
  String _adminId;
  String _name;
  String _mobile;
  String _email;
  String _address;
  String _cityID;
  String _city;
  String _state;
  int _status;
  String _customerID;

  int get createdDate => _createdDate;
  String get adminId => _adminId;
  String get name => _name;
  String get mobile => _mobile;
  String get email => _email;
  String get address => _address;
  String get cityID => _cityID;
  String get city => _city;
  String get state => _state;
  int get status => _status;
  String get customerID => _customerID;

  Customer({
      int createdDate, 
      String adminId, 
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
    _name = name;
    _mobile = mobile;
    _email = email;
    _address = address;
    _cityID = cityID;
    _city = city;
    _state = state;
    _status = status;
}

  Customer.fromJson(dynamic json) {
    _createdDate = json["createdDate"];
    _adminId = json["adminId"];
    _name = json["name"];
    _mobile = json["mobile"];
    _email = json["email"];
    _address = json["address"];
    _cityID = json["cityID"];
    _city = json["city"];
    _state = json["state"];
    _status = json["status"];
  }

  Customer.fromSnapshot({DocumentSnapshot snapshot}) {
    _createdDate = snapshot.data["createdDate"];
    _adminId = snapshot.data["adminId"];
    _name = snapshot.data["name"];
    _mobile = snapshot.data["mobile"];
    _email = snapshot.data["email"];
    _address = snapshot.data["address"];
    _cityID = snapshot.data["cityID"];
    _city = snapshot.data["city"];
    _state = snapshot.data["state"];
    _status = snapshot.data["status"];
    _customerID=snapshot.documentID;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["createdDate"] = _createdDate;
    map["adminId"] = _adminId;
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

}