import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

////////////////////////////////////////////////////////////////////////////////

final xProvider = StateProvider.autoDispose<int>((ref) => math.Random().nextInt(101));
final yProvider = StateProvider.autoDispose<int>((ref) => math.Random().nextInt(101));

////////////////////////////////////////////////////////////////////////////////

final lhProvider = StateProvider.autoDispose((ref) => "");
final resultProvider = StateProvider.autoDispose((ref) => "");

////////////////////////////////////////////////////////////////////////////////

final gameIndexProvider = StateProvider.autoDispose<int>((ref) => 0);
final scoreProvider = StateProvider.autoDispose<int>((ref) => 0);

////////////////////////////////////////////////////////////////////////////////

