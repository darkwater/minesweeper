import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameFieldSizeProvider = StateProvider((ref) => [15, 20]);
final minesCountProvider = StateProvider((ref) => 50);
