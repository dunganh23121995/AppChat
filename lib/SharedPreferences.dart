import 'package:shared_preferences/shared_preferences.dart';

class MySharedPrefereces {
   SharedPreferences _sharedPreferences;
   static MySharedPrefereces _mySharedPrefereces;
MySharedPrefereces.Init();
  factory MySharedPrefereces(){
    if(_mySharedPrefereces==null){
      MySharedPrefereces.Init();
    }
    return _mySharedPrefereces;
  }
  Future<SharedPreferences> get sharedPreferences async{
    if(_sharedPreferences==null){
      _sharedPreferences = await SharedPreferences.getInstance();
    }
    return _sharedPreferences;
  }

   Future<bool> setNameUser(String nameUser)async{
    SharedPreferences _sharedPreferences =await sharedPreferences;
    return await _sharedPreferences.setString("nameUser", nameUser);
  }
  Future<String> getNameUser() async{
    SharedPreferences _sharedPreferences =await sharedPreferences;
    return await _sharedPreferences.getString("nameUser");
  }
   Future<bool> setEmail(String email)async{
     SharedPreferences _sharedPreferences =await sharedPreferences;
     return await _sharedPreferences.setString("email", email);
   }
   Future<String> getEmail() async{
     SharedPreferences _sharedPreferences =await sharedPreferences;
     return await _sharedPreferences.getString("email");
   }
   Future<bool> setUid(String uid)async{
     SharedPreferences _sharedPreferences =await sharedPreferences;
     return await _sharedPreferences.setString("uid", uid);
   }
   Future<String> getUid() async{
     SharedPreferences _sharedPreferences =await sharedPreferences;
     return await _sharedPreferences.getString("uid");
   }
   Future<bool> setPhotoUrl(String photoUrl)async{
     SharedPreferences _sharedPreferences =await sharedPreferences;
     return await _sharedPreferences.setString("photoUrl", photoUrl);
   }
   Future<String> getPhotoUrl() async{
     SharedPreferences _sharedPreferences =await sharedPreferences;
     return await _sharedPreferences.getString("photoUrl");
   }

}