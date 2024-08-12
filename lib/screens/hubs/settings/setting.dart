import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingUI extends StatelessWidget{
  const SettingUI({super.key});

  @override
  Widget build(context){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  await FirebaseAuth.instance.signOut();
                  await user?.delete();
                  context.go("/");
                },
                child: const Text("sign out")
            ),
          )
        )
      ],
    );
  }
}