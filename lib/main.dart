import 'package:appchat/ListChat.dart';
import 'package:appchat/SharedPreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}
GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final MySharedPrefereces _mySharedPrefereces = MySharedPrefereces.Init();
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn  = GoogleSignIn();
  _googleSign()async{
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;
    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result =
      await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
      final List < DocumentSnapshot > documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance.collection('users').document(firebaseUser.uid).setData(
            { 'nickname': firebaseUser.displayName, 'photoUrl': firebaseUser.photoUrl, 'id': firebaseUser.uid });
      }
      print(firebaseUser.email);
       widget._mySharedPrefereces.setEmail(await firebaseUser.email);
       widget._mySharedPrefereces.setNameUser(await firebaseUser.displayName);
       widget._mySharedPrefereces.setPhotoUrl(await firebaseUser.photoUrl);
       widget._mySharedPrefereces.setUid(await firebaseUser.uid);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ListChat(firebaseUser: firebaseUser,)));
    }
    else{
      Fluttertoast.showToast(msg: "Here is null");
    }
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("cmno"),
            bottom: TabBar(
              isScrollable: true,
              tabs: <Widget>[
                Tab(child: Text("1"),icon: Icon(Icons.launch),),
                Tab(child: Text("2"),icon: Icon(Icons.print),),
                Tab(child: Text("google"),icon: Icon(Icons.http),),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              Center(child: RaisedButton(
                child: Text("LogOut"),
                onPressed: ()async{
                  await FirebaseAuth.instance.signOut();
                  await googleSignIn.disconnect();
                  await googleSignIn.signOut();
                },
              ),),
              Center(child: Text("View 2"),),
              Center(child: RaisedButton(
                child: Text("Google Login"),
                onPressed: (){
                  _googleSign();
                },
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
