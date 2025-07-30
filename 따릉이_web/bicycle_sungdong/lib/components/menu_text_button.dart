import 'package:bicycle_sungdong/view/post_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManuTextButton extends StatelessWidget {
  final String text;
  const ManuTextButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        textStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        Get.to(()=>GesigleBoardPage());
      },
      child: Text(text,
      style: TextStyle(
        color: Colors.black
      ),
      ), // ← 여기!
    );
  }
}
