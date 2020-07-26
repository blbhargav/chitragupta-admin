import 'package:chitragupta/app/Indent/DisplayIndent/display_indent_bloc.dart';
import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayIndent extends StatefulWidget {
  final Repository repository;
  final String orderID;
  DisplayIndent(Repository repository,String orderId)
      : repository = repository ?? Repository(),orderID=orderId;

  @override
  _DisplayIndentState createState() => _DisplayIndentState();
}

class _DisplayIndentState extends State<DisplayIndent>{
  DisplayIndentBloc _indentBloc;
  bool _loading=false;
  @override
  void initState() {
    _indentBloc=DisplayIndentBloc(repository: widget.repository,orderID: widget.orderID);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
          create: (_) => _indentBloc,
          child: BlocListener<DisplayIndentBloc, DisplayIndentState>(
            listener: (context, state) {

            },
            child: BlocBuilder<DisplayIndentBloc,DisplayIndentState>(
              cubit: _indentBloc,
              builder: (BuildContext context, DisplayIndentState state){
                if(state is DisplayIndentInitial)
                  return Center(child: CircularProgressIndicator(),);

                return ProgressHUD(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          RaisedButton(
                            hoverColor: Colors.red,
                            child: Text("Back",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                            onPressed: () {
                            },
                            color: Colors.lightBlue[900],
                          ),
                          Spacer(),
                          RaisedButton(
                            hoverColor: Colors.red,
                            child: Text("Import Indent",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                            onPressed: () {
                              //_indentBloc.add(CreateIndentButtonClickedEvent());
                            },
                            color: Colors.lightBlue[900],
                          ),
                          RaisedButton(
                            hoverColor: Colors.red,
                            child: Text("+Add Product",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                            onPressed: () {
                             // _indentBloc.add(CreateIndentButtonClickedEvent());
                            },
                            color: Colors.lightBlue[900],
                          ),
                        ],
                      ),
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
                              child: Text("Product",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              flex: 2,
                            ),
                            Expanded(
                              child: Text("",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              flex: 1,
                            ),
                            Expanded(
                              child: Text("Created at",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              flex: 1,
                            ),
                            Expanded(
                              child: Center(
                                child: Text("Action",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
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

                    ],
                  ),
                  inAsyncCall: _loading,
                  opacity: 0.4,
                );
              }
            ),
          )
        )
    );
  }
}