import 'package:appchat/ChangeInfor.dart';
import 'package:appchat/Chat.dart';
import 'package:appchat/SharedPreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ListChat extends StatefulWidget {
  FirebaseUser firebaseUser;
  final MySharedPrefereces _mySharedPrefereces = MySharedPrefereces.Init();

  ListChat({this.firebaseUser});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListChat();
  }
}

class _ListChat extends State<ListChat> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FutureBuilder(
            future: widget._mySharedPrefereces.getPhotoUrl(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return InkWell(
                  splashColor: Colors.transparent,
                  splashFactory: InkRipple.splashFactory,
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(snapshot.data),
                  ),
                  onTap: (){
                    Fluttertoast.showToast(msg: "Click");
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangeInfor()));

                  },
                );
              }
              return Container();
            },
          ),
        ],
      ),
      body: Container(
        child:StreamBuilder(
          stream: Firestore.instance.collection('users').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasData)
            return ListView(
              children: snapshot.data.documents.map((DocumentSnapshot documentSnapshot){
                return Card(
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatBox()));

                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(documentSnapshot['photoUrl']),
                    ),
                    title: Text(documentSnapshot['nickname']),
                    subtitle: Text('Hashcode is: ${documentSnapshot['id']}'),
                  ),
                );
              }).toList(),
            );
            else return Container();
          },
        ),
      ),
    );
  }
}
