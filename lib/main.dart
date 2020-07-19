import 'package:chitragupta/repository.dart';
import 'package:chitragupta/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
//this line make sure all the required widgets are loaded before main application starts
WidgetsFlutterBinding.ensureInitialized();

//Initializing repository and carrying forward to avoid multiple instances of database
  Repository _repository=Repository();
  runApp(MyApp(repository: _repository,));
}

class MyApp extends StatelessWidget {
  final Repository repository;
  MyApp({this.repository});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.pink),
      home: SplashScreen(repository: repository,),
    );
  }
}