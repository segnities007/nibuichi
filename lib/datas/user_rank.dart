import 'package:firebase_auth/firebase_auth.dart';

class UserRank{
  UserRank({
  required this.highScore,
    name
  }):uid = FirebaseAuth.instance.currentUser!.uid,
    name = FirebaseAuth.instance.currentUser!.displayName;

  final String uid;
  String? name;
  int highScore = 0;

  @override
  String toString(){
    return "$uid, $name, $highScore";
  }

  UserRank.fromJson(Map<String, dynamic> json)
    : uid = json["uid"],
      name = json["name"],
      highScore = json["score"];

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "score": highScore,
  };
}
