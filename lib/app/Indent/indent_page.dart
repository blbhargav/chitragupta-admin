import 'package:chitragupta/app/Indent/indent_bloc.dart';
import 'package:chitragupta/extension/hover_extensions.dart';
import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;


class IndentScreen extends StatefulWidget {
  final Repository repository;
  IndentScreen(Repository repository)
      : repository = repository ?? Repository();

  @override
  _IndentScreenState createState() => _IndentScreenState();
}

class _IndentScreenState extends State<IndentScreen>{
  IndentBloc _indentBloc;
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _indentDateController = new TextEditingController();
  TextEditingController _indentCustomerController = new TextEditingController();

  String _createOrderErrorTV = null,_createNameErrorTV = null;
  DateTime _currentDate=DateTime.now();

  bool _loading=false;
  @override
  void initState() {
    _indentBloc=IndentBloc(repository: widget.repository);
    super.initState();
  }
  
  @override
  void dispose() {
    _indentDateController.dispose();
    _indentCustomerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        body: BlocProvider(
          create: (_) => _indentBloc,
          child: BlocListener<IndentBloc, IndentState>(
              listener: (context, state) {

              },
              child: BlocBuilder<IndentBloc,IndentState>(
                  bloc: _indentBloc,
                  builder: (BuildContext context, IndentState state){
//              if(state is IndentInitial)
//                return Center(child: CircularProgressIndicator(),);

                    return Column(
                      children: [
//                  Align(child: Text("Indents",style: TextStyle(color: Colors.lightBlue[900],fontSize: 25,fontWeight: FontWeight.w700),),
//                    alignment: Alignment.center,),

                        Align(
                          child: RaisedButton(
                            hoverColor: Colors.red,
                            child: Text("+Create Indent",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                            onPressed: () {
                              showAlertDialog(context);
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
                                child: Text("ID",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text("Customer",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                flex: 2,
                              ),
                              Expanded(
                                child: Text("Order Date",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text("Status",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text("Action",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
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
                      ],
                    );
                  }
              )
          ),

        ),
      ),
      inAsyncCall: _loading,
      opacity: 0.4,
    );
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

                  (Repository.user.role=="SuperAdmin")?Container(
                    margin: EdgeInsets.only(top: 10,bottom: 10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._cityController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "City",
                        prefixIcon: Icon(Icons.location_on),
                        errorText: _createNameErrorTV,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                  ):Container(),
                  Container(
                    margin: EdgeInsets.only(top: 10,bottom: 10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._indentCustomerController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "Customer Name",
                        prefixIcon: Icon(Icons.business_center),
                        errorText: _createOrderErrorTV,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                  ),
//                  Container(
//                    margin: EdgeInsets.only(top: 10,bottom: 10),
//                    padding: EdgeInsets.only(left: 10, right: 10),
//                    child: new TextField(
//                      controller: this._indentDateController,
//                      textCapitalization: TextCapitalization.sentences,
//                      decoration: InputDecoration(
//                        labelText: "Order Date",
//                        prefixIcon: Icon(Icons.calendar_today),
//                        errorText: _createOrderErrorTV,
//                        enabledBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(color: Colors.cyan),
//                        ),
//                        focusedBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(color: Colors.indigo),
//                        ),
//                      ),
//                    ),
//                  ),

                  Container(
                    child: CalendarCarousel<Event>(
                      onDayPressed: (DateTime date, List<Event> events) {
                        _currentDate = date;
                        Navigator.pop(contxt);
                        showAlertDialog(contxt);
                      },
                      weekendTextStyle: TextStyle(
                        color: Colors.red,
                      ),
                      thisMonthDayBorderColor: Colors.grey,
                      //      weekDays: null, /// for pass null when you do not want to render weekDays
                      //      headerText: Container( /// Example for rendering custom header
                      //        child: Text('Custom Header'),
                      //      ),
                      customDayBuilder: (   /// you can provide your own build function to make custom day containers
                          bool isSelectable,
                          int index,
                          bool isSelectedDay,
                          bool isToday,
                          bool isPrevMonthDay,
                          TextStyle textStyle,
                          bool isNextMonthDay,
                          bool isThisMonthDay,
                          DateTime day,
                          ) {
                        /// If you return null, [CalendarCarousel] will build container for current [day] with default function.
                        /// This way you can build custom containers for specific days only, leaving rest as default.

                        // Example: every 15th of month, we have a flight, we can place an icon in the container like that:
//                      if (day.day == 15) {
//                        return Center(
//                          child: Icon(Icons.local_airport),
//                        );
//                      } else {
//                        return null;
//                      }
                        return null;
                      },
                      weekFormat: false,
                      //markedDatesMap: _markedDateMap,
                      height: 450.0,
                      selectedDateTime: _currentDate,
                      minSelectedDate: DateTime.now(),
                      daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
                    ),
                  ),

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
                        createOrder(_indentDateController.text);
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

  void createOrder(String date) {
    if (date.length < 10) {
      setState(() {
        _createOrderErrorTV = "Please enter date in dd-MM-yyyy format";
      });
      showAlertDialog(context);
    } else {
      setState(() {
        _loading = false;
      });
      //widget.repository.createOrder(date,_orderNameController.text);
    }
  }


}