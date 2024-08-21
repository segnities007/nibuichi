import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/datas/user_rank.dart';
import 'package:nibuichi/providers/ranking_list_provider.dart';
import 'package:logger/logger.dart';

////////////////////////////////////////////////////////////////////////////////

class RankingUI extends ConsumerStatefulWidget {
  const RankingUI({super.key});

  @override
  StateRankingUI createState() => StateRankingUI();
}

////////////////////////////////////////////////////////////////////////////////

class StateRankingUI extends ConsumerState<RankingUI> {

  @override
  void initState(){
    super.initState();
    _loadRankings(ref:ref);
  }

  @override
  Widget build(context) {
    final rankings = ref.watch(rankingListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ranking"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for(final user in rankings)
            Text(user.toString())
        ],
      )
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

void _loadRankings({required WidgetRef ref})async{
  final FirebaseDatabase rtdb = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: "https://nibuichi-13ee2-default-rtdb.asia-southeast1.firebasedatabase.app/");
  try{
    final snapshot = await rtdb.ref("rankings/users")
        .orderByChild("score").limitToLast(100).get();
    if(snapshot.exists){
      // Logger().i("snapshot is existed");
      final users = snapshot.children;
      final List<UserRank> userList = [];
      for(final user in users){
        final userData = UserRank.fromJson(Map<String, dynamic>.from(user.value as Map));
        userList.add(userData);
        // Logger().i("userList is added");
      }
      ref.read(rankingListProvider.notifier).state = userList;
    }
  } catch (e){
    Logger().i(e);
    await rtdb.ref("rankings/users/${FirebaseAuth.instance.currentUser!.uid}")
        .set(UserRank(highScore: 0).toJson());
  }
}