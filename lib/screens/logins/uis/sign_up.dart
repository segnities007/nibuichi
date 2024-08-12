import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/login_provider.dart';
import '../../common_uis/button_style.dart';
import 'package:nibuichi/screens/logins/common_data.dart';

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
    final nameController = TextEditingController();
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
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      hintText: "Input new name"
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(padding),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
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
                  keyboardType: TextInputType.visiblePassword,
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
                            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text
                            );
                            await FirebaseAuth.instance.currentUser!.updateDisplayName(nameController.text);
                            emailController.text = "";
                            passwordController.text = "";
                            nameController.text = "";
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
                        ref.read(keyProvider.notifier).state = "sign-in";
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
