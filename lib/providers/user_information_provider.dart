import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/datas/user_information.dart';

final scoreProvider = StateProvider.autoDispose((ref) => UserInformation(highScore: 0));
final userInformationProvider = StateProvider((ref) => <UserInformation>[]);