import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/providers/hub_provider.dart';
import '../settings/uis/uis.dart';

////////////////////////////////////////////////////////////////////////////////

const uiList = {
  "SettingHomeUI": SettingHomeUI(),
  "NameUI": NameUI(),
};

////////////////////////////////////////////////////////////////////////////////

class SettingUI extends ConsumerWidget{
  const SettingUI({super.key});

  @override
  Widget build(context, ref){
    final key = ref.watch(settingKeyProvider);
    return uiList[key] ?? const SettingHomeUI();
  }
}

////////////////////////////////////////////////////////////////////////////////

class SettingHomeUI extends ConsumerWidget{
  const SettingHomeUI({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        SettingButton(text: "sign out", onPressed: (context, ref) => signOut(context: context, ref: ref)),
        const SettingButton(text: "change name", onPressed: goChangeName),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

class SettingButton extends ConsumerWidget{
  const SettingButton({
  super.key,
  required this.text,
  this.padding = 20,
  required this.onPressed,
  });

  final String text;
  final double padding;
  final Future<void> Function(BuildContext, WidgetRef) onPressed;
  final double elevation = 5;

  @override
  Widget build(context, ref){
    return Padding(
        padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(elevation: elevation),
              onPressed: ()=>onPressed(context, ref),
              child: Text(text)
          ),
        )
    );
  }
}

////////////////////////////////////////////////////////////////////////////////