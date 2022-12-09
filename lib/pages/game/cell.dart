import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'field.dart';

const _valueColors = [
  Colors.black, // (no text)
  Colors.blue,
  Colors.green, // 2
  Colors.red,
  Colors.purple, // 4
  Colors.cyan,
  Colors.orange, // 6
  Colors.amber,
  Colors.yellow,
];

class Cell extends ConsumerWidget {
  final int? value;
  final int x;
  final int y;

  static const double cellSize = 30;

  static const int flag = -2;
  static const int mine = -1;
  static const int empty = 0;

  const Cell({
    Key? key,
    required this.value,
    required this.x,
    required this.y,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Widget child;
    Color color = (x + y) % 2 == 0 ? Colors.red.shade800 : Colors.red.shade900;
    bool clickable = false;
    bool holdable = false;

    if (value == null) {
      child = Container();
      clickable = true;
      holdable = true;
    } else if (value == flag) {
      child = Icon(
        Icons.flag,
        color: Colors.black,
      );
      holdable = true;
    } else if (value == mine) {
      child = Icon(
        Icons.new_releases_outlined,
        color: Colors.black,
      );
      color = Colors.red.shade800;
    } else if (value == 0) {
      child = Container();
      color = color = Colors.blueGrey.shade900;
    } else if (value! < _valueColors.length) {
      child = Text(
        value.toString(),
        style: TextStyle(
          color: _valueColors[value!],
          fontWeight: FontWeight.bold,
        ),
      );
      color = color = Colors.blueGrey.shade900;
    } else {
      throw Exception("Invalid value");
    }

    return SizedBox(
      width: cellSize,
      height: cellSize,
      child: Material(
        color: color,
        child: InkWell(
          splashColor: Colors.black.withOpacity(0.5),
          onTap: clickable
              ? () {
                  final values = ref.read(gameFieldProvider);
                  final width = values[0].length;
                  final height = values.length;

                  ref.read(fieldExposureProvider.notifier).update((state) {
                    final newList = state.toList();

                    void click(x, y) {
                      if (newList[y][x]) return;

                      newList[y][x] = true;

                      if (values[y][x] == empty) {
                        if (x > 0 && y > 0) click(x - 1, y - 1);
                        if (y > 0) click(x, y - 1);
                        if (x < width - 1 && y > 0) click(x + 1, y - 1);
                        if (x > 0) click(x - 1, y);
                        if (x < width - 1) click(x + 1, y);
                        if (x > 0 && y < height - 1) click(x - 1, y + 1);
                        if (y < height - 1) click(x, y + 1);
                        if (x < width - 1 && y < height - 1)
                          click(x + 1, y + 1);
                      }
                    }

                    click(x, y);

                    return newList;
                  });
                }
              : null,
          onLongPress: holdable
              ? () {
                  ref.read(fieldFlagProvider.notifier).update((state) {
                    final newList = state.toList();
                    newList[y][x] = !newList[y][x];
                    return newList;
                  });
                }
              : null,
          child: Center(child: child),
        ),
      ),
    );
  }
}
