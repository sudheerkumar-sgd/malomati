import 'package:flutter/material.dart';
import 'package:malomati/config/constant_config.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';
import 'package:malomati/domain/entities/favorite_entity.dart';

import '../../../injection_container.dart';
import '../widgets/item_dashboard_service.dart';

class FavoriteScreen extends StatelessWidget {
  final Function(BuildContext, FavoriteEntity)? callback;
  const FavoriteScreen({this.callback, super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: context.resources.dimen.dp25,
      ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sl<ConstantConfig>().services.length,
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        mainAxisSpacing: context.resources.dimen.dp20,
      ),
      itemBuilder: (ctx, i) {
        return InkWell(
          onTap: () {
            Navigator.pop(context);
            if(callback!=null) {
              callback!(context, sl<ConstantConfig>().services[i]);
            }
          },
          child: ItemDashboardService(
            title: (sl<ConstantConfig>().services[i]).name ?? '',
            iconPath: (sl<ConstantConfig>().services[i]).iconPath ?? '',
          ),
        );
      },
    );
  }
}
