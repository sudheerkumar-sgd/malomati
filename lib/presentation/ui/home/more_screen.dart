import 'package:flutter/material.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey,
          body: Column(
            children: [Text('Comming soon')],
          )),
    );
  }
}
