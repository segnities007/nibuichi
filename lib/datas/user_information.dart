import 'package:firebase_auth/firebase_auth.dart';

////////////////////////////////////////////////////////////////////////////////

class UserInformation{
  UserInformation({
    required this.highScore,
    name,
    uid
  }): uid = FirebaseAuth.instance.currentUser!.uid;

  final String uid;
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
        name      = json["name"],
        uid       = json["uid"];

  Map<String, dynamic> toJson() => {
    "score":  highScore,
    "name":   name,
    "uid":  uid
  };
}

////////////////////////////////////////////////////////////////////////////////
