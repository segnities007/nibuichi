import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nibuichi/common_logics/firebase.dart';
import 'package:nibuichi/common_logics/operation_image.dart';
import 'package:nibuichi/providers/user_information_provider.dart';
import 'package:nibuichi/screens/commons/common_data.dart';
import '../../../common_data/user_information.dart';

////////////////////////////////////////////////////////////////////////////////

class CreateUserInformation extends ConsumerWidget{
  const CreateUserInformation({super.key});

  @override
  Widget build(context, ref){
    final formKey = GlobalKey();
    final nameController = TextEditingController();
    final user = ref.watch(userInformationProvider);
    bool isSuccess = false;

    return Form(
      key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(padding),
              child: TextField(
                decoration: const InputDecoration(
                    hintText: "Input your email"
                ),
                controller: nameController,
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(padding),
                child:
                (user != null && user.imagePath != null)
                    ? Image.file(
                    File(user.imagePath as String),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                )
                    : ElevatedButton(
                    onPressed: ()async{
                      await selectImage(ref: ref);
                    },
                    child: const Text("Select Image")
                ),
            ),
            Padding(
                padding: const EdgeInsets.all(padding),
              child: ElevatedButton(
                  onPressed: ()async{
                    await isSuccessSettingInformation(
                        formKey: formKey,
                        ref: ref,
                        user: user,
                        context: context,
                        nameController: nameController
                    );
                    isSuccess = true;
                  },
                  child: const Text("Set your profile")
              ),
            ),
            if(isSuccess)
              const Text("failed")
          ],
        )
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<void> isSuccessSettingInformation({
  required formKey,
  required WidgetRef ref,
  required UserInformation? user,
  required BuildContext context,
  required TextEditingController nameController,
})async{
  if(formKey.currentState?.validate() == true && user?.imagePath != null){
    final user = ref.watch(userInformationProvider);
    user?.name = nameController.value.text;
    setUserInformationToDB(user: user!);
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.go("/hub");
    });
  }
}