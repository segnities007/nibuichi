import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/datas/user_information.dart';

////////////////////////////////////////////////////////////////////////////////////////////////////

final rankingListProvider = StateProvider<List<UserInformation>>((ref) => []);