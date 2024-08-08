import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/screens/hubs/hubs.dart';
import 'package:nibuichi/screens/hubs/hubScreen.dart';
import 'package:nibuichi/screens/logins/logins.dart';

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

void main() {
  runApp(
      const ProviderScope(
          child: MyApp()
      )
  );
}