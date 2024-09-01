import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/screens/logins/uis/create_user_infromation.dart';
import 'package:nibuichi/screens/logins/uis/sign_in.dart';
import 'package:nibuichi/screens/logins/uis/sign_up.dart';
import 'package:nibuichi/screens/logins/uis/splash.dart';
import '../../providers/login_provider.dart';

////////////////////////////////////////////////////////////////////////////////

const uiList = {
  "sign-in": SignInUI(),
  "sign-up": SignUpUI(),
  "splash": SplashUI(),
  "create-user-information": CreateUserInformation(),
};

////////////////////////////////////////////////////////////////////////////////

class LoginScreen extends ConsumerWidget{
  const LoginScreen({super.key});

  @override
  Widget build(context, ref){
    final indexKey = ref.watch(loginIndexProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Center(child: Text("Home")),
          backgroundColor: Colors.green[400],
        ),
        body: uiList[indexKey]
    );
  }
}
