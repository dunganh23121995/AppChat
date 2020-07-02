import 'package:appchat/SharedPreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChatBox extends StatefulWidget{
  String currentId,peerId;
  ChatBox({@required this.currentId,@required this.peerId});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChatBox();
  }

}
class _ChatBox extends State<ChatBox>{
  String groupChatId,content ;
  var listMessage;
  TextEditingController textEditingController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.currentId.hashCode <= widget.peerId.hashCode) {
      groupChatId = '${widget.currentId}-${widget.peerId}';
    } else {
      groupChatId = '${widget.peerId}-${widget.currentId}';
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('messages')
              .document(groupChatId)
              .collection(groupChatId)
              .orderBy('timestamp', descending: true)
              .limit(20)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).canvasColor)));
            } else {
              listMessage = snapshot.data.documents;
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index){
                  print(snapshot.data.documents[index]);
                  return Container();
                  return Text(snapshot.data.documents[index]);
                },
                itemCount: snapshot.data.documents.length,
                reverse: true,
//                controller: listScrollController,
              );
            }
          },
        ),
        bottomNavigationBar: TextField(
          onChanged: (value){
            content=value;
          },
          controller: textEditingController,
          decoration:  InputDecoration(
            labelText: 'fdsa',
            contentPadding: EdgeInsets.all(20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: (){
                onSendMessage(content.trim(), 1);
              },
            ),
          ),
        )
      ),
      onWillPop: (){
        print("Deo cho thoat");
        Navigator.pop(context);
      },
    );
  }


  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
//      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'idFrom': widget.currentId,
            'idTo': widget.peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
//      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }


}