import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nibuichi/databases/databases.dart';

final scoreProvider = StateProvider((ref) => UserScore(highScore: 0));