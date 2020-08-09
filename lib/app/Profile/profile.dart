import 'package:chitragupta/app/Profile/profile_bloc.dart';
import 'package:chitragupta/models/Member.dart';
import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:chitragupta/extension/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatefulWidget {
  Profile(Repository repository) : repository = repository ?? Repository();
  final Repository repository;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var userName = "Name";
  var email = "Email";
  bool _loading = false;
  Member user;
  ProfileBloc _bloc;
  @override
  void initState() {
    _bloc=ProfileBloc(widget.repository);
    _bloc.add(ProfileInitialEvent());
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return BlocProvider(
        create: (_) => _bloc,
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if(state is ShowProgressState){
              _loading=true;
            }else if(state is HideProgressState){
              _loading=false;
            }else if(state is DisplayProfileState){
              user=state.member;
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            cubit: _bloc,
            builder: (BuildContext context, ProfileState state) {
              if(state is ProfileInitial)
                return Center(child: CircularProgressIndicator(),);
              if(state is NetworkErrorState)
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text("Error Fetching data"),
                      ),
                      RaisedButton(
                        child: Text("Retry"),
                        onPressed: (){
                          _bloc.add(ProfileInitialEvent());
                        },
                      ),
                    ],
                  ),
                );
              return ProgressHUD(
                opacity: 0.3,
                inAsyncCall: _loading,
                child: Container(
                  child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView(
                        padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          Stack(
                            children: <Widget>[
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/profile.png'),
                                      fit: BoxFit.fitHeight),
                                ),
                              ),
                              Container(
                                height: 200,
                                color: Color.fromRGBO(255, 255, 255, 0.5),
                              ),
                              Container(
                                height: 200,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(bottom: 25, left: 20),
                                child: Center(
                                  child: CircleAvatar(
                                    child: Image.asset('assets/user_avatar.png'),
                                    maxRadius: 75,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                            child: Center(
                              child: Container(
                                width: 500,
                                color: Colors.white,
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text("Name", style: TextStyle(fontSize: 16,color: Colors.black54),),
                                          flex: 1,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10,right: 20),
                                          child: Text(":"),
                                        ),
                                        Expanded(
                                          child: Text("${user.name}" , style: TextStyle(fontSize: 18),),
                                          flex: 3,
                                        )
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.all(10),),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text("Mobile", style: TextStyle(fontSize: 16,color: Colors.black54),),
                                          flex: 1,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10,right: 20),
                                          child: Text(":"),
                                        ),
                                        Expanded(
                                          child: Text("${user.mobile}" , style: TextStyle(fontSize: 18),),
                                          flex: 3,
                                        )
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.all(10),),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text("Email", style: TextStyle(fontSize: 16,color: Colors.black54),),
                                          flex: 1,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10,right: 20),
                                          child: Text(":"),
                                        ),
                                        Expanded(
                                          child: Text("${user.email}" , style: TextStyle(fontSize: 18),),
                                          flex: 3,
                                        )
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.all(10),),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text("Address", style: TextStyle(fontSize: 16,color: Colors.black54),),
                                          flex: 1,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10,right: 20),
                                          child: Text(":"),
                                        ),
                                        Expanded(
                                          child: Text("${user.address}" , style: TextStyle(fontSize: 18),),
                                          flex: 3,
                                        )
                                      ],
                                    ),
                                    Padding(padding: EdgeInsets.all(10),),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text("City", style: TextStyle(fontSize: 16,color: Colors.black54),),
                                          flex: 1,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10,right: 20),
                                          child: Text(":"),
                                        ),
                                        Expanded(
                                          child: Text("${user.city} - ${user.state}" , style: TextStyle(fontSize: 18),),
                                          flex: 3,
                                        )
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ),


                        ],
                      )
                  ),
                ),
              );
            }
          ),
        )
      );

  }

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var mobileController = TextEditingController();
  String nameErrorTV, emailErrorTV, mobileErrorTv;
  showAddMemberAlertDialog(BuildContext contxt) {
    return showDialog(
        context: contxt,
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
                  Text(
                    "Add Team Member",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this.nameController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.calendar_today),
                        errorText: nameErrorTV,
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
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: new TextField(
                      controller: this.emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                        errorText: emailErrorTV,
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
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: new TextField(
                      controller: this.mobileController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      decoration: InputDecoration(
                        labelText: "Mobile",
                        prefixIcon: Icon(Icons.phone_android),
                        errorText: mobileErrorTv,
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
                    padding: EdgeInsets.all(20),
                  ),
                  SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: RaisedButton(
                      child: Text(
                        "Add",
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
                        nameErrorTV = null;
                        if (nameController.text.trim().length == 0) {
                          nameErrorTV = "Please enter Name";
                          return;
                        }
                        if (emailController.text.trim().length == 0) {
                          emailErrorTV = "Please enter Email";
                          return;
                        }
                        if (mobileController.text.trim().length == 0) {
                          mobileErrorTv = "Please enter Mobile";
                          return;
                        }

                        setState(() {
                          _loading = true;
                        });
                        widget.repository
                            .signUp(emailController.text.trim(), "12345678")
                            .then((value) {
                          var name = nameController.text.trim();
                          var email = emailController.text.trim();
                          var mobile = mobileController.text.trim();
                          widget.repository
                              .addTeamMember(
                                  value.user.uid, name, email, mobile)
                              .then((value) {
                            setState(() {
                              _loading = false;
                            });
                          }).whenComplete(() {
                            setState(() {
                              _loading = false;
                            });
                          });
                        }).catchError((onError) {
                          setState(() {
                            _loading = false;
                          });
                        });
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
