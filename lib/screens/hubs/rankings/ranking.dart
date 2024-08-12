import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

////////////////////////////////////////////////////////////////////////////////

class RankingUI extends ConsumerStatefulWidget{
  const RankingUI({super.key});

  @override
  StateRankingUI createState() => StateRankingUI();
}

class StateRankingUI extends ConsumerState<RankingUI>{

  late final DatabaseReference dbRef;

  void init(){
    dbRef = FirebaseDatabase.instance
        .ref("users/${FirebaseAuth.instance.currentUser?.uid}");
  }

  @override
  Widget build(context){
    return const Center(
      child: Text("ranking")
    );
  }
}

////////////////////////////////////////////////////////////////////////////////