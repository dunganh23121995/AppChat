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
import 'package:path/path.dart' as Path;
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
    PickedFile pickedFile;

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
                  if(pickedFile.path !=null)
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
    print(avatarImageFile.path);
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('${Path.basename(avatarImageFile.path)}');
    print(Path.basename(avatarImageFile.path));
    StorageUploadTask uploadTask = storageReference.putFile(avatarImageFile);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        photoUrl = fileURL;
        MySharedPrefereces.Init().setPhotoUrl(photoUrl);
      });
    });
  }

}