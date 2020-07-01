import 'dart:io';

import 'package:appchat/SharedPreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
class ChangeInfor extends StatefulWidget{
  int idcurrent,idreender;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChangeInfor();
  }

}
class _ChangeInfor extends State<ChangeInfor>{
  String id,nickname,photoUrl;
  File avatarImageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInfor();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: FutureBuilder(
          future: MySharedPrefereces.Init().getPhotoUrl(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return InkWell(
                splashColor: Colors.transparent,
                splashFactory: InkRipple.splashFactory,
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: NetworkImage(snapshot.data),
                ),
                onTap: ()async{
                  await _getImagePicker();
                  if(avatarImageFile!=null)
                  uploadFile();
                },
              );
            }
            return Container();
          },
        ),
      )
    );
  }
  _getInfor()async{
    MySharedPrefereces pres = MySharedPrefereces.Init();
    id = await pres.getUid();
    nickname = await pres.getNameUser();
    photoUrl = await pres.getPhotoUrl();
  }
  _getImagePicker()async{
    var pickedFile;

    await showModalBottomSheet(
        context: context,
        builder: (context){
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft:const Radius.circular(15),topRight: const Radius.circular(15)),
          color: Theme.of(context).canvasColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              onTap: ()async{
                pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
                setState(() {
                  avatarImageFile = File(pickedFile.path);
                                     Navigator.pop(context);
                });
              },
              leading: Icon(Icons.camera),
              title: Text("Camera"),
            ),
            ListTile(
              onTap: ()async{
                pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
                setState(() {
                  avatarImageFile = File(pickedFile.path);
                  Navigator.pop(context);
                });
              },
              leading: Icon(Icons.filter),
              title: Text("File"),
            ),
          ],
        ),
      );
    });


  }
  Future uploadFile() async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    print(fileName);
    print(avatarImageFile);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance
              .collection('users')
              .document(id)
              .updateData({
            'nickname': nickname,
            'photoUrl': photoUrl
          }).then((data) async {
            await MySharedPrefereces.Init().setPhotoUrl(photoUrl);
            setState(() {
//              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
//              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        },
            onError: (err)
        {
          setState(() {
//            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image1');
        });
      } else {
        setState(() {
//          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image2 ${value.error}');
      }
    }, onError: (err) {
      setState(() {
//        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

}