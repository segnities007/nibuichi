import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:nibuichi/providers/user_information_provider.dart';
import '../../../common_logics/firebase.dart';
import '../../../common_data/user_information.dart';
import '../../../providers/game_provider.dart';
import '../../commons/commons.dart';

////////////////////////////////////////////////////////////////////////////////

class FailUI extends ConsumerWidget{
  const FailUI({super.key});

  @override
  Widget build(context, ref){
    final score = ref.watch(scoreProvider);

    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: Column(
              children: [
                const Text("fail"),
                Text("your score is $score")
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: ElevatedButton(
              style: buttonStyle(n: n),
              onPressed: ()async{
                await goNextScreen(score: score, context: context,ref:ref);
              },
              child: const Text("back to home"),
            ),
          ),
        ),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<void> goNextScreen({
  required int score,
  required BuildContext context,
  required WidgetRef ref,
})async{
    final judge = await isHighScore(score: score,ref: ref);
    if(judge){
      await isAddedRanking(score: score);
    }
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.go("/hub");
    });
}

////////////////////////////////////////////////////////////////////////////////

Future<void> isAddedRanking({
  required int score,
})async{
  try{
    final UserInformation currentUser = UserInformation(highScore: score);
    await canSetRankingToDB(currentUser: currentUser);
  }catch (e){
    Logger().i(e);
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<bool> isHighScore({
  required int score,
  required WidgetRef ref,
})async{
  try{
    final user = await getUserInformationOrNullFromDB();
    if(user != null){
      if(user.highScore < score){
        user.setScore(score);
        await setUserInformationToDB(user: user);
        ref.read(userInformationProvider.notifier).state = user;
        return true;
      }
    }
  }catch(e){
    Logger().i(e);
  }
  return false;
}
