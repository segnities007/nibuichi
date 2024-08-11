import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nibuichi/screens/common_uis/button_style.dart';

class HomeUI extends StatelessWidget{
  const HomeUI({super.key});

  @override
  Widget build(context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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