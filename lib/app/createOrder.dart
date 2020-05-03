import 'package:chitragupta/login.dart';
import 'package:chitragupta/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddOrderScreen extends StatefulWidget {
  Repository repository;
  AddOrderScreen(Repository repository): repository = repository ?? Repository();
  @override
  _AddOrderScreenState createState() => _AddOrderScreenState(repository: repository);
}
class _AddOrderScreenState extends State<AddOrderScreen> {
  Repository repository;
  _AddOrderScreenState({Repository repository}):repository= repository ?? Repository();

  final globalKey = GlobalKey<ScaffoldState>();

  TextEditingController _amountController = new TextEditingController();
  TextEditingController _spendController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  List<Color> saveGradient = [
    Color(0xFF0EDED2),
    Color(0xFF03A0FE),
  ];
  bool _laoding = false;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        child: Scaffold(
          resizeToAvoidBottomPadding: true,
          key: globalKey,
          appBar: AppBar(
            title: Text("Add Order"),
            backgroundColor: Colors.lightBlue[900],
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(5),
            child: Center(
              child: Container(
                width: 400,
                child: ListView(
                  reverse: false,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: new TextField(
                        controller: this._descriptionController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: "Description",
                          prefixIcon: Icon(Icons.description),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                        ),
                      ),
                    ),
//                Padding(
//                  padding: EdgeInsets.only(left: 10, right: 10),
//                  child: new TextField(
//                    controller: this._amountController,
//                    decoration: InputDecoration(
//                        labelText: "Amount *",
//                        prefixText: "₹",
//                        prefixIcon: Icon(Icons.monetization_on),
//                        enabledBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(color: Colors.cyan),
//                        ),
//                        focusedBorder: UnderlineInputBorder(
//                          borderSide: BorderSide(color: Colors.indigo),
//                        ),
//                        //errorText: amountErrorTV
//                    ),
//                    keyboardType: TextInputType.numberWithOptions(decimal: true),
//                  ),
//                ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: new TextField(
                        controller: this._descriptionController,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Po Qty",
                          prefixIcon: Icon(Icons.description),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: new TextField(
                        controller: this._amountController,
                        decoration: InputDecoration(
                          labelText: "Our Qty",
                          prefixIcon: Icon(Icons.star),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                          //errorText: amountErrorTV
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: new TextField(
                        controller: this._amountController,
                        decoration: InputDecoration(
                          labelText: "Used Qty",
                          prefixIcon: Icon(Icons.star),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                          //errorText: amountErrorTV
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: new TextField(
                        controller: this._amountController,
                        decoration: InputDecoration(
                          labelText: "Purchased Qty",
                          prefixIcon: Icon(Icons.star),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                          //errorText: amountErrorTV
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: new TextField(
                        controller: this._amountController,
                        decoration: InputDecoration(
                          labelText: "Actual Excess Qty",
                          prefixIcon: Icon(Icons.star),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                          //errorText: amountErrorTV
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: new TextField(
                        controller: this._amountController,
                        decoration: InputDecoration(
                          labelText: "EOD Excess",
                          prefixIcon: Icon(Icons.star),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                          //errorText: amountErrorTV
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: new TextField(
                        controller: this._amountController,
                        decoration: InputDecoration(
                          labelText: "Amount Spent",
                          prefixText: "₹",
                          prefixIcon: Icon(Icons.star),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                          //errorText: amountErrorTV
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: new TextField(
                        controller: this._amountController,
                        decoration: InputDecoration(
                          labelText: "Return Qty",
                          prefixIcon: Icon(Icons.star),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                          //errorText: amountErrorTV
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: new TextField(
                        controller: this._amountController,
                        decoration: InputDecoration(
                          labelText: "Invoice Amount",
                          prefixText: "₹",
                          prefixIcon: Icon(Icons.star),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                          //errorText: amountErrorTV
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: new TextField(
                        controller: this._spendController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: "Remarks",
                          prefixIcon: Icon(Icons.info),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.indigo),
                          ),
                          //errorText: titleErrorTV
                        ),
                        maxLength: 50,
                        maxLengthEnforced: true,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(top: 5),
                    ),
                    GestureDetector(
                      child: Center(
                        child: roundedRectButton("Save", saveGradient, false),
                      ),
                      onTap: () {
                        //validate(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        opacity: 0.5,
        inAsyncCall: _laoding);
  }
}