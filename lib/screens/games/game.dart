import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nibuichi/providers/game_provider.dart';
import 'package:nibuichi/screens/games/uis/uis.dart';
import '../commons/common_data.dart';
import '../commons/appbar.dart';
import '../commons/button_style.dart';

////////////////////////////////////////////////////////////////////////////////

const screenUI = {
  "game-ui": GameUI(),
  "result-ui": ResultUI()
};

////////////////////////////////////////////////////////////////////////////////

class GameScreen extends ConsumerWidget{
  const GameScreen({super.key});

  @override
  Widget build(context, ref){
    final index = ref.watch(gameIndexProvider);
    ref.watch(scoreProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: commonAppBar,
      body: screenUI[index]
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class GameUI extends ConsumerWidget{
  const GameUI({super.key});

  @override
  Widget build(context, ref){
    final x = ref.watch(xProvider);
    final y = ref.watch(yProvider);
    final result = ref.watch(lhProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text("$x"),
                ),
                Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(result),
                )
              ]
            ),
        ),
          Padding(
              padding: const EdgeInsets.all(padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: buttonStyle(n: n),
                    onPressed: (){
                      ref.read(lhProvider.notifier).state= isSmallNumber(x, y);
                      ref.read(gameIndexProvider.notifier).state = "result-ui";
                    },
                    child: const Text("High")
                ),
                ElevatedButton(
                    style: buttonStyle(n: n),
                    onPressed: (){
                      ref.read(lhProvider.notifier).state= isSmallNumber(y, x);
                      ref.read(gameIndexProvider.notifier).state = "result-ui";
                    },
                    child: const Text("Low")
                )
              ],
            )
          ),
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, padding),
          child: ElevatedButton(
            style: buttonStyle(n: n),
            onPressed: (){
              context.go("/hub");
            },
            child: const Text("hub"),
          ),
        )
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class ResultUI extends ConsumerWidget{
  const ResultUI({super.key});


  @override
  Widget build(context, ref){
    final result = ref.watch(lhProvider);

    if(result == "Clear!"){
      return const SuccessUI();
    }else{
      return const FailUI();
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

String isSmallNumber(int x, int y){
  if(x > y){
    return "Fail";
  }
  return "Clear!";
}

////////////////////////////////////////////////////////////////////////////////
