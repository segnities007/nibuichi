import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nibuichi/screens/commons/commons.dart';
import 'package:nibuichi/screens/commons/id_card.dart';

import '../../../common_logics/firebase.dart';

////////////////////////////////////////////////////////////////////////////////

class HomeUI extends ConsumerWidget{
  const HomeUI({super.key});

  @override
  Widget build(context, ref){

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(padding),
          child: IDCard(),
        ),
        Center(
          child: ElevatedButton(
              style: buttonStyle(n: 10),
              onPressed: (){
                context.go("/game");
              },
              child: const Text("game")
          ),
        )
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////