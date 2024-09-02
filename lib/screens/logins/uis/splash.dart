import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nibuichi/providers/user_information_provider.dart';
import '../../../common_logics/firebase.dart';
import '../../../providers/login_provider.dart';

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
      _init(ref: ref, context: context);
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
    if (FirebaseInstances.auth.currentUser != null) {
      isUserLoggedIn = true;
      final user = await getUserInformationOrNullFromDB();
      if (user != null) {
        Future(() {
          ref.read(userInformationProvider.notifier).state = user;
        });
      }
    }

    // Logger().i("u");

  } catch (e) {
    Logger().e(e.toString());
  } finally {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Logger().i("a");
      if (isUserLoggedIn) {
        context.go("/hub");
      } else {
        // Future(() {
          ref.read(loginIndexProvider.notifier).state = "sign-in";
        // });
      }
    });
  }
}
