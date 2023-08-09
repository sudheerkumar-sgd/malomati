import 'package:flutter/material.dart';
import 'package:malomati/config/constant_config.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';
import 'package:malomati/domain/entities/favorite_entity.dart';
import 'package:malomati/presentation/ui/home/widgets/item_dashboard_service.dart';

import '../../../injection_container.dart';

class FavoriteScreen extends StatelessWidget {
  final Function(BuildContext, FavoriteEntity)? callback;
  const FavoriteScreen({this.callback, super.key});

  @override
  Widget build(BuildContext context) {
    final services = sl<ConstantConfig>().services;
    return Expanded(
      child: SingleChildScrollView(
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: context.resources.dimen.dp25,
          ),
          itemCount: services.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.1,
            mainAxisSpacing: context.resources.dimen.dp20,
          ),
          itemBuilder: (ctx, i) {
            return InkWell(
              onTap: () {
                Navigator.pop(context);
                if (callback != null) {
                  callback!(context, services[i]);
                }
              },
              child: ItemDashboardService(
                data: FavoriteEntity(name: services[i].name,nameAR:services[i].nameAR, iconPath: services[i].iconPath),
              ),
            );
          },
        ),
      ),
    );
  }
}
