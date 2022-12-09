import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'cell.dart';
import 'settings.dart';

final gameFieldProvider = Provider((ref) {
  final size = ref.watch(gameFieldSizeProvider);
  final mines = ref.watch(minesCountProvider);

  if (mines > size[0] * size[1]) {
    throw Exception("Too many mines");
  }

  final field = List.generate(size[1], (i) => List.generate(size[0], (j) => 0));

  var minesLeft = mines;
  while (minesLeft > 0) {
    final i = Random().nextInt(size[1]);
    final j = Random().nextInt(size[0]);
    if (field[i][j] == 0) {
      field[i][j] = -1;
      minesLeft--;
    }
  }

  for (var i = 0; i < size[1]; i++) {
    for (var j = 0; j < size[0]; j++) {
      if (field[i][j] == -1) {
        continue;
      }
      var minesAround = 0;
      for (var di = -1; di <= 1; di++) {
        for (var dj = -1; dj <= 1; dj++) {
          if (di == 0 && dj == 0) {
            continue;
          }
          if (i + di < 0 || i + di >= size[1]) {
            continue;
          }
          if (j + dj < 0 || j + dj >= size[0]) {
            continue;
          }
          if (field[i + di][j + dj] == -1) {
            minesAround++;
          }
        }
      }
      field[i][j] = minesAround;
    }
  }

  return field;
});

final fieldExposureProvider = StateProvider(
  (ref) {
    final size = ref.watch(gameFieldSizeProvider);

    return List.generate(size[1], (i) => List.generate(size[0], (j) => false));
  },
);

final fieldFlagProvider = StateProvider(
  (ref) {
    final size = ref.watch(gameFieldSizeProvider);

    return List.generate(size[1], (i) => List.generate(size[0], (j) => false));
  },
);

final visibleFieldProvider = Provider<List<List<int?>>>((ref) {
  final field = ref.watch(gameFieldProvider);
  final exposure = ref.watch(fieldExposureProvider);
  final flags = ref.watch(fieldFlagProvider);

  return List.generate(
    field.length,
    (i) => List.generate(
      field[0].length,
      (j) {
        if (exposure[i][j]) return field[i][j];
        if (flags[i][j]) return Cell.flag;
        return null;
      },
    ),
  );
});

class GameField extends ConsumerWidget {
  const GameField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameField = ref.watch(visibleFieldProvider);

    return SizedBox(
      width: gameField[0].length * Cell.cellSize,
      height: gameField.length * Cell.cellSize,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var y = 0; y < gameField.length; y++)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var x = 0; x < gameField[0].length; x++)
                  Cell(
                    value: gameField[y][x],
                    x: x,
                    y: y,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
