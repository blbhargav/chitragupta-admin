import 'package:cloud_firestore/cloud_firestore.dart';

/// createdDate : 12342
/// adminId : ""
/// city : ""
/// state : ""
/// status : 1

class City {
  int _createdDate;
  String _adminId;
  String _city;
  String _state;
  int _status;
  String _cityID;

  int get createdDate => _createdDate;
  String get adminId => _adminId;
  String get city => _city;
  String get state => _state;
  int get status => _status;
  String get cityID => _cityID;

  City({
      int createdDate, 
      String adminId, 
      String city, 
      String state, 
      int status}){
    _createdDate = createdDate;
    _adminId = adminId;
    _city = city;
    _state = state;
    _status = status;
}

  City.fromJson(dynamic json) {
    _createdDate = json["createdDate"];
    _adminId = json["adminId"];
    _city = json["city"];
    _state = json["state"];
    _status = json["status"];
  }

  City.fromSnapshot({DocumentSnapshot snapshot}) {
    _createdDate = snapshot.data["createdDate"];
    _adminId = snapshot.data["adminId"];
    _city = snapshot.data["city"];
    _state = snapshot.data["state"];
    _status = snapshot.data["status"];
    _cityID=snapshot.documentID;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["createdDate"] = _createdDate;
    map["adminId"] = _adminId;
    map["city"] = _city;
    map["state"] = _state;
    map["status"] = _status;
    return map;
  }

}