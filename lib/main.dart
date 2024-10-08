import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/screens/games/game.dart';
import 'package:nibuichi/screens/hubs/hubs.dart';
import 'package:nibuichi/screens/hubs/hubScreen.dart';
import 'package:nibuichi/screens/logins/logins.dart';
import 'firebase_options.dart';

////////////////////////////////////////////////////////////////////////////////

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
        path: "/hub",
        builder: (context, state) => const HubScreen()
    ),
    GoRoute(
      path: "/",
      builder: (context, state) => const LoginScreen()
    ),
    GoRoute(
        path: "/game",
      builder: (context, state) => const GameScreen()
    ),
  ],
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
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseDatabase.instance.setPersistenceEnabled(true);

  runApp(
      const ProviderScope(
          child: MyApp()
      )
  );
}