import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class TyperAnimatedTextWidget extends StatelessWidget {
  final String text;

  const TyperAnimatedTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
      child: AnimatedTextKit(
        isRepeatingAnimation: false,
        totalRepeatCount: 1,
        animatedTexts: [
          TyperAnimatedText(
            text,
            speed: const Duration(milliseconds: 30),
          ),
        ],
      ),
    );
  }
}
