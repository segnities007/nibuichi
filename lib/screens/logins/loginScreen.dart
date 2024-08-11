import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nibuichi/screens/common_uis/button_style.dart';
import '../../providers/nibuser_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

////////////////////////////////////////////////////////////////////////////////

const uiList = [SignInUI(), SignUpUI(), SplashScreen()];
const double n = 8.5;
const double padding  = 32;

////////////////////////////////////////////////////////////////////////////////

class SplashScreen extends ConsumerStatefulWidget{
  const SplashScreen({super.key});

  @override
  StateSplashScreen createState() => StateSplashScreen();
}

class StateSplashScreen extends ConsumerState<SplashScreen>{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        context.go("/hub");
      }else{
        ref.read(nibuIndexProvider.notifier).state = 0;
      }
    });
  }

  @override
  Widget build(context){
    return const Center(
      child: Text("welcome"),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class LoginScreen extends ConsumerWidget{
  const LoginScreen({super.key});

  @override
  Widget build(context, ref){
    final index = ref.watch(nibuIndexProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Home")),
          backgroundColor: Colors.green[400],
        ),
        body: uiList[index]
    );
  }
}

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
                        ref.read(nibuIndexProvider.notifier).state = 1;
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

////////////////////////////////////////////////////////////////////////////////

class SignUpUI extends ConsumerStatefulWidget{
  const SignUpUI({super.key});

  @override
  StateSignUpUI createState() => StateSignUpUI();
}

////////////////////////////////////////////////////////////////////////////////

class StateSignUpUI extends ConsumerState<SignUpUI>{

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
              const Center(child: Text("sign up")),
              Padding(
                padding: const EdgeInsets.all(padding),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "Input new email"
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(padding),
                child: TextFormField(
                  controller: passwordController,
                  obscureText:  true,
                  decoration: const InputDecoration(
                    hintText: "Input new password"
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(padding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: buttonStyle(n: n),
                      onPressed: () async {
                        if(formKey.currentState?.validate() == true){
                          try{
                            FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text
                            );
                            ref.read(nibuserProvider.notifier).state = Nibuser(email: emailController.text, password: passwordController.text);
                            emailController.text = "";
                            passwordController.text = "";
                          }on FirebaseAuthException catch (e) {
                            if(e.code == "weak-password"){
                              debugPrint("The password provided is too weak.");
                            }else if(e.code == "email-already-in-use"){
                              debugPrint("The account already exists for that email.");
                            }
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        }
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text("sign up"),
                    ),
                    ElevatedButton.icon(
                      style: buttonStyle(n: n),
                      onPressed: (){
                        ref.read(nibuIndexProvider.notifier).state = 0;
                      },
                      icon: const Icon(Icons.login),
                      label: const Text("go sign in"),
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

////////////////////////////////////////////////////////////////////////////////
