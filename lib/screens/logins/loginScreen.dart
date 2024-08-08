import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

////////////////////////////////////////////////////////////////////////////////

class LoginScreen extends StatelessWidget{
  const LoginScreen({super.key});

  @override
  Widget build(context){
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Home")),
          backgroundColor: Colors.green[400],
        ),
        body: const SignInUI()
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
    final user = ref.watch(userProvider);

    return Center(
      child: Form(
        key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text(user.toString())),
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
                      if(formKey.currentState?.validate() == true){
                        ref.read(userProvider.notifier).state = User(email: emailController.text, password: passwordController.text);
                      }
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text("go sign up"),
                  ),
                  ElevatedButton.icon(
                    onPressed: (){

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
    String email = "";
    String password = "";
    final controller = TextEditingController();
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
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Input new email"
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  controller: controller,
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
                      onPressed: (){
                        if(formKey.currentState?.validate() == true){
                          email = controller.text;
                        }
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    label: const Text("sign up"),
                  ),
                  ElevatedButton.icon(
                      onPressed: (){

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

