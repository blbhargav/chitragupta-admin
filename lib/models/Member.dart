import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  String adminId;
  String email;
  String mobile;
  String name;
  String userId,id;

  Member({this.adminId, this.email, this.mobile, this.name, this.userId});

  Member.fromJson(Map<String, dynamic> json) {
    adminId = json['adminId'];
    email = json['email'];
    mobile = json['mobile'];
    name = json['name'];
    userId = json['uid'];
  }
  Member.fromSnapshot({DocumentSnapshot snapshot}) {
    adminId = snapshot.data['adminId'];
    email = snapshot.data['email'];
    mobile = snapshot.data['mobile'];
    name = snapshot.data['name'];
    userId = snapshot.data['uid'];
    id=snapshot.documentID;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adminId'] = this.adminId;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['name'] = this.name;
    data['uid'] = this.userId;
    return data;
  }
}
