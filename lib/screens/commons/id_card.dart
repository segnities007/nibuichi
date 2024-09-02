import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/common_data/user_information.dart';
import 'package:nibuichi/providers/user_information_provider.dart';


////////////////////////////////////////////////////////////////////////////////

const double size = 100;

////////////////////////////////////////////////////////////////////////////////

class IDCard extends ConsumerWidget{
  const IDCard({super.key});

  @override
  Widget build(context, ref){
    final user = ref.watch(userInformationProvider);

    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        /// icon
        /// status
        children: [
          (user != null)
              ? IconUI(imagePath: user.imagePath)
              : const Text("user isn't exist"),
          (user != null)
              ? StatusUI(user: user)
              : const Text("user isn't exist")
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class IconUI extends StatelessWidget{
  const IconUI({super.key, required this.imagePath});

  final String? imagePath;

  @override
  Widget build(context){
    if(imagePath != null){
      return Image.file(
          File(imagePath!),
        width: size,
        height: size,
        fit: BoxFit.cover,
      );
    }else{
      return const Text("Image isn't selected");
    }
  }
}

////////////////////////////////////////////////////////////////////////////////

class StatusUI extends StatelessWidget{
  const StatusUI({
    super.key,
    required this.user,
  });

  final UserInformation user;

  @override
  Widget build(context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("name: ${user.name}"),
        Text("highScore: ${user.highScore}"),
        Text("coin: ${user.coin}")
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
