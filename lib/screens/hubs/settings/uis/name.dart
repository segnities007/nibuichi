import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:nibuichi/providers/hub_provider.dart';
import 'package:nibuichi/screens/commons/common_data.dart';

import '../../../../common_logics/firebase.dart';

////////////////////////////////////////////////////////////////////////////////

class NameUI extends HookConsumerWidget{
  const NameUI({super.key});

  @override
  Widget build(context, ref){
    final controller = TextEditingController();
    final text = useState("");

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(padding, padding, padding, 0),
          child: Text(text.value),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(padding, padding, padding, 0),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Input new name"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(padding, padding, padding, 0),
          child: ElevatedButton(
              onPressed: ()async{
                final name = controller.text;
                await changeName(newName: name);
                text.value = "Name is changed.";
              },
              child: const Text("change Name")
          ),
        ),
      ]
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<void> changeName({
  required String newName
})async{
  try{
    try{
      final currentUser = FirebaseAuth.instance.currentUser!;
      await currentUser.updateDisplayName(newName);
      final user = await getUserInformationOrNullFromDB();
      if(user != null){
        user.name = newName;
        setUserInformationToDB(user: user);
        canSetRankingToDB(currentUser: user);
      }
    }catch (e){
      Logger().i(e);
    }
  }catch (e){
    Logger().i(e);
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<void> goChangeName(context, ref)async{
  ref.read(settingKeyProvider.notifier).state = "NameUI";
}