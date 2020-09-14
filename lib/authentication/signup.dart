import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pratilipi_reading_app/stories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String inputMessage = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _trySubmit(BuildContext context) async {
    // function to store the value of the message and its size to firebase
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text, password: password1Controller.text);
      final FirebaseUser user = await auth.currentUser();
      final uid = user.uid;
      print(uid);
      await Firestore.instance.collection("users").document(uid).setData({
        // sets data in firebase under the collection name = "messages" and generates a document id based on time
        "email": emailController.text,
        "password": password1Controller.text,
        "user_id": uid,
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Stories()),
      );

      emailController.clear();
      password1Controller.clear();
      password2Controller.clear();
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
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: deviceHeight * .25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'BLOG',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'CREATE NEW ACCOUNT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 16.0, bottom: 8, left: 32, right: 32),
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.white,
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
                            controller: password1Controller,
                            decoration: InputDecoration(
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.white,
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
                          child: TextFormField(
                            controller: password2Controller,
                            decoration: InputDecoration(
                              focusedBorder: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 2.0,
                                ),
                              ),
                              labelText: 'Confirm Password',
                              hintText: 'test@test',
                            ),
                            obscureText: true,
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              if (value != password1Controller.text) {
                                return 'Passwords do not match';
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
                                  side: BorderSide(color: Colors.white)),
                              color: Colors.white,
                              child: Text('SIGN UP',style: TextStyle(color: Colors.black,fontSize: 20),),
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
                      ],
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
                            side: BorderSide(color: Colors.white)),
                        color: Colors.white,
                          child: Text('LOGIN',style: TextStyle(color: Colors.black,fontSize: 20),),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
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
      ),
    );
  }
}
