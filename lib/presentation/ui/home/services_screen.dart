import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/home/favorite_screen.dart';

import '../widgets/services_app_bar.dart';
import '../widgets/user_app_bar.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: Column(
          children: [
            SizedBox(
              height: context.resources.dimen.dp10,
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    vertical: context.resources.dimen.dp20,
                    horizontal: context.resources.dimen.dp25),
                child: ServicesAppBarWidget(title: context.string.selfService)),
            const FavoriteScreen(),
          ],
        ),
      ),
    );
  }
}
