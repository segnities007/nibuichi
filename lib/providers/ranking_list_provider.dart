import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/datas/user_rank.dart';

////////////////////////////////////////////////////////////////////////////////////////////////////

final rankingListProvider = StateProvider<List<UserRank>>((ref) => []);