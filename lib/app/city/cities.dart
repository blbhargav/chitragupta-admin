import 'package:chitragupta/app/city/city_bloc.dart';
import 'package:chitragupta/extension/hover_extensions.dart';
import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CitiesPage extends StatefulWidget {
  final Repository repository;
  CitiesPage(this.repository);

  @override
  _CitiesPageState createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {
  bool _loading = false;
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _stateController = new TextEditingController();
  String _cityErrorTV = "", _stateErrorTV = "";

  List<City> cityList = new List();
  CityBloc _cityBloc;
  @override
  void dispose() {
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _cityBloc = CityBloc(repository: widget.repository);
    _cityBloc.add(InitStateEvent());
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => _cityBloc,
        child: BlocListener<CityBloc, CityState>(
            listener: (context, state) {
              if (state is DisplayDataState) {
                cityList = state.cityList;
              }else if(state is AddingSuccessState){
                _cityController.text="";
                _stateController.text="";
                _cityBloc.add(InitStateEvent());
              }else if(state is AddingFailedState){

              }else if(state is ShowProgressState){
                _loading=true;
              }else if(state is HideProgressState){
                _loading=false;
              }
            },
            child: BlocBuilder<CityBloc, CityState>(
                bloc: _cityBloc,
                builder: (BuildContext context, CityState state) {
                  if (state is CityInitial)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  return ProgressHUD(
                    child: Column(
                      children: [
//                  Align(child: Text("Indents",style: TextStyle(color: Colors.lightBlue[900],fontSize: 25,fontWeight: FontWeight.w700),),
//                    alignment: Alignment.center,),

                        Align(
                          child: RaisedButton(
                            hoverColor: Colors.red,
                            child: Text(
                              "+Add City",
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
                                  "City",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Text(
                                  "State/UT",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                flex: 2,
                              ),
                              Expanded(
                                child: Text(
                                  "Added Date",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                flex: 1,
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

                        (cityList.length > 0)
                            ? Container(
                                margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  separatorBuilder: (BuildContext context, int index) {
                                    return Padding(
                                      child: Divider(thickness: 1,),
                                      padding: EdgeInsets.only(top: 5, bottom: 5),
                                    );
                                  },
                                  itemCount: cityList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    City city=cityList[index];
                                    var date = new DateTime.fromMillisecondsSinceEpoch(city.createdDate );
                                    var format = DateFormat('dd-MMM-yyy hh:mm a');
                                    var createdDate=format.format(date);
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${city.city}",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "${city.state}",
                                            style: TextStyle(),
                                          ),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "$createdDate",
                                            style: TextStyle(),
                                          ),
                                          flex: 1,
                                        ),
                                        Expanded(
                                          child: InkWellMouseRegion(
                                            child: Icon(Icons.delete,color: Colors.red,),
                                            onTap: (){
                                              showDeleteCityDialog(context,city);
                                            },
                                          ),
                                          flex: 1,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              )
                            : Expanded(
                                child: Center(
                                  child: Text("No Data Found"),
                                ),
                              )
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
                            "Add City",
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
                      controller: this._cityController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "City",
                        prefixIcon: Icon(Icons.location_on),
                        errorText: _cityErrorTV,
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
                      controller: this._stateController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "State/UT",
                        prefixIcon: Icon(Icons.location_on),
                        errorText: _stateErrorTV,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                  ),
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
                        addCity(_cityController.text, _stateController.text);
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

  void addCity(String city, String state) {
    if (city.isEmpty) {
      _cityErrorTV = "Please Enter City Name";
      showAlertDialog(context);
    } else if (state.isEmpty) {
      _stateErrorTV = "Please Enter State or Union Territory Name";
      showAlertDialog(context);
    } else {
      _cityBloc.add(AddCityEvent(city: city,state: state));
    }
  }

  void init() {}

  showDeleteCityDialog(BuildContext contxt, City city) {
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
                            "Delete city?",
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
                    child: Text("Are you sure you want to delete ${city.city} ?"),
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
}
