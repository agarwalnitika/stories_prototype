import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pratilipi_reading_app/authentication/signup.dart';

import 'authentication/login.dart';
import 'authentication/story_details.dart';

class Stories extends StatefulWidget {
  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    print(uid);
    // here you write the codes to input the data into firestore
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inputData();
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.menu,
          color: Colors.grey,
        ),
        title: Text(
          "STORIES",
          style: TextStyle(color: Colors.grey),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.grey,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
          )
        ],
      ),
      drawer: Drawer(),
      body: Container(
        color: Colors.white30,
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('stories')
              .snapshots(), //getting data from cloud firestore
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return new Text('Loading...');
            return new ListView(
              //ListView - scrollable column
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                //retrieving document

                return SingleChildScrollView(
                    child: Container(

                  child: Padding(
                    padding: const EdgeInsets.only(top:30.0),
                    child: ListTile(
                      isThreeLine: true,
                      leading: SizedBox(
                        width: 50,
                        child: OutlineButton(
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StoryInfo(document['id'])),
                        );
                      },
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          document['title'].toUpperCase() ?? ' ',
                          style:
                              TextStyle(fontSize: 25.0), //Display the message
                        ),
                      ),
                      subtitle: Text(
                        document['content'] ?? ' ',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ));
              }).toList(), //Display the list of all messages entered by user
            );
          },
        ),
      ),
    );
  }
}
