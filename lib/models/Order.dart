import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String uid, orderId,name;
  int year, month, day,status,totalItems,procuredItems;
  DateTime date,createdDate;
  Order(
      {this.uid, this.date, this.createdDate, this.year, this.month, this.day,this.status,this.totalItems,this.procuredItems});

  Order.fromSnapshot({DocumentSnapshot snapshot})
      : uid = snapshot.data['uid'],
        name=snapshot.data['name'],
        date = DateTime.fromMillisecondsSinceEpoch(snapshot.data['date']),
        createdDate = DateTime.fromMillisecondsSinceEpoch(snapshot.data['createdDate']),
        year = snapshot.data['year'],
        month = snapshot.data['month'],
        day = snapshot.data['day'],
        orderId = snapshot.documentID,
        totalItems= snapshot['totalItems'],
        procuredItems= snapshot['procuredItems'],
        status=snapshot.data['status'];
}
