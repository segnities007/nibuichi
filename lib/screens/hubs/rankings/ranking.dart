import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/providers/ranking_list_provider.dart';
import 'package:logger/logger.dart';

import '../../../common_data/databaseURL.dart';
import '../../../common_data/user_information.dart';

////////////////////////////////////////////////////////////////////////////////

const double padding = 10;

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
    return Column(
      children: [
        ListUI(rankings: rankings)
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class ListUI extends StatelessWidget{
  const ListUI({super.key, required this.rankings});

  final List<UserInformation> rankings;

  @override
  Widget build(context){
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(padding),
          child: Column(
            children: [
              for(int i= rankings.length-1; i>=0; i--)
                Padding(
                  padding: const EdgeInsets.all(padding),
                  child: Row(
                    children: [
                      Text("・${rankings.length-i}"),
                      const Spacer(),
                      Text("${rankings[i]}"),
                      const Spacer(),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

void _loadRankings({required WidgetRef ref})async{
  final FirebaseDatabase rtdb = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: databaseURL);
  try{
    final snapshot = await rtdb.ref("rankings/users")
        .orderByChild("score").limitToLast(100).get();
    if(snapshot.exists){
      // Logger().i("snapshot is existed");
      final users = snapshot.children;
      final List<UserInformation> userList = [];
      for(final user in users){
        final userData = UserInformation.fromJson(Map<String, dynamic>.from(user.value as Map));
        userList.add(userData);
        // Logger().i("userList is added");
      }
      if(userList.length < 100){

      }
      ref.read(rankingListProvider.notifier).state = userList;
    }
  } catch (e){
    Logger().i(e);
  }
}