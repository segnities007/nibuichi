import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:nibuichi/common_data/user_information.dart';
import '../common_data/databaseURL.dart';

////////////////////////////////////////////////////////////////////////////////

class FirebaseInstances{
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final DatabaseReference realTimeDB = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: databaseURL).ref();
  static final Reference storage = FirebaseStorage.instance.ref();
}

////////////////////////////////////////////////////////////////////////////////

Future<void> canSetRankingToDB({
  required UserInformation currentUser
})async{
  try{
    final userList = await getRankingFromDB();

    if(userList.isNotEmpty){
      bool isExist = false;
      if(userList.first.highScore < currentUser.highScore){
        isExist = userList.any((user)=>
          currentUser.uid == user.uid &&
          currentUser.highScore > user.highScore
        );
      }

      if(isExist){
        await FirebaseInstances.realTimeDB
            .child("rankings/users/${currentUser.uid}")
            .update(currentUser.toJson());
      }else{
        await FirebaseInstances.realTimeDB
            .child("rankings/users/${userList.first.uid}")
            .remove();
        await FirebaseInstances.realTimeDB
            .child("rankings/users/${currentUser.uid}")
            .set(currentUser.toJson());
      }

    }else{
      await FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: databaseURL)
          .ref("rankings/users/${currentUser.uid}")
          .set(currentUser.toJson());
    }

  }catch (e){
    Logger().i(e);
  }
}

////////////////////////////////////////////////////////////////////////////////

Future<List<UserInformation>> getRankingFromDB()async{
  final List<UserInformation> rankings = [];
  try{
    final snapshot = await FirebaseInstances.realTimeDB
        .child("rankings/users/")
        .child("")
        .orderByChild("score")
        .limitToLast(100)
        .get();

    if(snapshot.exists){
      for(final child  in snapshot.children){
        final value = Map<String, dynamic>.from(child.value as Map);
        rankings.add(UserInformation.fromJson(value));
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
    final snapshot = await FirebaseInstances.realTimeDB
        .child("users/${FirebaseAuth.instance.currentUser!.uid}").get();

    if(snapshot.exists){
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return UserInformation.fromJson(data);
    }
  }catch(e){
    Logger().i(e);
  }
  return null;
}

////////////////////////////////////////////////////////////////////////////////

Future<void> setUserInformationToDB({
  required UserInformation user,
})async{
  try{
    await FirebaseInstances.realTimeDB
        .child("users/${FirebaseAuth.instance.currentUser!.uid}")
        .update(user.toJson());

  }catch(e){
    Logger().i(e);
  }
}

