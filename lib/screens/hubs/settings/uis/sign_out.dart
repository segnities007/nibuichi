import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nibuichi/providers/user_information_provider.dart';

////////////////////////////////////////////////////////////////////////////////

Future<void> signOut({
  required BuildContext context,
  required WidgetRef ref,
})async{
  await FirebaseAuth.instance.signOut();
  ref.read(userInformationProvider.notifier).state = null;
  WidgetsBinding.instance.addPostFrameCallback((_){
    context.go("/");
  });
}