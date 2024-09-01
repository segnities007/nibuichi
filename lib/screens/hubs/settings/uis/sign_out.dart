import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

////////////////////////////////////////////////////////////////////////////////

Future<void> signOut(BuildContext context, ref)async{
  await FirebaseAuth.instance.signOut();
  WidgetsBinding.instance.addPostFrameCallback((_){
    context.go("/");
  });
}