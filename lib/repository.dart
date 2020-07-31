import 'dart:async';
import 'dart:core';
import 'package:chitragupta/extension/Constants.dart';
import 'package:chitragupta/models/Member.dart';
import 'package:chitragupta/models/ExtraData.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/models/Product.dart';
import 'package:chitragupta/models/category.dart';
import 'package:chitragupta/models/customer.dart';
import 'package:chitragupta/models/indent.dart';
import 'package:chitragupta/models/product.dart';
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
  static Member user;

  Repository({FirebaseAuth firebaseAuth, fbDBRef}) {
    _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
    //this.fbDBRef.setPersistenceEnabled(true);
    //databaseReference.settings(persistenceEnabled: true);
    //getUserId();
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
      await getUserId();
    }
    return databaseReference.collection("Users").document(uid).get();
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
      "amountEarned":0,
      "amountSpent":0,
      "status": 1
    };
    var docId =
        "CH${orderDate.year}${orderDate.month}${orderDate.day}_${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}";
    return databaseReference.collection("Orders").document(docId).setData(data);
  }

  getRecentOrdersOrders() {
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
  getTodayOrders() {
    Stream<QuerySnapshot> reference = databaseReference
        .collection("Orders")
        .where("year", isEqualTo: DateTime.now().year)
        .where("month", isEqualTo: DateTime.now().month)
        .where("day", isEqualTo: DateTime.now().day)
        .where("uid", isEqualTo: uid)
        .snapshots();

    return reference;
  }
  getThisMonthOrdersOrders() {
    Stream<QuerySnapshot> reference = databaseReference
        .collection("Orders")
        .where("year", isEqualTo: DateTime.now().year)
        .where("month", isEqualTo: DateTime.now().month)
        .where("uid", isEqualTo: uid)
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
    databaseReference.collection("Orders").document(orderId).updateData({
      "amountSpent": FieldValue.increment(data.amount)
    });
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
    databaseReference.collection("Orders").document(orderId).updateData({
      "amountEarned": FieldValue.increment(data.amount)
    });
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
    databaseReference.collection("Orders").document(orderId).updateData({"totalItems":FieldValue.increment(1)});
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
        .orderBy("product",descending: false)
        .snapshots();

    return reference;
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
  getTeamMembersOnce() {
    return databaseReference
        .collection("Team")
        .where("adminId",isEqualTo: uid)
        .getDocuments();
  }


  /*
  *
  *
  *
  * new APIS
  *
  *
  * */

  addCity(String city, String state) async {
    if (uid == null) {
      getUserId();
    }
    var data = {
      "createdDate": DateTime.now().millisecondsSinceEpoch,
      "adminId": uid,
      "city": city,
      "state": state,
      "status": 1
    };

    await databaseReference.collection("Counters").document("cities").updateData({"count":FieldValue.increment(1)});

    var index=await databaseReference.collection("Counters").document("cities").get();

    return databaseReference.collection("Cities").document("${index.data["count"]}").setData(data);
  }

  getCitiesOnce() {
    return databaseReference
        .collection("Cities")
        .where("adminId",isEqualTo: uid)
        .where("status", isEqualTo: 1)
        .getDocuments();
  }

  addCustomer(String name, String mobile,String email,String address,String cityID,String city,String state) async {
    if (uid == null) {
      getUserId();
    }
    var data = {
      "createdDate": DateTime.now().millisecondsSinceEpoch,
      "adminId": user.adminId,
      "name": name,
      "mobile": mobile,
      "email": email,
      "address": address,
      "cityID": cityID,
      "city": city,
      "state":state,
      "status": 1
    };

    await databaseReference.collection("Counters").document("customers").updateData({"count":FieldValue.increment(1)});

    var index=await databaseReference.collection("Counters").document("customers").get();

    return databaseReference.collection("Customers").document("${index.data["count"]}").setData(data);
  }

  editCustomer(String customerID,String name, String mobile,String email,String address,String cityID,String city,String state) async {
    if (user == null) {
      await getProfile();
    }
    var data = {
      "adminId": user.adminId,
      "name": name,
      "mobile": mobile,
      "email": email,
      "address": address,
      "cityID": cityID,
      "city": city,
      "state":state,
      "status": 1
    };

    return databaseReference.collection("Customers").document(customerID).updateData(data);
  }

  Future<List<Customer>> getCustomersOnce() async {
    List<Customer> tempCustomersList = new List();
    var customersDBRef=databaseReference
        .collection("Customers")
        .where("adminId",isEqualTo: uid)
        .where("status", isEqualTo: 1)
        .reference();

    if(user.type=="Admin"){
      customersDBRef= databaseReference
          .collection("Customers")
          .where("adminId",isEqualTo: user.adminId)
          .where("cityID", isEqualTo: user.cityID)
          .where("status", isEqualTo: 1)
          .reference();
    }

    var snapshot=await customersDBRef.getDocuments();
    if (snapshot.documents.length > 0) {
      snapshot.documents.forEach((element) {
        Customer customer = Customer.fromSnapshot(snapshot: element);
        tempCustomersList.add(customer);
      });
    }
    return tempCustomersList;

  }



  //Team management
  addMember(String name,String type, String mobile,String email,String address,String cityID,String city,String state) async {
    if (uid == null) {
      getUserId();
    }
    var userID="";
    try{
      var signUpRef=await signUp(email, "12345678");
      userID=signUpRef.user.uid;
    }catch(_e){
      print("BLB member add failed repo ${_e.code}");
      return _e.code;
    }

    var data = {
      "createdDate": DateTime.now().millisecondsSinceEpoch,
      "adminId": user.adminId,
      "uid":userID,
      "type":type,
      "name": name,
      "mobile": mobile,
      "email": email,
      "address": address,
      "cityID": cityID,
      "city": city,
      "state":state,
      "status": 1
    };

    return databaseReference.collection("Users").document(userID).setData(data);
  }

  editMember(String memberID,String type,String name, String mobile,String email,String address,String cityID,String city,String state) async {
    if (uid == null) {
      await getUserId();
    }
    var data = {
      "adminId": user.adminId,
      "name": name,
      "type":type,
      "mobile": mobile,
      "email": email,
      "address": address,
      "cityID": cityID,
      "city": city,
      "state":state,
      "status": 1
    };

    return databaseReference.collection("Users").document(memberID).updateData(data);
  }

  Future<List<Member>> getMembersOnce() async{
    List<Member> tempTeamList = new List();
    if(user.type==Constants.superAdmin){
      var snapshot=await databaseReference
          .collection("Users")
          .where("adminId",isEqualTo: uid)
          .where("status", isEqualTo: 1)
          .getDocuments();
      print("BLB super member team ${snapshot.documents.length}");
      if (snapshot.documents.length > 0) {
        snapshot.documents.forEach((element) {
          Member member = Member.fromSnapshot(snapshot: element);
          tempTeamList.add(member);
        });
      }
    }else if(user.type==Constants.admin){
      var snapshot=await databaseReference
          .collection("Users")
          .where("adminId",isEqualTo: user.adminId)
          .where("cityID", isEqualTo: user.cityID)
          .where("status", isEqualTo: 1)
          .getDocuments();
      if (snapshot.documents.length > 0) {
        snapshot.documents.forEach((element) {
          Member member = Member.fromSnapshot(snapshot: element);
          tempTeamList.add(member);
        });
      }
    }

    return tempTeamList;
  }

  Future<List<Member>> getEmployeesOnceByCity(String cityId) async{

    List<Member> tempTeamList = new List();
    if(user.type==Constants.superAdmin){
      var snapshot=await databaseReference
          .collection("Users")
          .where("adminId",isEqualTo: uid)
          .where("cityID", isEqualTo: cityId)
          .where("type",isEqualTo: Constants.employee)
          .where("status", isEqualTo: 1)
          .getDocuments();
      print("BLB super member team  for city $cityId ${snapshot.documents.length}");
      if (snapshot.documents.length > 0) {
        snapshot.documents.forEach((element) {
          Member member = Member.fromSnapshot(snapshot: element);
          tempTeamList.add(member);
        });
      }
    }else if(user.type==Constants.admin){
      var snapshot=await databaseReference
          .collection("Users")
          .where("adminId",isEqualTo: user.adminId)
          .where("cityID", isEqualTo: user.cityID)
          .where("type",isEqualTo: Constants.employee)
          .where("status", isEqualTo: 1)
          .getDocuments();
      if (snapshot.documents.length > 0) {
        snapshot.documents.forEach((element) {
          Member member = Member.fromSnapshot(snapshot: element);
          tempTeamList.add(member);
        });
      }
    }

    return tempTeamList;
  }




  //indent
  createIndent(Customer customer, DateTime orderDate) async{
    if (uid == null) {
      getUserId();
    }
    var data = {
      "date": orderDate.millisecondsSinceEpoch,
      "createdDate": DateTime.now().millisecondsSinceEpoch,
      "year": orderDate.year,
      "month": orderDate.month,
      "day": orderDate.day,
      "uid": uid,
      "adminId":user.adminId,
      "name": customer.name,
      "cityID":customer.cityID,
      "city":customer.city,
      "customerID":customer.customerID,
      "amountEarned":0,
      "amountSpent":0,
      "status": 1
    };

    await databaseReference.collection("Counters").document("orders").updateData({"count":FieldValue.increment(1)});

    var index=await databaseReference.collection("Counters").document("orders").get();

    return await databaseReference.collection("Orders").document("${index.data["count"]}").setData(data);
  }
  Future<List<Order>> getActiveIndents() async{
    List<Order> tempOrdersList=List();

   if(user.type=="SuperAdmin"){
     var orderSnapshot = await databaseReference
         .collection("Orders")
         .where("status", isEqualTo: 1)
         .where("adminId", isEqualTo: user.adminId)
         .orderBy("date", descending: true)
         .getDocuments();
     if (orderSnapshot.documents.length > 0) {
       orderSnapshot.documents.forEach((element) {
         Order order = Order.fromSnapshot(snapshot: element);
         tempOrdersList.add(order);
       });
     }
   }else if(user.type=="Admin"){
     var orderSnapshot=await databaseReference
          .collection("Orders")
          .where("status", isEqualTo: 1)
          .where("adminId",isEqualTo: user.adminId)
          .where("cityID", isEqualTo: user.cityID)
          .orderBy("date", descending: true)
          .getDocuments();
     if (orderSnapshot.documents.length > 0) {
       orderSnapshot.documents.forEach((element) {
         Order order = Order.fromSnapshot(snapshot: element);
         tempOrdersList.add(order);
       });
      }

    }

    return tempOrdersList;
  }


  //category
  addCategory(String name,String city,String cityID,String state) async {
    if (uid == null) {
      getUserId();
    }
    var data = {
      "createdDate": DateTime.now().millisecondsSinceEpoch,
      "adminId": user.adminId,
      "name":name,
      "city": city,
      "cityID":cityID,
      "state": state,
      "status": 1
    };

    await databaseReference.collection("Counters").document("category").updateData({"count":FieldValue.increment(1)});

    var index=await databaseReference.collection("Counters").document("category").get();

    return databaseReference.collection("Category").document("${index.data["count"]}").setData(data);
  }

  editCategory(String id,String name,String cityID,String city,String state) async {
    if (uid == null) {
      await getUserId();
    }
    var data = {
      "adminId": user.adminId,
      "name": name,
      "cityID": cityID,
      "city": city,
      "state":state,
      "status": 1
    };

    return databaseReference.collection("Category").document(id).updateData(data);
  }

  Future<List<Category>> getCategoriesOnce() async{
    List<Category> categoryList=List();
    var snapshot=await databaseReference
        .collection("Category")
        .where("adminId",isEqualTo: user.adminId)
        .where("status", isEqualTo: 1)
        .getDocuments();

    if (snapshot.documents.length > 0) {
      snapshot.documents.forEach((element) {
        Category order = Category.fromSnapshot(snapshot: element);
        categoryList.add(order);
      });
    }
    return categoryList;
  }

  //products
  addProduct(String name,String city,String cityID,String state,String categoryId,String category) async {
    if (uid == null) {
      getUserId();
    }
    var data = {
      "createdDate": DateTime.now().millisecondsSinceEpoch,
      "adminId": user.adminId,
      "name":name,
      "city": city,
      "cityID":cityID,
      "state": state,
      "categoryId":categoryId,
      "category":category,
      "status": 1
    };

    await databaseReference.collection("Counters").document("product").updateData({"count":FieldValue.increment(1)});

    var index=await databaseReference.collection("Counters").document("product").get();

    return databaseReference.collection("Products").document("${index.data["count"]}").setData(data);
  }

  editProduct(String id,String name,String cityID,String city,String state,String categoryId,String category) async {
    if (uid == null) {
      await getUserId();
    }
    var data = {
      "adminId": user.adminId,
      "name": name,
      "cityID": cityID,
      "city": city,
      "state":state,
      "categoryId":categoryId,
      "category":category,
      "status": 1
    };

    return databaseReference.collection("Products").document(id).updateData(data);
  }

  Future<List<ProductModel>> getProductsOnce() async{
    List<ProductModel> categoryList=List();
    var snapshot=await databaseReference
        .collection("Products")
        .where("adminId",isEqualTo: user.adminId)
        .where("status", isEqualTo: 1)
        .getDocuments();

    if (snapshot.documents.length > 0) {
      snapshot.documents.forEach((element) {
        ProductModel order = ProductModel.fromSnapshot(snapshot: element);
        categoryList.add(order);
      });
    }
    return categoryList;
  }

  //add indent
  addIndentProduct(Product indent)async{
    return await databaseReference
        .collection('Orders')
        .document(indent.orderId)
        .collection("products")
        .document()
        .setData(indent.toJson());
  }
  Future<List<Product>> getIndentProducts(String indentId) async{
    List<Product> indentList=List();
    var snapshot=await databaseReference
        .collection('Orders')
        .document(indentId)
        .collection("products")
        .orderBy("product",descending: false)
        .getDocuments();
    if (snapshot.documents.length > 0) {
      snapshot.documents.forEach((element) {
        Product order = Product.fromSnapshot(snapshot: element);
        indentList.add(order);
      });
    }
    return indentList;
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
        .setData(data.toJson());
  }
}
