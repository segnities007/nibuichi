

import 'package:firebase_auth/firebase_auth.dart';

class UserScore{
  UserScore({
    required this.highScore,
}): uid = FirebaseAuth.instance.currentUser!.uid;

  final String uid;
  int highScore = 0;

  bool setScore(int score){
    if(highScore < score){
      highScore = score;
      return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "score": highScore
  };
}