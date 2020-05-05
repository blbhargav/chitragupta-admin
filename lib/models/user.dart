import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUser {
  String uid,email,name,profileImage,role;
  AdminUser({this.uid,this.email,this.name,this.profileImage});

  AdminUser.fromSnapshot({DocumentSnapshot snapshot})
      :uid = snapshot.data['uid'],
        email = snapshot.data['email'],
        name = snapshot.data['name'],
        role=snapshot.data['role'],
        profileImage = snapshot.data['profileImage'];

  toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "role":role,
      "profileImage": profileImage
    };
  }
}