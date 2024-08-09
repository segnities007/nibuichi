import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

////////////////////////////////////////////////////////////////////////////////

class Nibuser{
  Nibuser({
    this.name,
    this.email,
    this.password,
    String? uuid
  }): uuid = const Uuid().v4();

  String? name;
  String? email;
  String? password;
  String uuid;

  Nibuser.fromJson(Map<String, dynamic> json)
    : this(
    name: json["name"] as String,
    email: json["email"] as String,
    password: json["password"] as String,
    uuid: json["uuid"] as String
    );

  Map<String, dynamic> toJson(){
    return {
      "name": name,
      "email": email,
      "password": password,
      "uuid": uuid
    };
  }

  @override
  String toString(){
    return "$name, $email $password $uuid";
  }
}

////////////////////////////////////////////////////////////////////////////////

// class UserProvider extends Notifier<User> {
//   @override
//   User build(){
//     return User();
//   }
//
//   void setUser(User user){
//     state = user;
//   }
// }

////////////////////////////////////////////////////////////////////////////////

final nibuserProvider = StateProvider<Nibuser>((ref) => Nibuser());
final nibuIndexProvider = StateProvider((ref) => 2);
// final emailProvider = StateProvider<String>((ref) => "");
// final passwordProvider = StateProvider<String>((ref) => "");