import 'package:flutter_riverpod/flutter_riverpod.dart';

////////////////////////////////////////////////////////////////////////////////

final isClearProvider = StateProvider.autoDispose((ref) => true);
final gameIndexProvider = StateProvider.autoDispose((ref) => "game-ui");
final scoreProvider = StateProvider.autoDispose<int>((ref) => 0);

////////////////////////////////////////////////////////////////////////////////

