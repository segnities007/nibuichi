import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common_data/user_information.dart';
////////////////////////////////////////////////////////////////////////////////////////////////////

final rankingListProvider = StateProvider<List<UserInformation>>((ref) => []);