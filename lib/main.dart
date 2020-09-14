import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pratilipi_reading_app/authentication/login.dart';
import 'package:pratilipi_reading_app/stories.dart';
import 'authentication/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      theme: ThemeData(
        cursorColor: Colors.black,
        primaryColor: Colors.black,

      ),
      debugShowCheckedModeBanner: false,
      home:   StreamBuilder(
              stream: _auth.onAuthStateChanged,
              builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData)
                    return Stories();
                  else
                    return Login();
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );

    }
    ));
  }
}

