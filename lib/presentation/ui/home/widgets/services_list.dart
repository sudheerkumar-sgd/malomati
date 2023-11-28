import 'package:flutter/material.dart';
import 'package:malomati/config/constant_config.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/core/enum.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';
import 'package:malomati/domain/entities/favorite_entity.dart';
import 'package:malomati/presentation/ui/home/widgets/item_dashboard_service.dart';

import '../../../../res/drawables/drawable_assets.dart';
import '../../widgets/image_widget.dart';

class ServicesList extends StatelessWidget {
  final List<FavoriteEntity> services;
  final Function(BuildContext, FavoriteEntity)? callback;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier _isScrollable = ValueNotifier(false);
  ServicesList({required this.services, this.callback, super.key});

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      printLog(
          message:
              '${_scrollController.position} ${_scrollController.position.maxScrollExtent}');
      if (_scrollController.offset > 20) {
        _isScrollable.value = false;
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      printLog(
          message:
              '${_scrollController.position} ${_scrollController.position.maxScrollExtent}');
      if (_scrollController.position.maxScrollExtent > 0) {
        _isScrollable.value = true;
      }
    });
    if (!ConstantConfig.cancelInvoiceUsers
        .contains(context.userDB.get(userNameKey, defaultValue: ''))) {
      services.removeWhere((element) => element.id == 21);
    }
    return Expanded(
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
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
                childAspectRatio: context.resources.getUserSelcetedFontSize() ==
                        FontSizeEnum.bigSize
                    ? 1.0
                    : context.resources.getUserSelcetedFontSize() ==
                            FontSizeEnum.smallSize
                        ? 1.2
                        : 1.1,
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
          ValueListenableBuilder(
              valueListenable: _isScrollable,
              builder: (context, value, child) {
                return Visibility(
                  visible: value,
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ImageWidget(
                              width: 40,
                              height: 30,
                              path: DrawableAssets.gifDown)
                          .loadImage),
                );
              }),
        ],
      ),
    );
  }
}
