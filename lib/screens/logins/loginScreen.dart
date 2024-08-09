import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/nibuser_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

////////////////////////////////////////////////////////////////////////////////

const uiList = [SignInUI(), SignUpUI()];

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

class SignInUI extends ConsumerWidget{
  const SignInUI({super.key});

  @override
  Widget build(context, ref){
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final nibuser = ref.watch(nibuserProvider);

    return Center(
      child: Form(
        key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text(nibuser.toString())),
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
                      try{
                        final credential = FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text
                        );
                      } on FirebaseAuthException catch (e) {
                        if(e.code == "user-not-found"){
                          debugPrint("No user found for that email.");
                        }else if(e.code == "wrong-password"){
                          debugPrint("Wrong password provided for that user.");
                        }
                      }
                    },
                    icon: const Icon(Icons.login),
                    label: const Text("sign in"),
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

class SignUpUI extends ConsumerWidget{
  const SignUpUI({super.key});

  @override
  Widget build(context, ref){
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
                            final credential = FirebaseAuth.instance.createUserWithEmailAndPassword(
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

