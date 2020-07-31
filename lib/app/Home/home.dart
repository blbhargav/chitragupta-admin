import 'dart:async';

import 'package:chitragupta/app/Expenses/DisplayExpenses/displayOrder.dart';
import 'package:chitragupta/app/Expenses/expenses_page.dart';
import 'package:chitragupta/app/Home/home_bloc.dart';
import 'package:chitragupta/app/Indent/DisplayIndent/display_indent.dart';
import 'package:chitragupta/app/Indent/indent_page.dart';
import 'package:chitragupta/app/Team/team_list.dart';
import 'package:chitragupta/app/analytics.dart';
import 'package:chitragupta/app/City/cities.dart';
import 'package:chitragupta/app/Customers/customers_list.dart';
import 'package:chitragupta/app/category/category.dart';
import 'package:chitragupta/app/dashboard.dart';
import 'package:chitragupta/app/product/product.dart';
import 'package:chitragupta/app/settings.dart';
import 'package:chitragupta/extension/hover_extensions.dart';
import 'package:chitragupta/models/Member.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../splash_screen.dart';

class homeScreen extends StatefulWidget {
  homeScreen(Repository repository) : repository = repository ?? Repository();
  Repository repository;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<homeScreen> with TickerProviderStateMixin {

  var _selectedIndex = 0;

  DateTime currentBackPressTime;
  String userName = "Hi Guest";
  String pageName = "Dashbaord";

  StreamSubscription _subscriptionTodo;
  Member user;

  HomeBloc _homeBloc;
  Widget _container;
  @override
  void initState() {
    init();
    super.initState();
  }
  @override
  void dispose() {
    if (_subscriptionTodo != null) {
      _subscriptionTodo.cancel();
    }
    super.dispose();
  }
  var dashboardItemColor=Colors.black;
  var indentItemColor=Colors.lightBlue[900];
  var expensesItemColor=Colors.lightBlue[900];
  var analyticsItemColor=Colors.lightBlue[900];
  var historyItemColor=Colors.lightBlue[900];
  var settingsItemColor=Colors.lightBlue[900];
  var citiesItemColor=Colors.lightBlue[900];
  var customersItemColor=Colors.lightBlue[900];
  var teamItemColor=Colors.lightBlue[900];
  var aboutItemColor=Colors.lightBlue[900];
  var categoryItemColor=Colors.lightBlue[900];
  var productItemColor=Colors.lightBlue[900];

  indentCallback(Order order) {
    _homeBloc.add(DisplayIndentClickedEvent(order));
  }
  expenseCallback(Order order) {
    _homeBloc.add(DisplayExpenseClickedEvent(order));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: BlocProvider(
          create: (_) => _homeBloc,
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if(state is HomeInitial){
                resetColors();
                pageName="Dashboard";
                _container=dashBoardScreen(widget.repository);
                dashboardItemColor=Colors.black;
              }else if(state is ShowIndentState){
                resetColors();
                pageName="Indents";
                _container=IndentScreen(widget.repository,callback: indentCallback,);
                indentItemColor=Colors.black;
              }else if(state is DisplayIndentState){
                resetColors();
                pageName="Indent : ${state.order.orderId}";
                _container=DisplayIndent(widget.repository,state.order);
                indentItemColor=Colors.black;
              }else if(state is ShowExpensesState){
                resetColors();
                pageName="Expenses";
                _container=ExpensesScreen(widget.repository,callback: expenseCallback,);
                expensesItemColor=Colors.black;
              }else if(state is DisplayExpenseState){
                resetColors();
                pageName="Expense : ${state.order.orderId}";
                _container=DisplayOrderScreen(widget.repository,state.order);
                expensesItemColor=Colors.black;
              }else if(state is ShowAnalyticsState){
                resetColors();
                pageName="Analytics";
                _container=Analytics(widget.repository);
                analyticsItemColor=Colors.black;
              }else if(state is ShowSettingsState){
                resetColors();
                pageName="Settings";
                _container=Settings(widget.repository);
                settingsItemColor=Colors.black;
              }else if(state is ShowHistoryState){
                resetColors();
                pageName="History";
                _container=Container(child: Center(child: Text("History"),),);
                historyItemColor=Colors.black;
              }else if(state is ShowCitiesState){
                resetColors();
                pageName="Cities";
                _container=CitiesPage(widget.repository);
                citiesItemColor=Colors.black;
              }else if(state is ShowCustomersState){
                resetColors();
                pageName="Customers";
                _container=CustomersListPage(widget.repository);
                customersItemColor=Colors.black;
              }else if(state is ShowTeamState){
                resetColors();
                pageName="Team";
                _container=TeamListPage(widget.repository);
                teamItemColor=Colors.black;
              }else if(state is ShowCategoryState){
                resetColors();
                pageName="Categories";
                _container=CategoriesPage(widget.repository);
                categoryItemColor=Colors.black;
              }else if(state is ShowProductsState){
                resetColors();
                pageName="Products";
                _container=ProductsPage(widget.repository);
                productItemColor=Colors.black;
              }else if(state is ShowAboutState){
                resetColors();
                pageName="About";
                _container=Container(child: Center(child: Text("About"),),);
                aboutItemColor=Colors.black;
              }
            },
            child: BlocBuilder<HomeBloc,HomeState>(
              cubit: _homeBloc,
              builder: (BuildContext context, HomeState state){
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      //margin: EdgeInsets.only(top: 30,),
                      padding:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                      color: Colors.lightBlue[900],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          Card(
                              child: Padding(
                                padding: EdgeInsets.all(2),
                                child: CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: AssetImage(
                                    "assets/logo.png",
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              )),
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          Container(
                            child: Text(
                              "${userName}",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            padding: EdgeInsets.only(top: 3),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(child: Text("$pageName",
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20),),),
                          ),
                          GestureDetector(
                            child: Stack(
                              children: <Widget>[
                                new Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                ),
                                new Positioned(
                                  right: 0,
                                  child: new Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: new BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: new Text(
                                      '',
                                      style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            onTap: () {},
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: double.maxFinite,
                            color: Colors.lightBlue[900],
                            width: 200,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: double.maxFinite,
                                  color: dashboardItemColor,
                                  child: HandCursor(
                                    child: InkWell(
                                      child: Container(
                                        width: double.maxFinite,
                                        padding: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              child: Icon(Icons.home,color: Colors.white,),
                                              padding: EdgeInsets.only(right: 10,left: 10),
                                            ),
                                            Text('Dashboard',style: TextStyle(color: Colors.white,fontSize: 20),)
                                          ],
                                        ),
                                      ),
                                      onTap: (){
                                        _homeBloc.add(DashboardItemClickedEvent());
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(10),
                                  color: indentItemColor,
                                  child: HandCursor(
                                    child: InkWell(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            child: Icon(Icons.format_indent_increase,color: Colors.white,),
                                            padding: EdgeInsets.only(right: 10,left: 10),
                                          ),
                                          Text('Indent',style: TextStyle(color: Colors.white,fontSize: 20),)
                                        ],
                                      ),
                                      onTap: (){
                                        _homeBloc.add(IndentItemClickedEvent());
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(10),
                                  color: expensesItemColor,
                                  child: HandCursor(
                                    child: InkWell(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            child: Icon(Icons.track_changes,color: Colors.white,),
                                            padding: EdgeInsets.only(right: 10,left: 10),
                                          ),
                                          Text('Expenses',style: TextStyle(color: Colors.white,fontSize: 20),)
                                        ],
                                      ),
                                      onTap: (){
                                        _homeBloc.add(ExpensesItemClickedEvent());
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(10),
                                  color: analyticsItemColor,
                                  child: HandCursor(
                                    child: InkWell(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            child: Icon(Icons.insert_chart,color: Colors.white,),
                                            padding: EdgeInsets.only(right: 10,left: 10),
                                          ),
                                          Text('Analytics',style: TextStyle(color: Colors.white,fontSize: 20),)
                                        ],
                                      ),
                                      onTap: (){
                                        _homeBloc.add(AnalyticsItemClickedEvent());
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(10),
                                  color: historyItemColor,
                                  child: HandCursor(
                                    child: InkWell(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            child: Icon(Icons.history,color: Colors.white,),
                                            padding: EdgeInsets.only(right: 10,left: 10),
                                          ),
                                          Text('History',style: TextStyle(color: Colors.white,fontSize: 20),)
                                        ],
                                      ),
                                      onTap: (){
                                        _homeBloc.add(HistoryItemClickedEvent());
                                      },
                                    ),
                                  ),
                                ),
                                (Repository.user.type=="SuperAdmin")?Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(10),
                                  color: citiesItemColor,
                                  child: HandCursor(
                                    child: InkWell(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            child: Icon(Icons.location_city,color: Colors.white,),
                                            padding: EdgeInsets.only(right: 10,left: 10),
                                          ),
                                          Text('Cities',style: TextStyle(color: Colors.white,fontSize: 20),)
                                        ],
                                      ),
                                      onTap: (){
                                        _homeBloc.add(CitiesItemClickedEvent());
                                      },
                                    ),
                                  ),
                                ):Container(),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(10),
                                  color: customersItemColor,
                                  child: HandCursor(
                                    child: InkWell(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            child: Icon(Icons.people,color: Colors.white,),
                                            padding: EdgeInsets.only(right: 10,left: 10),
                                          ),
                                          Text('Customers',style: TextStyle(color: Colors.white,fontSize: 20),)
                                        ],
                                      ),
                                      onTap: (){
                                        _homeBloc.add(CustomersItemClickedEvent());
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(10),
                                  color: teamItemColor,
                                  child: HandCursor(
                                    child: InkWell(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            child: Icon(Icons.supervised_user_circle,color: Colors.white,),
                                            padding: EdgeInsets.only(right: 10,left: 10),
                                          ),
                                          Text('Team',style: TextStyle(color: Colors.white,fontSize: 20),)
                                        ],
                                      ),
                                      onTap: (){
                                        _homeBloc.add(TeamItemClickedEvent());
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(10),
                                  color: categoryItemColor,
                                  child: HandCursor(
                                    child: InkWell(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            child: Icon(Icons.category,color: Colors.white,),
                                            padding: EdgeInsets.only(right: 10,left: 10),
                                          ),
                                          Text('Categories',style: TextStyle(color: Colors.white,fontSize: 20),)
                                        ],
                                      ),
                                      onTap: (){
                                        _homeBloc.add(CategoryItemClickedEvent());
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(10),
                                  color: productItemColor,
                                  child: HandCursor(
                                    child: InkWell(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            child: Icon(Icons.folder,color: Colors.white,),
                                            padding: EdgeInsets.only(right: 10,left: 10),
                                          ),
                                          Text('Products',style: TextStyle(color: Colors.white,fontSize: 20),)
                                        ],
                                      ),
                                      onTap: (){
                                        _homeBloc.add(ProductsClickedEvent());
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(10),
                                  color: aboutItemColor,
                                  child: HandCursor(
                                    child: InkWell(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            child: Icon(Icons.info,color: Colors.white,),
                                            padding: EdgeInsets.only(right: 10,left: 10),
                                          ),
                                          Text('About',style: TextStyle(color: Colors.white,fontSize: 20),)
                                        ],
                                      ),
                                      onTap: (){
                                        _homeBloc.add(AboutItemClickedEvent());
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(10),
                                  child: HandCursor(
                                    child: InkWell(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            child: Icon(Icons.exit_to_app,color: Colors.white,),
                                            padding: EdgeInsets.only(right: 10,left: 10),
                                          ),
                                          Text('Logout',style: TextStyle(color: Colors.white,fontSize: 20),)
                                        ],
                                      ),
                                      onTap: (){
                                        showLogoutAlert();
                                      },
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: _container,
                              margin: EdgeInsets.all(10),
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            )
          ),
        ),


      ),
      onWillPop: () async {
        if (_selectedIndex > 0) {
          setState(() {
            _selectedIndex = 0;
          });
          return false;
        } else {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime) > Duration(seconds: 2)) {
            currentBackPressTime = now;
            Fluttertoast.showToast(msg: "Press again to exist.");
            return Future.value(false);
          }
          return Future.value(true);
        }
      },
    );
  }
  void showLogoutAlert() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Are you sure to Logout?",style: TextStyle(fontSize: 25)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RaisedButton(
                  child: new Text("Logout",style: TextStyle(fontSize: 20,color: Colors.white),),
                  color: Colors.lightBlue[900],
                  onPressed: () {
                    Navigator.of(context).pop();
                    _logout();
                  },
                ),
                Padding(padding: EdgeInsets.all(10),),
                InkWellMouseRegion(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text("Cancel",style: TextStyle(color: Colors.lightBlue[900]),),
                  ),
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(5),),
              ],
            ),
