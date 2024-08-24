import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:nibuichi/datas/user_information.dart';
import 'databaseURL.dart';


////////////////////////////////////////////////////////////////////////////////

Future<void> canSetRankingToDB({
  required UserInformation currentUser
})async{
  try{
    final userList = await getRankingFromDB();
    if(userList.isNotEmpty){
      bool isExist = false;
      final lowerUser = userList.first;
      if(lowerUser.highScore < currentUser.highScore){
        for(final user in userList){
          if(currentUser.uid == user.uid){
            if(currentUser.highScore > user.highScore){
              isExist = true;
            }
          }
        }
      }
      if(isExist){
        await FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: databaseURL)
            .ref("rankings/users/${currentUser.uid}").update(currentUser.toJson());
      }else{
        await FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: databaseURL)
            .ref("rankings/users/${lowerUser.uid}").remove();
        await FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: databaseURL)
            .ref("rankings/users/${currentUser.uid}").set(currentUser.toJson());
      }
    }else{
      await FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: databaseURL)
          .ref("rankings/users/${currentUser.uid}").set(currentUser.toJson());
    }

  }catch (e){
    Logger().i(e);
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<List<UserInformation>> getRankingFromDB()async{
  final List<UserInformation> rankings = [];
  try{
    final rtdb = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: databaseURL);
    final snapshot = await rtdb.ref("rankings/users/").child("").orderByChild("score").limitToLast(100).get();
    if(snapshot.exists){
      final children = snapshot.children;
      for(final child  in children){
        final value = child.value as Map<Object?, Object?>;
        final Map<String, dynamic> userMap = {};
        value.forEach((key, value){
          userMap[key as String] = value;
        });
        rankings.add(UserInformation.fromJson(userMap));
      }
    }
    return rankings;
  }catch (e){
    Logger().i(e);
  }
  return rankings;
}

////////////////////////////////////////////////////////////////////////////////

Future<UserInformation?> getUserInformationOrNullFromDB()async{
  try{
    final rtdb = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: databaseURL);
    final snapshot = await rtdb.ref("users/${FirebaseAuth.instance.currentUser!.uid}").get();
    if(snapshot.exists){
      final value = snapshot.value as Map<Object?, Object?>;
      final Map<String, dynamic> userMap = {};
      value.forEach((key, value){
        userMap[key as String] = value;
      });
      final user = UserInformation.fromJson(userMap);
      return user;
    }
  }catch(e){
    Logger().i(e);
  }
  return null;
}

////////////////////////////////////////////////////////////////////////////////

Future<void> setUserInformationToDB({required UserInformation user})async{
  try{
    final rtdb = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: databaseURL);
    await rtdb.ref("users/${FirebaseAuth.instance.currentUser!.uid}").update(user.toJson());
  }catch(e){
    Logger().i(e);
  }
}

