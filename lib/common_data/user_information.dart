import 'package:firebase_auth/firebase_auth.dart';

////////////////////////////////////////////////////////////////////////////////

class UserInformation{
  UserInformation({
    required this.highScore,
    this.name,
    uid,
    this.imagePath,
  }): uid = FirebaseAuth.instance.currentUser!.uid;

  final String uid;
  int highScore = 0;
  // String? name = FirebaseAuth.instance.currentUser!.displayName;
  String? name;
  String? imagePath;
  int coin = 0;

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
        uid       = json["uid"],
        coin      = json["coin"],
        imagePath = json["imagePath"];

  Map<String, dynamic> toJson() => {
    "score":      highScore,
    "name":       name,
    "uid":        uid,
    "coin":       coin,
    "imagePath":  imagePath,
  };
}

////////////////////////////////////////////////////////////////////////////////
