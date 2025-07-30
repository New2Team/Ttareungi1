import 'package:flutter/material.dart';

class ManuTextButton extends StatelessWidget {
  final String text;
  const ManuTextButton({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
        )
      ),
      onPressed: () {
      //
    }, child: Text(""));
  }
}