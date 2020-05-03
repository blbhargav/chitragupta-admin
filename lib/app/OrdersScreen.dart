import 'dart:async';

import 'package:chitragupta/app/addTransaction.dart';
import 'package:chitragupta/app/createOrder.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen(Repository repository) : repository = repository ?? Repository();
  Repository repository;
  @override
  _OrderScreenState createState() => _OrderScreenState(repository);
}

class _OrderScreenState extends State<OrderScreen> {
  Repository repository;

  StreamSubscription _subscriptionTodo;

  _OrderScreenState(Repository repository)
      : repository = repository ?? Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        backgroundColor: Colors.lightBlue[900],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Image.asset(
          'assets/feather.png',
          height: 35,
          width: 35,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddOrderScreen(repository)),
          );
        },
      ),

    );
  }
}
