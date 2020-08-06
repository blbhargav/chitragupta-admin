import 'package:chitragupta/app/Indent/DisplayIndent/display_indent.dart';
import 'package:chitragupta/app/Indent/indent_bloc.dart';
import 'package:chitragupta/extension/hover_extensions.dart';
import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/models/customer.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:intl/intl.dart';


class IndentScreen extends StatefulWidget {
  final Repository repository;
  Function(Order) callback;
  IndentScreen(Repository repository,{this.callback})
      : repository = repository ?? Repository();

  @override
  _IndentScreenState createState() => _IndentScreenState();
}

class _IndentScreenState extends State<IndentScreen>{
  IndentBloc _indentBloc;
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _indentDateController = new TextEditingController();
  TextEditingController _indentCustomerController = new TextEditingController();
  DateTime _currentDate=DateTime.now();

  bool _loading=false;

  List<City> cityList = new List();
  List<String> cityNames = new List();
  String selectedCity="Select City";

  List<Customer> customersList = new List();
  List<String> customersNames = new List();
  String selectedCustomer="Select Customer";

  String _createIndentError="";

  List<Order> orderList=List();

  List<String> datesList = new List();
  String selectedDate="Select Order Date";

  var dateFormat = DateFormat('EEEE, dd-MMM-yyy');
  @override
  void initState() {
    _indentBloc=IndentBloc(repository: widget.repository);
    _indentBloc.add(FetchOdersEvent());
    _indentBloc.add(FetchCitiesEvent());
    _indentBloc.add(FetchCustomersEvent());
    super.initState();

    var now=DateTime.now();

    datesList.add(dateFormat.format(now));
    datesList.add(dateFormat.format(DateTime(now.year, now.month, now.day + 1)));
    datesList.add(dateFormat.format(DateTime(now.year, now.month, now.day + 2)));
    datesList.add(dateFormat.format(DateTime(now.year, now.month, now.day + 3)));
    datesList.add(dateFormat.format(DateTime(now.year, now.month, now.day + 4)));
    datesList.add(dateFormat.format(DateTime(now.year, now.month, now.day + 5)));
    datesList.add(dateFormat.format(DateTime(now.year, now.month, now.day + 6)));
  }
  
