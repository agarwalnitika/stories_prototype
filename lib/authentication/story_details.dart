import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StoryInfo extends StatefulWidget {
  final String story_id;
  StoryInfo(this.story_id);
  @override
  _StoryInfoState createState() => _StoryInfoState();
}

class _StoryInfoState extends State<StoryInfo> with WidgetsBindingObserver {
  final firestoreInstance = Firestore.instance;
  String title;
  String content;
  int readCount;
  int viewing;


  Future<void> story() async{
    await Firestore.instance.document('stories/${widget.story_id}').get().then((document) {
      setState(() {
        title = document["title"];
        content = document["content"];
      });
      print(title);
    });


  }
Future<void> current_viewer() async{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseUser user = await auth.currentUser();
  await Firestore.instance
      .collection("stories/${widget.story_id}/viewing")
      .document(user.uid)
      .setData({
      "user_id": user.uid,
  });
  await Firestore.instance
      .collection("stories/${widget.story_id}/readers")
      .document(user.uid)
      .setData({
    "user_id": user.uid,
  });

}

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state){
      case AppLifecycleState.resumed:

        print("app in resumed");
        current_viewer();
        break;
      case AppLifecycleState.inactive:
        delete_viewers();
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        delete_viewers();
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        delete_viewers();
        print("app in detached");
        break;
    }}

  Future<void> delete_viewers() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    await Firestore.instance.collection("stories/${widget.story_id}/viewing").document(user.uid).delete();

  }



  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
   current_viewer();
   story();


  }
  Stream<DocumentSnapshot> provideDocumentFieldStream() {
    return Firestore.instance
        .collection('stories')
        .document(widget.story_id)
        .snapshots();

  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size; //Getting device size
    final deviceWidth = deviceSize.width; // Getting device width for reponsive width
    final deviceHeight =
        deviceSize.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed:() {
        //  delete_viewers();
        //  countDocuments();
          Navigator.of(context).pop();
        },),
        centerTitle: true,
        title:   Text((title ?? ' ').toUpperCase(),style: TextStyle(color: Colors.white),),
      ),
      body:ListView(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(

              stream: Firestore.instance.collection('stories').document(widget.story_id).collection('readers').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData){

                  //  add_reader(snapshot.data.documents.length);
                  return Container(child: ListTile(leading: Icon(Icons.chrome_reader_mode) ,title: Text('${snapshot.data.documents.length}')),);}
                else{
                  return Container();
                }
              }
          ),
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('stories').document(widget.story_id).collection('viewing').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData){
                  return Container(child:ListTile(leading: Icon(Icons.remove_red_eye) ,title: Text('${snapshot.data.documents.length}')),);}
                else{
                  return Container();
                }
              }
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(content ?? " ",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 20),),
          ),


        ],
      ),
    );
  }
}
