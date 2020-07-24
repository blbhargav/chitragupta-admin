import 'package:chitragupta/app/Team/team_bloc.dart';
import 'package:chitragupta/extension/hover_extensions.dart';
import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/extension/util.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/models/Member.dart';
import 'package:chitragupta/models/customer.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TeamListPage extends StatefulWidget {
  final Repository repository;
  TeamListPage(this.repository);

  @override
  _TeamListPageState createState() => _TeamListPageState();
}

class _TeamListPageState extends State<TeamListPage> {
  bool _loading = false;
  TeamBloc _bloc;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();

  String _nameErrorTV = "", _emailErrorTV = "",_mobileErrorTV = "",_addressErrorTV = "",_commonError = "";

  List<City> cityList = new List();
  List<String> cityNames = new List();
  String selectedCity="Select City";
  String selectedRole="Select User Type";

  List<Member> teamList = new List();
  var title="Add Member";
  var editCustomerID="";
  @override
  void initState() {
    _bloc=TeamBloc(repository: widget.repository);
    _bloc.add(FetchTeamMembersEvent());
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
        child: BlocListener<TeamBloc, TeamState>(
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
              }else if(state is LoadTeamMembersState){
                teamList=state.teamList;
                print("BLB team ${teamList.length}");
              }else if(state is AddingSuccessState){
                _bloc.add(FetchTeamMembersEvent());
              }else if(state is AddingFailedState){

              }else if(state is EmailAlreadyInUseState){
                _emailErrorTV="Email already in use.";
                showAlertDialog(context,null);
              }
            },
            child: BlocBuilder<TeamBloc, TeamState>(
                cubit: _bloc,
                builder: (BuildContext context, TeamState state) {
                  if (state is CustomersInitial)
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  return ProgressHUD(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
//                  Align(child: Text("Indents",style: TextStyle(color: Colors.lightBlue[900],fontSize: 25,fontWeight: FontWeight.w700),),
//                    alignment: Alignment.center,),

                        Align(
                          child: RaisedButton(
                            hoverColor: Colors.red,
                            child: Text(
                              "+Add Member",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            onPressed: () {
                              title="Add Member";
                              resetForm();
                              showAlertDialog(context,null);
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
                                  "Member",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                flex: 2,
                              ),
                              Padding(padding: EdgeInsets.all(5),),
                              Expanded(
                                child: Text(
                                  "Mobile",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                flex: 1,
                              ),
                              Padding(padding: EdgeInsets.all(5),),
                              Expanded(
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                flex: 1,
                              ),
                              Padding(padding: EdgeInsets.all(5),),
                              Expanded(
                                child: Text(
                                  "Address",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                flex: 2,
                              ),
                              Padding(padding: EdgeInsets.all(5),),
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

                        (teamList.length>0)?Container(
                          margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                          child: ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (BuildContext context, int index) {
                              return Padding(
                                child: Divider(thickness: 1,),
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                              );
                            },
                            itemCount: teamList.length,
                            itemBuilder: (BuildContext context, int index) {
                              Member member=teamList[index];
                              var date = new DateTime.fromMillisecondsSinceEpoch(member.createdDate );
                              var format = DateFormat('dd-MMM-yyy hh:mm a');
                              var createdDate=format.format(date);
                              return InkWellMouseRegion(
                                child: Container(
                                  padding: EdgeInsets.only(top: 10,bottom: 10,left: 5,right: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${member.name}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                        flex: 2,
                                      ),
                                      Padding(padding: EdgeInsets.all(5),),
                                      Expanded(
                                        child: Text(
                                          "${member.mobile}",
                                          style: TextStyle(
                                              color: Colors.black,fontSize: 18),
                                        ),
                                        flex: 1,
                                      ),
                                      Padding(padding: EdgeInsets.all(5),),
                                      Expanded(
                                        child: Text(
                                          "${member.email}",
                                          style: TextStyle(
                                              color: Colors.black,fontSize: 18
                                          ),
                                        ),
                                        flex: 1,
                                      ),
                                      Padding(padding: EdgeInsets.all(5),),
                                      Expanded(
                                        child: Text(
                                          "${member.address} - ${member.city}, ${member.state}",
                                          style: TextStyle(
                                              color: Colors.black,fontSize: 18),
                                        ),
                                        flex: 2,
                                      ),
                                      Padding(padding: EdgeInsets.all(5),),
                                      Expanded(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWellMouseRegion(
                                              child: Icon(Icons.edit,color: Colors.black,),
                                              onTap: (){
                                                showAlertDialog(context,member);
                                                editCustomerID=member.uid;
                                              },
                                            ),
                                            Padding(padding: EdgeInsets.all(10),),
                                            InkWellMouseRegion(
                                              child: Icon(Icons.delete,color: Colors.red,),
                                              onTap: (){
                                                showDeleteCustomerDialog(context,member);
                                              },
                                            )
                                          ],
                                        ),
                                        flex: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: (){

                                },
                              );
                            },
                          ),
                        ):Expanded(
                            child: Center(child: Text("No Data Found"),),
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
  showAlertDialog(BuildContext contxt,Member member) {
    if(member!=null){
      _nameController.text=member.name;
      _emailController.text=member.email;
      _mobileController.text=member.mobile;
      _addressController.text=member.address;
      selectedCity=member.city;
      title="Edit Member";
      member=null;
    }
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
                            "$title",
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
                    child: HandCursor(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(color: Colors.pinkAccent,height: 1,width: double.maxFinite,),
                        items: <String>["Admin","Employee"].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        hint: selectedRole=="Select User Type"?Text("$selectedRole"):Text("$selectedRole",style: TextStyle(color: Colors.black),),
                        onChanged: (_val) {
                          selectedRole=_val;
                          Navigator.pop(contxt);
                          showAlertDialog(contxt,null);
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
                          showAlertDialog(contxt,null);
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
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      minLines: 1,
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
                        addMember();
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

  void addMember() {
    var error="Please enter this field";
    _nameErrorTV = ""; _emailErrorTV = "";_mobileErrorTV = "";_addressErrorTV = "";_commonError = "";
    if(_nameController.text.isEmpty){
      _nameErrorTV=error;
      showAlertDialog(context,null);
      return;
    }

    if(_mobileController.text.isEmpty){
      _mobileErrorTV=error;
      showAlertDialog(context,null);
      return;
    }

    if(!Utils.isMobileValid(_mobileController.text)){
      _mobileErrorTV="Please enter valid mobile number";
      showAlertDialog(context,null);
      return;
    }

    if(_emailController.text.isEmpty){
      _emailErrorTV=error;
      showAlertDialog(context,null);
      return;
    }

    if(!Utils.isEmailValid(_emailController.text)){
      _emailErrorTV="Please enter valid email";
      showAlertDialog(context,null);
      return;
    }

    if(_addressController.text.isEmpty){
      _addressErrorTV=error;
      showAlertDialog(context,null);
      return;
    }

    if(selectedCity=="Select City"){
      _commonError="Please select city";
      showAlertDialog(context,null);
      return;
    }

    if(selectedRole=="Select User Type"){
      _commonError="Please select user type";
      showAlertDialog(context,null);
      return;
    }

    var index=cityNames.indexWhere((note) => note.startsWith(selectedCity));
    City city=cityList[index];
    if(title.contains("Edit")){
      _bloc.add(EditTeamMembersEvent(
          name: _nameController.text,
          mobile: _mobileController.text,
          email: _emailController.text,
          address: _addressController.text,
          city: city.city,
          state: city.state,
          cityID: city.cityID,
        userID: editCustomerID,

      ));
    }else
    _bloc.add(AddMemberEvent(
      name: _nameController.text,
      mobile: _mobileController.text,
      email: _emailController.text,
      address: _addressController.text,
      city: city.city,
      state: city.state,
      cityID: city.cityID,
        type: selectedRole
    ));
  }

  void resetForm(){
    _nameController.text="";
    _emailController.text="";
    _mobileController.text="";
    _addressController.text="";
    selectedCity="Select City";
  }

  showDeleteCustomerDialog(BuildContext contxt, Member member) {
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
                            "Delete Member?",
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
                    child: Text("Are you sure you want to delete ${member.name} ?"),
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