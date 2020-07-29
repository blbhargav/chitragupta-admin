import 'package:chitragupta/app/Expenses/expenses_bloc.dart';
import 'package:chitragupta/app/Indent/DisplayIndent/display_indent.dart';
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


class ExpensesScreen extends StatefulWidget {
  final Repository repository;
  Function(Order) callback;
  ExpensesScreen(Repository repository,{this.callback})
      : repository = repository ?? Repository();

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen>{
  ExpensesBloc _expensesBloc;

  bool _loading=false;


  String _createIndentError="";

  List<Order> orderList=List();


  var dateFormat = DateFormat('EEEE, dd-MMM-yyy');
  @override
  void initState() {
    _expensesBloc=ExpensesBloc(repository: widget.repository);
    _expensesBloc.add(FetchOdersEvent());
    super.initState();
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => _expensesBloc,
        child: BlocListener<ExpensesBloc, ExpensesState>(
            listener: (context, state) {
              if(state is DisplayOrdersState){
                orderList=state.ordersList;
              }else if(state is ShowProgressState){
                _loading=true;
              }else if(state is HideProgressState){
                _loading=false;
              }
            },
            child: BlocBuilder<ExpensesBloc,ExpensesState>(
                cubit: _expensesBloc,
                builder: (BuildContext context, ExpensesState state){
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
                            child: Text("Expenses History",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                            onPressed: () {

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
                                    var orderDate=format.format(order.date);
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

}