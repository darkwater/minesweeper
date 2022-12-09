import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'field.dart';

class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const GamePage());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _GameFieldViewer(
              child: GameField(),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameFieldViewer extends ConsumerWidget {
  final Widget child;

  const _GameFieldViewer({
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (context, constraints) {
      return InteractiveViewer(
        constrained: false,
        boundaryMargin: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth / 2,
          vertical: constraints.maxHeight / 2,
        ),
        alignPanAxis: false,
        scaleFactor: 100,
        maxScale: 5,
        minScale: 0.1,
        child: child,
      );
    });
  }
}
