import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

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
