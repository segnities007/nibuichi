import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nibuichi/common_data/user_information.dart';
import 'package:nibuichi/providers/user_information_provider.dart';
import '../../../providers/login_provider.dart';
import 'package:nibuichi/screens/commons/common_data.dart';
import '../../commons/button_style.dart';

////////////////////////////////////////////////////////////////////////////////

class SignUpUI extends ConsumerWidget{
  const SignUpUI({super.key});

  @override
  Widget build(context, ref){
    // final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Center(
      child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Center(child: Text("sign up")),
              // Padding(
              //   padding: const EdgeInsets.all(padding),
              //   child: TextFormField(
              //     controller: nameController,
              //     keyboardType: TextInputType.text,
              //     decoration: const InputDecoration(
              //         hintText: "Input new name"
              //     ),
              //   ),
              // ),
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
                      onPressed: ()async{
                        await createUser(
                            formKey: formKey ,
                            ref: ref,
                            // name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                            context: context);
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text("sign up"),
                    ),
                    ElevatedButton.icon(
                      style: buttonStyle(n: n),
                      onPressed: (){
                        ref.read(loginIndexProvider.notifier).state = "sign-in";
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

Future<void> createUser({
  required formKey,
  required WidgetRef ref,
  // required String name,
  required String email,
  required String password,
  required BuildContext context,
})async{
    if(formKey.currentState?.validate() == true) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        // // await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
        // final user = UserInformation(highScore: 0);
        // await setUserInformationToDB(user: user);
        WidgetsBinding.instance.addPostFrameCallback((_){
          ref.read(userInformationProvider.notifier).state = UserInformation(highScore: 0);
          ref.read(loginIndexProvider.notifier).state = "create-user-information";
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          Logger().i("The password provided is too weak.");
        } else if (e.code == "email-already-in-use") {
          Logger().i("The account already exists for that email.");
        }
      } catch (e) {
        Logger().i(e);
      }
    }
}