import 'dart:async';
import 'dart:core';
import 'package:chitragupta/models/user.dart';
import 'package:chitragupta/models/ExtraData.dart';
import 'package:chitragupta/models/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chitragupta/globals.dart' as globals;
import 'package:http/http.dart' as http;

class Repository {
  FirebaseAuth _firebaseAuth;
  SharedPreferences prefs;
  final databaseReference = Firestore.instance;
  static String uid = globals.UID;
  static AdminUser user;

  Repository({FirebaseAuth firebaseAuth, fbDBRef}) {
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    //this.fbDBRef.setPersistenceEnabled(true);
    getUserId();
  }

  Future signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future signUp(String loginId, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: loginId,
      password: password,
    );
  }

  Future updatePassword(String newPassword, FirebaseUser res) async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser.updatePassword(newPassword);
  }

  Future reAuthenticateUser(String oldPassword) async {
    final currentUser = await _firebaseAuth.currentUser();
    AuthCredential authCredential = EmailAuthProvider.getCredential(
      email: currentUser.email,
      password: oldPassword,
    );
    return currentUser.reauthenticateWithCredential(authCredential);
  }

  Future sendResetLink(String email) {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    globals.isLoggedIn = currentUser != null;
    if (currentUser != null) globals.UID = currentUser.uid;
    return currentUser != null;
  }

  Future<bool> isUserSignedLocally() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    return prefs.getBool("logged_in") ?? false;
  }

  Future<void> updateUserSignedLocally(bool signed, String uid) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    prefs.setString("uid", uid);
    return prefs.setBool("logged_in", signed);
  }

  Future<String> getUserId() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    if (prefs != null && prefs.getString("uid") != null) {
      uid = prefs.getString("uid");
    } else {
      FirebaseUser user = await _firebaseAuth.currentUser();
      uid = user.uid;
      prefs.setString("uid", uid);
    }

    globals.UID = uid;
    return uid;
  }

  getProfile() async {
    if (uid == null) {
      getUserId();
    }

    return databaseReference.collection("Profile").document(uid).get();
  }

  createOrder(String date, String name) {
    if (uid == null) {
      getUserId();
    }
    DateTime orderDate = DateFormat("dd-MM-yyyy").parse(date);
    var data = {
      "date": orderDate.millisecondsSinceEpoch,
      "createdDate": DateTime.now().millisecondsSinceEpoch,
      "year": orderDate.year,
      "month": orderDate.month,
      "day": orderDate.day,
      "uid": uid,
      "name": name,
      "status": 1
    };
    var docId =
        "CH${orderDate.year}${orderDate.month}${orderDate.day}_${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
    return databaseReference.collection("Orders").document(docId).setData(data);
  }

  getThisMonthOrders() {
    Stream<QuerySnapshot> reference = databaseReference
        .collection("Orders")
        .where("year", isEqualTo: DateTime.now().year)
        .where("uid", isEqualTo: uid)
        .where("status", isEqualTo: 1)
        .orderBy("createdDate", descending: true)
        .limit(15)
        .snapshots();

    return reference;
  }

  getOrder(String orderId) {
    Stream<DocumentSnapshot> reference =
        databaseReference.collection("Orders").document(orderId).snapshots();
    return reference;
  }

  addExtraDataToOrder(String orderId, ExtraData data) {
    return databaseReference
        .collection('Orders')
        .document(orderId)
        .collection("extra")
        .document()
        .setData(data.toJson());
  }
  getOrderExtraData(String orderId) {
    Stream<QuerySnapshot> reference = databaseReference
        .collection("Orders")
        .document(orderId)
        .collection("extra")
        .snapshots();

    return reference;
  }
  addExtraSpentToOrder(String orderId, ExtraData data) {
    return databaseReference
        .collection('Orders')
        .document(orderId)
        .collection("extraSpent")
        .document()
        .setData(data.toJson());
  }
  getOrderExtraSpent(String orderId) {
    Stream<QuerySnapshot> reference = databaseReference
        .collection("Orders")
        .document(orderId)
        .collection("extraSpent")
        .snapshots();

    return reference;
  }

  addExtraEarnedToOrder(String orderId, ExtraData data) {
    return databaseReference
        .collection('Orders')
        .document(orderId)
        .collection("extraEarned")
        .document()
        .setData(data.toJson());
  }
  getOrderExtraEarned(String orderId) {
    Stream<QuerySnapshot> reference = databaseReference
        .collection("Orders")
        .document(orderId)
        .collection("extraEarned")
        .snapshots();

    return reference;
  }

  addProductToOrder(String orderId, Product data) {
    return databaseReference
        .collection('Orders')
        .document(orderId)
        .collection("products")
        .document()
        .setData(data.toJson());
  }

  getOrderProducts(String orderId) {
    Stream<QuerySnapshot> reference = databaseReference
        .collection("Orders")
        .document(orderId)
        .collection("products")
        .snapshots();

    return reference;
  }

  removeProductFromOrder(String orderId, String productId) {
    return databaseReference
        .collection('Orders')
        .document(orderId)
        .collection("products")
        .document(productId).delete();
  }
  updateProductInOrder(String orderId, Product data) {
    return databaseReference
        .collection('Orders')
        .document(orderId)
        .collection("products")
        .document(data.id)
        .updateData(data.toJson());
  }

  addTeamMember(String userId, String name,String email,String mobile) {
    return databaseReference
        .collection('Team')
        .document(userId)
        .setData({"adminId":uid,"uid":userId,"name":name,"email":email,"mobile":mobile});
  }
  getTeamMembers() {
    Stream<QuerySnapshot> reference = databaseReference
        .collection("Team").where("adminId",isEqualTo: uid)
        .snapshots();

    return reference;
  }
}
