import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';

class Analytics extends StatefulWidget {
  Analytics(Repository repository) : repository = repository ?? Repository();
  Repository repository;
  @override
  _analyticsState createState() => _analyticsState(repository);
}

class _analyticsState extends State<Analytics> {
  _analyticsState(Repository repository)
      : repository = repository ?? Repository();
  Repository repository;


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Analytics',
            textAlign: TextAlign.center,

          ),
          bottom: TabBar(
            tabs: [
              Tab(text: "Month",),
              Tab(text: "Year",),
              Tab(text: "All",)
            ],
          ),
          centerTitle: true,
          backgroundColor: Colors.lightBlue[900],
        ),
        body:TabBarView(children: [
          Container(),
          Container(),
          Container(),
        ]),
      ),
    );
  }


}


