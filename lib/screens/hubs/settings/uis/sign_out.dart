import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

////////////////////////////////////////////////////////////////////////////////

Future<void> signOut(context, ref)async{
  await FirebaseAuth.instance.signOut();
  WidgetsBinding.instance.addPostFrameCallback((_){
    context.go("/");
  });
}