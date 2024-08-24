import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nibuichi/providers/game_provider.dart';
import 'package:nibuichi/screens/games/uis/uis.dart';
import '../commons/common_data.dart';
import '../commons/appbar.dart';
import '../commons/button_style.dart';
import 'dart:math' as math;

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

class GameUI extends HookConsumerWidget{
  const GameUI({super.key});

  @override
  Widget build(context, ref){
    final x = useState<int>(math.Random().nextInt(101));
    final y = useState<int>(math.Random().nextInt(101));
    ref.watch(isClearProvider);//koko

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text("${x.value}"),
                ),
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
                      ref.read(isClearProvider.notifier).state= isSmallNumber(x.value, y.value);
                      ref.read(gameIndexProvider.notifier).state = "result-ui";
                    },
                    child: const Text("High")
                ),
                ElevatedButton(
                    style: buttonStyle(n: n),
                    onPressed: (){
                      ref.read(isClearProvider.notifier).state= isSmallNumber(y.value, x.value);
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
    final result = ref.watch(isClearProvider);

    if(result){
      return const SuccessUI();
    }else{
      return const FailUI();
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

bool isSmallNumber(int x, int y){
  if(x > y){
    return false;
  }
  return true;
}

////////////////////////////////////////////////////////////////////////////////
