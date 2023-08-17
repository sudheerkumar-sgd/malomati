import 'package:flutter/material.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';
import 'package:malomati/domain/entities/favorite_entity.dart';
import 'package:malomati/presentation/ui/home/widgets/item_dashboard_service.dart';

class ServicesList extends StatelessWidget {
  final List<FavoriteEntity> services;
  final Function(BuildContext, FavoriteEntity)? callback;
  const ServicesList({required this.services, this.callback, super.key});

  @override
  Widget build(BuildContext context) {
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
                if (callback != null) {
                  callback!(context, services[i]);
                }
              },
              child: ItemDashboardService(
                data: FavoriteEntity(
                    name: services[i].name,
                    nameAR: services[i].nameAR,
                    iconPath: services[i].iconPath),
              ),
            );
          },
        ),
      ),
    );
  }
}
