import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pratilipi_reading_app/authentication/signup.dart';

import '../stories.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _trySubmit(BuildContext context) async {
    // function to store the value of the message and its size to firebase

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Stories()),
      );
      emailController.clear();
      passwordController.clear();
    } catch (e) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: new Text('Error: ${e.toString()}'),
        ),
      );
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build method describes the part of the user interface represented by this widget.
    final deviceSize = MediaQuery.of(context).size; //Getting device size
    final deviceWidth =
        deviceSize.width; // Getting device width for reponsive width
    final deviceHeight =
        deviceSize.height; // Getting device height for responsive height
    print(deviceSize);
    print(deviceWidth);
    print(deviceHeight);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFC2C4C8),
      // Scaffold provides a framework to implement the basic material design layout of the application
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: deviceHeight * .20),
              child: Column(
                children: <Widget>[
                  Text(
                    'BLOG',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Card(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  color: Colors.black12,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 16.0, bottom: 8, left: 32, right: 32),
                              child: TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Color(0xFFC2C4C8),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelText: 'Email',
                                  hintText: 'test@test.com',
                                ),
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'email cannot be empty';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 8.0, bottom: 8, left: 32, right: 32),
                              child: TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  focusedBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Color(0xFFC2C4C8),
                                      width: 2.0,
                                    ),
                                  ),
                                  labelText: 'Password',
                                  hintText: 'test@test',
                                ),
                                autocorrect: false,
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 8.0, bottom: 8, left: 32, right: 32),
                              child: SizedBox(
                                width: deviceWidth,
                                height: 60,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      side: BorderSide(color: Colors.black)),
                                  color: Colors.black,
                                  child: Text('LOGIN',style: TextStyle(color: Colors.white,fontSize: 20),),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _trySubmit(context);
                                    }
                                    if (!_formKey.currentState.validate()) {
                                      return;
                                    }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only( top: 8.0, bottom: 32, left: 32, right: 32),
                              child: SizedBox(
                                width: deviceWidth,
                                height: 60,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28.0),
                                      side: BorderSide(color: Colors.black)),
                                  color: Colors.black,
                                  child: Text('SIGN UP',style: TextStyle(color: Colors.white,fontSize: 20),),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Signup()),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Text('Forgot Password?'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
