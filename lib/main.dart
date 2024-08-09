import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/screens/hubs/hubs.dart';
import 'package:nibuichi/screens/hubs/hubScreen.dart';
import 'package:nibuichi/screens/logins/logins.dart';

import 'firebase_options.dart';

////////////////////////////////////////////////////////////////////////////////

final GoRouter _router = GoRouter(routes: [
    GoRoute(
        path: "/a",
        builder: (context, state) => const HubScreen()
    ),
    GoRoute(
      path: "/",
      builder: (context, state) => const LoginScreen()
    ),
  ]
);

////////////////////////////////////////////////////////////////////////////////

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(context){
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Firebase initialization failed: $e');
    }
  }
  //
  //
  // FirebaseAuth.instance
  // .authStateChanges()
  // .listen((User? user){
  //   if(kDebugMode){
  //     if(user == null){
  //       debugPrint("User is currently signed out!");
  //     }else{
  //       debugPrint("User is signed in!");
  //     }
  //   }
  // });

  runApp(
      const ProviderScope(
          child: MyApp()
      )
  );
}