import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../providers/login_provider.dart';

////////////////////////////////////////////////////////////////////////////////

class SplashUI extends ConsumerStatefulWidget{
  const SplashUI({super.key});

  @override
  StateSplashScreen createState() => StateSplashScreen();
}

class StateSplashScreen extends ConsumerState<SplashUI>{

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        context.go("/hub");
      }else{
        ref.read(keyProvider.notifier).state = "sign-in";
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