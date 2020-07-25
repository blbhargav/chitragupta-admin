import 'package:chitragupta/app/dashboard.dart';
import 'package:chitragupta/app/Home/home.dart';
import 'package:chitragupta/background.dart';
import 'package:chitragupta/extension/hover_extensions.dart';
import 'package:chitragupta/inputWidget.dart';
import 'package:chitragupta/models/Member.dart';
import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class loginRoot extends StatefulWidget {
  final Repository repository;
  loginRoot({this.repository});
  @override
  _loginRootState createState() => _loginRootState();
}

class _loginRootState extends State<loginRoot> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      //resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[Background(), Login(repository: widget.repository,)],
      ),
    );
  }
}

class Login extends StatefulWidget {
  final Repository repository;
  Login({this.repository});
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  _Login createState() => _Login(_userIdController, _passwordController);
}

class _Login extends State<Login> {
  TextEditingController _userIdController, _passwordController;
  String error;
  bool _loading = false;
  _Login(this._userIdController, this._passwordController);
  @override
  void initState() {
    super.initState();

    _userIdController.text='bhargavbl224@gmail.com';
    _passwordController.text='Blb@9618794545';
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: ListView(
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
          ),
          Align(
            child: Container(
              width: 600,
              child: Column(
                children: <Widget>[
                  ///holds email header and inputField
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 40, bottom: 10),
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          InputWidget(30.0, 0.0, "Email", _userIdController),
                        ],
                      ),
                    ],
                  ),
                  error != null
                      ? Padding(
                    child: Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                    padding: EdgeInsets.only(bottom: 5),
                  )
                      : Container(),
                  InputWidgetPassword(30.0, 0.0, "Password", _passwordController),
                  GestureDetector(
                    child: HandCursor(
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                            color: Colors.lightBlueAccent,
                            fontStyle: FontStyle.italic,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue),
                      ),
                    ),
                    onTap: () {
                      showForgotAlert(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  ),

                  //roundedRectButton("Let's get Started", signInGradients, false),
                  Container(
                    child: HandCursor(child: GestureDetector(
                      child: roundedRectButton(
                        "Login",
                        signUpGradients,
                        false,
                      ),
                      onTap: () {
                        loginFunction();
                      },
                    ),),
                    margin: EdgeInsets.only(right: 40),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom)),
                ],
              ),
            ),
            alignment: Alignment.center,
          )
        ],
      ),
      opacity: 0.5,
      inAsyncCall: _loading,
    );
  }

  void loginFunction() {
    setState(() {
      error = null;
    });
    if (_userIdController.text.isEmpty) {
      setState(() {
        error = "Please enter email Id";
      });
    } else if (_passwordController.text.isEmpty) {
      setState(() {
        error = "Please enter password";
      });
    } else if (_passwordController.text.length < 6) {
      setState(() {
        error = "Password must be at least 6 characters";
      });
    } else {
      setState(() {
        _loading = true;
      });
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      widget.repository
          .signInWithCredentials(
              _userIdController.text, _passwordController.text)
          .then((res) async {
        setState(() {
          _loading = false;
        });
        await widget.repository.updateUserSignedLocally(true, res.user.uid);
        Repository.uid=res.user.uid;
        Member user;
        widget.repository.getProfile().then((value) {
          user = new Member.fromSnapshot(snapshot: value);
        }).whenComplete(() {
          Repository.user = user;
          navigateToHome();
        });
        setState(() {
          _loading = false;
        });
      }).catchError((e) {
        setState(() {
          _loading = false;
        });
        if (e.toString().toLowerCase().contains("user_not_found")) {
          setState(() {
            error = "Email Id not registerted";
          });
        } else if (e.toString().toLowerCase().contains("invalid_email")) {
          setState(() {
            error = "Invalid email Id";
          });
        } else if (e.toString().toLowerCase().contains("wrong_password")) {
          setState(() {
            error = "Wrong password";
          });
        } else {
          setState(() {
            error = "Something went wrong. Please try again later.";
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void navigateToHome() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => homeScreen(widget.repository)),
        ModalRoute.withName("/Home"));
  }

  void showForgotAlert(BuildContext context) {
    TextEditingController controller = TextEditingController();
    String forgotError;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: new Text("Forgot Password?"),
              content: Container(
                height: 150,
                child: Column(
                  children: <Widget>[
                    new Text(
                        "No worries! Reset your password to access the app."),
                    TextField(
                      decoration: InputDecoration(
                          //border: InputBorder.none,
                          hintText: "",
                          hintStyle:
                              TextStyle(color: Color(0xFFE1E1E1), fontSize: 14),
                          alignLabelWithHint: true,
                          labelText: "Email",
                          errorText: forgotError),
                      controller: controller,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                    ),
                    Text(
                      "We will send reset link to this email",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Send Link"),
                  onPressed: () {
                    if (controller.text.isEmpty) {
                      setState(() {
                        forgotError = "Please enter email id";
                      });
                    } else {
                      bool emailValid =
                          RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(controller.text);
                      if (emailValid) {
                        Navigator.of(context).pop();
                        sendResetLink(controller.text);
                      } else {
                        setState(() {
                          forgotError = "Please enter valid email id";
                        });
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showDialogFunction(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void sendResetLink(String email) {
    setState(() {
      _loading = true;
    });
    widget.repository.sendResetLink(email).then((res) {
      setState(() {
        _loading = false;
      });
      showDialogFunction(context, "Reset email sent",
          "Password reset email sent to $email. Please check your inbox and reset.\nIncase if you don't find email check your spam box too.");
    }).catchError((e) {
      setState(() {
        _loading = false;
      });
      print("BLB $e");
      if (e.toString().toLowerCase().contains("user_not_found")) {
        showDialogFunction(
            context, "Error", "User not found for this email id: $email");
      } else {
        showDialogFunction(
            context, "Error", "Something went wrong. Please try again later.");
      }
    });
  }
}

Widget roundedRectButton(
    String title, List<Color> gradient, bool isEndIconVisible) {
  return Builder(builder: (BuildContext mContext) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: Alignment(1.0, 0.0),
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(mContext).size.width / 1.7,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    decoration: TextDecoration.none,
                    fontWeight: FontWeight.w700)),
            padding: EdgeInsets.only(top: 16, bottom: 16),
          ),
          Visibility(
            visible: isEndIconVisible,
            child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: ImageIcon(
                  AssetImage("assets/ic_forward.png"),
                  size: 30,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  });
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  Color(0xFFFF9945),
  Color(0xFFFc6076),
];
