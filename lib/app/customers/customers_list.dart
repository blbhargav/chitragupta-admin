import 'package:chitragupta/app/customers/customers_bloc.dart';
import 'package:chitragupta/extension/hover_extensions.dart';
import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomersListPage extends StatefulWidget {
  final Repository repository;
  CustomersListPage(this.repository);

  @override
  _CustomersListPageState createState() => _CustomersListPageState();
}

class _CustomersListPageState extends State<CustomersListPage> {
  bool _loading = false;
  CustomersBloc _bloc;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();

  String _nameErrorTV = "", _emailErrorTV = "",_mobileErrorTV = "",_addressErrorTV = "",_commonError = "";

  List<City> cityList = new List();
  List<String> cityNames = new List();
  String selectedCity="Select City";
  @override
  void initState() {
    _bloc=CustomersBloc(repository: widget.repository);
    _bloc.add(FetchCitiesEvent());
    super.initState();
  }
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => _bloc,
        child: BlocListener<CustomersBloc, CustomersState>(
            listener: (context, state) {
              if(state is LoadCitiesState){
                cityList=state.cityList;
                cityNames.clear();
                cityList.forEach((element) {
                  cityNames.add(element.city);
                });
              }else if(state is ShowProgressState){
                _loading=true;
              }else if(state is HideProgressState){
                _loading=false;
              }
            },
            child: BlocBuilder<CustomersBloc, CustomersState>(
                bloc: _bloc,
                builder: (BuildContext context, CustomersState state) {
//                  if (state is CustomersInitial)
//                    return Center(
//                      child: CircularProgressIndicator(),
//                    );
                  return ProgressHUD(
                    child: Column(
                      children: [
//                  Align(child: Text("Indents",style: TextStyle(color: Colors.lightBlue[900],fontSize: 25,fontWeight: FontWeight.w700),),
//                    alignment: Alignment.center,),

                        Align(
                          child: RaisedButton(
                            hoverColor: Colors.red,
                            child: Text(
                              "+Add Customer",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {
                             showAlertDialog(context);
                            },
                            color: Colors.lightBlue[900],
                          ),
                          alignment: Alignment.topRight,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.all(10),
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "Customer",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                flex: 2,
                              ),

                              Expanded(
                                child: Text(
                                  "Mobile",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                flex: 1,
                              ),
                              Expanded(
                                child: Text(
                                  "Address",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "Action",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                flex: 1,
                              ),
                            ],
                          ),
                        ),


                      ],
                    ),
                    inAsyncCall: _loading,
                    opacity: 0.4,
                  );
                })),
      ),
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
                            "Add Customer",
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
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.business_center),
                        errorText: _nameErrorTV,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._mobileController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "Mobile",
                        prefixIcon: Icon(Icons.mobile_screen_share),
                        errorText: _mobileErrorTV,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._emailController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        errorText: _emailErrorTV,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                  ),
                  Container(
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
                          showAlertDialog(contxt);
                        },
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
                    margin: EdgeInsets.only(bottom: 10,left: 5,right: 5),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._addressController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "Address",
                        prefixIcon: Icon(Icons.location_on),
                        errorText: _addressErrorTV,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                  ),

                  _commonError.isNotEmpty?Container(
                    child: Center(child: Text("$_commonError",style: TextStyle(color: Colors.red),),),
                  ):Container(),

                  SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: RaisedButton(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      color: Colors.blue[900],
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      onPressed: () {
                        Navigator.pop(contxt);
                        addCustomer();
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

  void addCustomer() {
    var error="Please enter this field";
    _nameErrorTV = ""; _emailErrorTV = "";_mobileErrorTV = "";_addressErrorTV = "";_commonError = "";
    if(_nameController.text.isEmpty){
      _nameErrorTV=error;
      showAlertDialog(context);
      return;
    }

    if(_mobileController.text.isEmpty){
      _mobileErrorTV=error;
      showAlertDialog(context);
      return;
    }

    if(_emailController.text.isEmpty){
      _emailErrorTV=error;
      showAlertDialog(context);
      return;
    }

    if(_addressController.text.isEmpty){
      _addressErrorTV=error;
      showAlertDialog(context);
      return;
    }

    if(selectedCity=="Select City"){
      _commonError=error;
      showAlertDialog(context);
      return;
    }
    var index=cityNames.indexWhere((note) => note.startsWith(selectedCity));
    City city=cityList[index];
    _bloc.add(AddCustomerEvent(
      name: _nameController.text,
      mobile: _mobileController.text,
      email: _emailController.text,
      address: _addressController.text,
      city: city.city,
      state: city.state,
      cityID: city.cityID
    ));
  }
}