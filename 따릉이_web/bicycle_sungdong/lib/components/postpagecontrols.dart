import 'package:flutter/material.dart';

class BoardPageControls extends StatelessWidget {
  final int currentPage, total;
  final VoidCallback onPrev, onNext;

  const BoardPageControls({
    required this.currentPage,
    required this.total,
    required this.onPrev,
    required this.onNext,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(onPressed: onPrev, icon: Icon(Icons.arrow_back)),
        Text("$currentPage / ${(total/8).ceil()}"),
        IconButton(onPressed: onNext, icon: Icon(Icons.arrow_forward)),
      ],
    );
  }
}
