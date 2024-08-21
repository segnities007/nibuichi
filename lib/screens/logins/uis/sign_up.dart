import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nibuichi/datas/databaseURL.dart';
import '../../../datas/user_information.dart';
import '../../../providers/login_provider.dart';
import 'package:nibuichi/screens/commons/common_data.dart';
import '../../commons/button_style.dart';

////////////////////////////////////////////////////////////////////////////////

class SignUpUI extends ConsumerWidget{
  const SignUpUI({super.key});

  @override
  Widget build(context, ref){
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
                      onPressed: ()async{
                        final a = await createUser(formKey: formKey ,name: nameController.text, email: emailController.text, password: passwordController.text, ref: ref);
                        a();
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

////////////////////////////////////////////////////////////////////////////////

Future<Function()> createUser({
  required formKey,
  required String name,
  required String email,
  required String password,
  required WidgetRef ref,
})async{
  return ()async{
    if(formKey.currentState?.validate() == true){
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
        final user = UserInformation(highScore: 0);
        await FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: databaseURL)
            .ref("users/${FirebaseAuth.instance.currentUser!.uid}").set(user.toJson());
        ref.read(keyProvider.notifier).state = "sign_in";
      }on FirebaseAuthException catch (e) {
        if(e.code == "weak-password"){
          debugPrint("The password provided is too weak.");
        }else if(e.code == "email-already-in-use"){
          debugPrint("The account already exists for that email.");
        }
      } catch (e) {
        Logger().i(e);
      }
    }
  };
}