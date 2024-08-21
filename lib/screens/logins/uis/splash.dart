import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nibuichi/datas/databaseURL.dart';
import 'package:nibuichi/providers/ranking_list_provider.dart';
import '../../../datas/user_rank.dart';
import '../../../providers/login_provider.dart';
import 'package:logger/logger.dart';

////////////////////////////////////////////////////////////////////////////////

class SplashUI extends ConsumerStatefulWidget {
  const SplashUI({super.key});

  @override
  ConsumerState<SplashUI> createState() => StateSplashScreen();
}

class StateSplashScreen extends ConsumerState<SplashUI> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init(ref: ref, context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("welcome"),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<void> _init({required WidgetRef ref, required BuildContext context}) async {
  bool isUserLoggedIn = false;
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      isUserLoggedIn = true;
    }
  } catch (e) {
    Logger().i(e);
  }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isUserLoggedIn) {
        context.go("/hub");
      } else {
        ref.read(keyProvider.notifier).state = "sign-in";
      }
    });
}
