import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:nibuichi/datas/databaseURL.dart';
import 'package:nibuichi/datas/user_information.dart';
import 'package:nibuichi/datas/user_rank.dart';
import '../../../providers/game_provider.dart';
import '../../commons/commons.dart';

////////////////////////////////////////////////////////////////////////////////

class FailUI extends ConsumerWidget{
  const FailUI({super.key});

  @override
  Widget build(context, ref){
    final score = ref.watch(scoreProvider);

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Column(
              children: [
                const Text("fail"),
                Text("your score is $score")
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: ElevatedButton(
              style: buttonStyle(n: n),
              onPressed: ()async{
                final a = await goNextScreen(score: score, context: context);
                a();
              },
              child: const Text("back to home"),
            ),
          ),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<Function()> goNextScreen({
  required int score,
  required BuildContext context
})async{
  return ()async{
    final DataSnapshot snapshot = await FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: databaseURL)
        .ref("users/${FirebaseAuth.instance.currentUser!.uid}").get();
    try{
      final judge = await isHighScore(score: score, context: context, snapshot: snapshot);
      await isAddedRanking(judge: judge, snapshot: snapshot, score: score);
    }catch(e){
      Logger().i(e);
    }
    context.go("/hub");
  };
}

////////////////////////////////////////////////////////////////////////////////

Future<void> isAddedRanking({
  required bool judge,
  required DataSnapshot snapshot,
  required int score,
})async{
  try{
    if(judge){
      final rtdb = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: databaseURL);
      final rankingSnapshot = await rtdb.ref("rankings/users").child("").orderByChild("score").limitToLast(100).get();
      if(rankingSnapshot.exists){
        final users = rankingSnapshot.children;
        final List<UserRank> userList = [];
        for(final user in users){
          final value = Map<String, dynamic>.from(user.value as Map<Object?, Object?>);
            userList.add(UserRank.fromJson(value));
        }
        final lowerUser = userList[userList.length-1];
        bool isAddJudge = false;
        if(lowerUser.highScore < score){
          for(final user in userList){
            if(FirebaseAuth.instance.currentUser!.uid == user.uid){
              if(user.highScore < score){
                isAddJudge = true;
              }
            }
          }
          if(isAddJudge){
            rtdb.ref("rankings/users/${lowerUser.uid}").remove();
            final user =  UserRank(highScore: score).toJson();
            rtdb.ref("rankings/users/${FirebaseAuth.instance.currentUser!.uid}").set(user);
          }else{
            final user =  UserRank(highScore: score).toJson();
            rtdb.ref("rankings/users/${FirebaseAuth.instance.currentUser!.uid}").set(user);
          }
        }
      }
    }
  }catch (e){
    Logger().i(e);
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<bool> isHighScore({
  required int score,
  required BuildContext context,
  required DataSnapshot snapshot
})async{
  try{
    if (snapshot.exists && snapshot.value != null) {
      final Object? rawData = snapshot.value;
      if (rawData is Map<Object?, Object?>) {
        final data = rawData.map(
              (key, value) => MapEntry(key.toString(), value),
        );
        final user = UserInformation.fromJson(data);
        if (user.highScore < score) {
          debugPrint("Updating score...");
          user.setScore(score);
          await FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: databaseURL)
              .ref("users/${FirebaseAuth.instance.currentUser!.uid}").update(user.toJson());
          // Logger().i("get highScore");
          return true;
        }
      } else {
        Logger().i("Data format is not as expected.");
      }
    } else {
      Logger().i("No data found or data is null.");
    }
  }catch(e){
    Logger().i(e);
  }
  return false;
}
