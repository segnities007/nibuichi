import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/common_data/user_information.dart';
import 'package:nibuichi/providers/user_information_provider.dart';
import 'package:nibuichi/screens/commons/common_data.dart';

////////////////////////////////////////////////////////////////////////////////

const double size = 200; // 円の直径

////////////////////////////////////////////////////////////////////////////////

class IDCard extends ConsumerWidget {
  const IDCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInformationProvider);

    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(padding * 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (user != null && user.imagePath != null)
                  ? IconUI(imagePath: user.imagePath as String)
                  : const Text("User isn't exist"),
              (user != null)
                  ? StatusUI(user: user)
                  : const Text("User isn't exist"),
            ],
          ),
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class IconUI extends StatelessWidget {
  const IconUI({super.key, required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: FileImage(File(imagePath)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class StatusUI extends StatelessWidget {
  const StatusUI({
    super.key,
    required this.user,
  });

  final UserInformation user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Name: ${user.name}"),
        Text("High Score: ${user.highScore}"),
        Text("Coin: ${user.coin}"),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////
