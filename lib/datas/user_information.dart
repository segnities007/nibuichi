import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
////////////////////////////////////////////////////////////////////////////////

class UserInformation{
  UserInformation({
    required this.highScore,
    name,
  });

  int highScore = 0;
  String? name = FirebaseAuth.instance.currentUser!.displayName;

  bool setScore(int score){
    if(highScore < score){
      highScore = score;
      return true;
    }
    return false;
  }

  @override
  String toString(){
    return "$highScore $name";
  }

  UserInformation.fromJson(Map<String, dynamic> json)
      : highScore = json["score"],
        name      = json["name"];

  Map<String, dynamic> toJson() => {
    "score":  highScore,
    "name":   name,
  };

  Future<void> saveToDatabase()async{
    final ref = _getRef();
    await ref.set(toJson());
  }

}

////////////////////////////////////////////////////////////////////////////////

Future<UserInformation?> getFromDatabase() async{
  final ref = _getRef();
  final snapShot = await ref.child("users/${FirebaseAuth.instance.currentUser!.uid}").get();
  if(snapShot.exists){
    final snapShotValue = snapShot.value;
    if(snapShotValue is Map){
      final Map<String, dynamic> jsonMap = snapShotValue.map(
            (key, value) => MapEntry(key.toString(), value),
      );
      return UserInformation.fromJson(jsonMap);
    }
  }
  return null;
}

DatabaseReference _getRef(){
  return FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: "https://nibuichi-13ee2-default-rtdb.asia-southeast1.firebasedatabase.app/"
  ).ref();
}