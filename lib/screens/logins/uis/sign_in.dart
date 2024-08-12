import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nibuichi/providers/login_provider.dart';
import '../../common_uis/button_style.dart';
import 'package:nibuichi/screens/logins/common_data.dart';

////////////////////////////////////////////////////////////////////////////////

class SignInUI extends ConsumerStatefulWidget{
  const SignInUI({super.key});

  @override
  StateSignInUI createState() => StateSignInUI();
}

////////////////////////////////////////////////////////////////////////////////

class StateSignInUI extends ConsumerState<SignInUI>{

  @override
  Widget build(context){
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Center(
      child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(child: Text("sign in")),
              Padding(
                padding: const EdgeInsets.all(padding),
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Input your email"
                  ),
                  controller: emailController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(padding),
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Input your password"
                  ),
                  obscureText: true,
                  controller: passwordController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: buttonStyle(n: n),
                      onPressed: (){
                        ref.read(keyProvider.notifier).state = "sign-up";
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text("go sign up"),
                    ),
                    ElevatedButton.icon(
                      style: buttonStyle(n: n),
                      onPressed: () async {
                        try {
                          final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          if (credential.user != null) {
                            context.go("/hub");
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == "user-not-found") {
                            debugPrint("No user found for that email.");
                          } else if (e.code == "wrong-password") {
                            debugPrint("Wrong password provided for that user.");
                          } else {
                            debugPrint("Sign-in failed: $e");
                          }
                        }
                      },
                      icon: const Icon(Icons.login),
                      label: const Text("Sign In"),
                    )
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}