//            actions: <Widget>[
//              // usually buttons at the bottom of the dialog
//              RaisedButton(
//                child: new Text("Logout",style: TextStyle(fontSize: 20,color: Colors.white),),
//                color: Colors.lightBlue[900],
//                onPressed: () {
//                  Navigator.of(context).pop();
//                  _logout();
//                },
//              ),
//              Padding(padding: EdgeInsets.all(5),),
//              RaisedButton(
//                child: new Text("No",style: TextStyle(fontSize: 20)),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              ),
//            ],
          );
        });
  }

  Future _logout() async {
    await widget.repository.signOut();
    await widget.repository.updateUserSignedLocally(false,"");

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen(repository: widget.repository,)),
        ModalRoute.withName("/Splash"));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void init() {
    _homeBloc=HomeBloc(repository: widget.repository);
    _container=dashBoardScreen(widget.repository);
    widget.repository.getUserId();
    widget.repository.getProfile().then((value) {
      setState(() {
        user = new Member.fromSnapshot(snapshot: value);
        userName=user.name;
      });
    });
  }

  void resetColors() {
    dashboardItemColor=Colors.lightBlue[900];
    indentItemColor=Colors.lightBlue[900];
    expensesItemColor=Colors.lightBlue[900];
    analyticsItemColor=Colors.lightBlue[900];
    historyItemColor=Colors.lightBlue[900];
    settingsItemColor=Colors.lightBlue[900];
    citiesItemColor=Colors.lightBlue[900];
    customersItemColor=Colors.lightBlue[900];
    teamItemColor=Colors.lightBlue[900];
    aboutItemColor=Colors.lightBlue[900];
    categoryItemColor=Colors.lightBlue[900];
    productItemColor=Colors.lightBlue[900];
  }
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];
