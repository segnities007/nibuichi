import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/nibuser_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

////////////////////////////////////////////////////////////////////////////////

const uiList = [SignInUI(), SignUpUI(), SplashScreen()];

////////////////////////////////////////////////////////////////////////////////

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  StateSplashScreen createState() => StateSplashScreen();
}

class StateSplashScreen extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        context.go("/hub");
      }else{
        context.go("/");
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
              const Center(child: Text("login")),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Input your email"
                  ),
                  controller: emailController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: "Input your password"
                  ),
                  obscureText: true,
                  controller: passwordController,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: (){
                      ref.read(nibuIndexProvider.notifier).state = 1;
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text("go sign up"),
                  ),
                  ElevatedButton.icon(
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "Input new email"
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: passwordController,
                  obscureText:  true,
                  decoration: const InputDecoration(
                    hintText: "Input new password"
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
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
                      onPressed: (){
                        ref.read(nibuIndexProvider.notifier).state = 0;
                      },
                      icon: const Icon(Icons.login),
                      label: const Text("go sign in"),
                  )
                ],
              )
            ],
          )
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
