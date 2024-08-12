import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nibuichi/providers/game_provider.dart';
import 'package:nibuichi/screens/common_uis/common_uis.dart';
import '../common_uis/button_style.dart';

////////////////////////////////////////////////////////////////////////////////

const double n = 8.5;
const double padding = 32;
const screenUI = {"game-ui": GameUI(), "result-ui": ResultUI()};

////////////////////////////////////////////////////////////////////////////////

class GameScreen extends ConsumerWidget{
  const GameScreen({super.key});

  @override
  Widget build(context, ref){
    final index = ref.watch(gameIndexProvider);
    ref.watch(scoreProvider); // this code can have score until go home.
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
    final resultHL = ref.watch(lhProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text("$x"),
                ),
                Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(resultHL),
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

class SuccessUI extends ConsumerWidget{
  const SuccessUI({super.key});

  @override
  Widget build(context, ref){
    return Column(
      children: [
        const Expanded(
          flex: 1,
          child: Center(
            child: Text("Clear! next"),
          ),
        ),
        Expanded(
            flex: 1,
            child: Center(
              child: ElevatedButton(
                  style: buttonStyle(n: n),
                  onPressed: (){
                    ref.read(scoreProvider.notifier).state++;
                    ref.read(gameIndexProvider.notifier).state = "game-ui";

                    //TODO push score to database.

                  },
                  child: const Text("next game")
              ),
            )
        ),
      ],
    );
  }
}

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
                    context.go("/hub");
                  },
                  child: const Text("back to home")
              ),
            )
        ),
      ],
    );
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
