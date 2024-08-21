import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/game_provider.dart';
import '../../commons/commons.dart';

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
                  },
                  child: const Text("next game")
              ),
            )
        ),
      ],
    );
  }
}
