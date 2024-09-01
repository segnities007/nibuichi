import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/providers/user_information_provider.dart';
import '../../../../common_logics/operation_image.dart';

////////////////////////////////////////////////////////////////////////////////

class ChangeIDCard extends ConsumerWidget {
  const ChangeIDCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInformationProvider);

    return Column(
      children: [
        (user != null && user.imagePath != null)
            ? Image.file(File(user.imagePath!))
            : const Text("No image selected"),
        ElevatedButton(
          onPressed: () async {
            await selectImage(ref: ref);
          },
          child: const Text("Change Image"),
        ),
        ElevatedButton(
          onPressed: () async {
            await deleteImage(ref);
          },
          child: const Text("Delete Image"),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////