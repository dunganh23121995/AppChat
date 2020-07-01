import 'package:appchat/SharedPreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBox extends StatefulWidget{
  int idcurrent,idreender;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChatBox();
  }

}
class _ChatBox extends State<ChatBox>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[

              ],
            ),
          ],
        ),
      ),
      onWillPop: (){
        print("Deo cho thoat");
        Navigator.pop(context);
      },
    );
  }

}