  @override
  void dispose() {
    _indentDateController.dispose();
    _indentCustomerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => _indentBloc,
        child: BlocListener<IndentBloc, IndentState>(
            listener: (context, state) {
              if(state is DisplayOrdersState){
                orderList=state.ordersList;
              }else if(state is LoadCitiesState){
                cityList=state.cityList;
                cityNames.clear();
                cityList.forEach((element) {
                  cityNames.add(element.city);
                });
              }else if(state is LoadCustomersState){
                customersList=state.customersList;
                customersNames.clear();
                customersList.forEach((element) {
                  customersNames.add(element.name);
                });
              }else if(state is ShowCreateIndentState){
                _createIndentError=state.error;
                showAlertDialog(context);
                _indentBloc.add(ChangeStateEvent());
              }else if(state is ShowProgressState){
                _loading=true;
              }else if(state is HideProgressState){
                _loading=false;
              }else if(state is ResetFormState){
                selectedCity="Select City";
                selectedCustomer="Select Customer";
                _currentDate=DateTime.now();
              }
            },
            child: BlocBuilder<IndentBloc,IndentState>(
                cubit: _indentBloc,
                builder: (BuildContext context, IndentState state){
                  if(state is InitialLoadingState)
                    return Center(child: CircularProgressIndicator(),);

                  return ProgressHUD(
                    child: Column(
                      children: [
//                  Align(child: Text("Indents",style: TextStyle(color: Colors.lightBlue[900],fontSize: 25,fontWeight: FontWeight.w700),),
//                    alignment: Alignment.center,),

                        Align(
                          child: RaisedButton(
                            hoverColor: Colors.red,
                            child: Text("+Create Indent",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                            onPressed: () {
                              _indentBloc.add(CreateIndentButtonClickedEvent());
                            },
                            color: Colors.lightBlue[900],
                          ),
                          alignment: Alignment.topRight,),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.all(10),
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text("ID",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text("Customer",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                flex: 2,
                              ),
                              Expanded(
                                child: Text("Order Date",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text("Created at",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                flex: 1,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text("Action",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                ),
                                flex: 1,
                              ),
//                              Expanded(
//                                child: InkWell(
//                                  child: Icon(Icons.delete,color: Colors.red,),
//                                ),
//                                flex: 1,
//                              ),
                            ],
                          ),
                        ),

                        (orderList.length > 0)
                            ? Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 3,left: 2,right: 2),
                                padding: EdgeInsets.all(5),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder: (BuildContext context, int index) {
                                    return Padding(
                                      child: Divider(thickness: 1,),
                                      padding: EdgeInsets.only(top: 5, bottom: 5),
                                    );
                                  },
                                  itemCount: orderList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    Order order=orderList[index];
                                    var format = DateFormat('dd-MMM-yyy hh:mm a');
                                    var createdDate=format.format(order.createdDate);
                                    var orderDate=dateFormat.format(order.date);
                                    return InkWellMouseRegion(
                                      child: Container(
                                        padding: EdgeInsets.only(top: 15,bottom: 15,left: 5),
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text("${order.orderId}",style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w400,fontSize: 16),textAlign:TextAlign.center ,),
                                              flex: 1,
                                            ),
                                            Expanded(
                                              child: Text("${order.name}",style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w400,fontSize: 16),textAlign:TextAlign.center ,),
                                              flex: 2,
                                            ),
                                            Expanded(
                                              child: Text("$orderDate",style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w400,fontSize: 16),textAlign:TextAlign.center ,),
                                              flex: 1,
                                            ),
                                            Expanded(
                                              child: Text("$createdDate",style: TextStyle(color: Colors.black,
                                                  fontWeight: FontWeight.w400,fontSize: 16),textAlign:TextAlign.center ,),
                                              flex: 1,
                                            ),
                                            Expanded(
                                              child: InkWellMouseRegion(
                                                child: Icon(Icons.delete,color: Colors.red,),
                                                onTap: (){
                                                  showDeleteIndentDialog(context,order);
                                                },
                                              ),
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: (){
                                        widget.callback(order);
                                      },
                                    );
                                  },
                                ),
                              ),
                            )
                            : Expanded(
                          child: Center(
                            child: Text("No Active Orders Found"),
                          ),

                        )
                      ],
                    ),
                    opacity: 0.4,
                    inAsyncCall: _loading,
                  );
                }
            )
        ),

      ),
    );
  }

  showDeleteIndentDialog(BuildContext contxt, Order order) {
    var orderDate=dateFormat.format(order.date);
    return showDialog(
        context: contxt,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 500.0,
              padding:
              EdgeInsets.only(top: 10, right: 15, bottom: 10, left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "Delete ${order.name} Indent?",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.lightBlue[900]),
                          ),
                        ),
                      ),
                      HandCursor(
                        child: GestureDetector(
                          child: Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 30),
                    padding: EdgeInsets.only(left: 10, right: 10,bottom: 10,top: 10),
                    child: Text("Are you sure you want to delete ${order.name} order on $orderDate ?"),
                  ),
                  SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: RaisedButton(
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      color: Colors.lightBlue[900],
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      onPressed: () {
                        Navigator.pop(contxt);
                        _indentBloc.add(DeleteIndentClickedEvent(order));
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  HandCursor(
                    child: InkWell(
                      child: Container(
                        child: Text("Cancel"),
                        margin: EdgeInsets.only(top: 10,bottom: 5),
                        padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                      ),
                      onTap: (){
                        Navigator.pop(contxt);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  showAlertDialog(BuildContext contxt) {
    return showDialog(
        context: contxt,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 500.0,
              padding:
              EdgeInsets.only(top: 10, right: 15, bottom: 10, left: 15),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "Create Order",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,color: Colors.lightBlue[900]),
                          ),
                        ),
                      ),
                      HandCursor(
                        child: GestureDetector(
                          child: Icon(Icons.cancel,color: Colors.red,),
                          onTap: (){
                            Navigator.pop(context);
                          },
                        ),
                      )

                    ],
                  ),

                  (Repository.user.type=="SuperAdmin")? Container(
                    child: HandCursor(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(color: Colors.pinkAccent,height: 1,width: double.maxFinite,),
                        items: cityNames.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        hint: selectedCity=="Select City"?Text("$selectedCity"):Text("$selectedCity",style: TextStyle(color: Colors.black),),
                        onChanged: (_val) {
                          selectedCity=_val;
                          Navigator.pop(contxt);
                          _createIndentError="";
                          showAlertDialog(contxt);
                        },
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
                    margin: EdgeInsets.only(bottom: 10,left: 5,right: 5),
                  ):Container(),
                  Container(
                    child: HandCursor(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(color: Colors.pinkAccent,height: 1,width: double.maxFinite,),
                        items: customersNames.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        hint: selectedCustomer=="Select Customer"?Text("$selectedCustomer"):Text("$selectedCustomer",style: TextStyle(color: Colors.black),),
                        onChanged: (_val) {
                          selectedCustomer=_val;
                          _createIndentError="";
                          Navigator.pop(contxt);
                          showAlertDialog(contxt);
                        },
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
                    margin: EdgeInsets.only(bottom: 10,left: 5,right: 5),
                  ),

                  Container(
                    child: HandCursor(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(color: Colors.pinkAccent,height: 1,width: double.maxFinite,),
                        items: datesList.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        hint: selectedDate=="Select Order Date"?Text("$selectedDate"):Text("$selectedDate",style: TextStyle(color: Colors.black),),
                        onChanged: (_val) {
                          selectedDate=_val;
                          _currentDate=dateFormat.parse(selectedDate);
                          Navigator.pop(contxt);
                          _createIndentError="";
                          showAlertDialog(contxt);
                        },
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
                    margin: EdgeInsets.only(bottom: 10,left: 5,right: 5,top: 5),
                  ),

//                  Container(
//                    child: CalendarCarousel<Event>(
//                      onDayPressed: (DateTime date, List<Event> events) {
//                        _currentDate = date;
//                        Navigator.pop(contxt);
//                        showAlertDialog(contxt);
//                      },
//                      weekendTextStyle: TextStyle(
//                        color: Colors.red,
//                      ),
//                      thisMonthDayBorderColor: Colors.grey,
//                      //      weekDays: null, /// for pass null when you do not want to render weekDays
//                      //      headerText: Container( /// Example for rendering custom header
//                      //        child: Text('Custom Header'),
//                      //      ),
//                      customDayBuilder: (   /// you can provide your own build function to make custom day containers
//                          bool isSelectable,
//                          int index,
//                          bool isSelectedDay,
//                          bool isToday,
//                          bool isPrevMonthDay,
//                          TextStyle textStyle,
//                          bool isNextMonthDay,
//                          bool isThisMonthDay,
//                          DateTime day,
//                          ) {
//                        /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
//                        /// This way you can build custom containers for specific days only, leaving rest as default.
//
//                        // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
////                      if (day.day == 15) {
////                        return Center(
////                          child: Icon(Icons.local_airport),
////                        );
////                      } else {
////                        return null;
////                      }
//                        return null;
//                      },
//                      weekFormat: false,
//                      //markedDatesMap: _markedDateMap,
//                      height: 450.0,
//                      selectedDateTime: _currentDate,
//                      minSelectedDate: DateTime.now(),
//                      maxSelectedDate: DateTime.now().add(Duration(days: 7)),
//                      daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
//                    ),
//                  ),

                  _createIndentError.isNotEmpty?Center(
                    child: Padding(child: Text("$_createIndentError",style: TextStyle(color: Colors.red),),padding: EdgeInsets.all(10),),
                  ):Container(),

                  SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: RaisedButton(
                      child: Text(
                        "Create",
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      color: Colors.blue[900],
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      onPressed: () {
                        Navigator.pop(contxt);
                        _indentBloc.add(CreateIndentEvent(city: selectedCity,customer: selectedCustomer,orderDate: _currentDate));
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                ],
              ),
            ),
          );
        });
  }



}