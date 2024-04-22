import 'package:flutter/widgets.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/domain/entities/delegation_entity.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:malomati/res/resources.dart';

class ItemDelegationList extends StatelessWidget {
  final DelegationItemEntity delegationItem;
  const ItemDelegationList({required this.delegationItem, super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: resources.dimen.dp5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ImageWidget(
                    path: DrawableAssets.icDelegateUser,
                    padding: EdgeInsets.all(resources.dimen.dp5))
                .loadImageWithMoreTapArea,
            ImageWidget(
                    path: DrawableAssets.icDelegateEdit,
                    padding: EdgeInsets.all(resources.dimen.dp5))
                .loadImageWithMoreTapArea,
            ImageWidget(
                    path: DrawableAssets.icDelegateDelete,
                    padding: EdgeInsets.all(resources.dimen.dp5))
                .loadImageWithMoreTapArea,
          ],
        ),
        SizedBox(
          height: resources.dimen.dp5,
        ),
        Text.rich(
          style: context.textFontWeight400.onFontSize(resources.fontSize.dp12),
          TextSpan(text: 'Delegation for : ', children: [
            TextSpan(
                text: delegationItem.tYPEDISPLAY ?? '',
                style: context.textFontWeight700
                    .onFontSize(resources.fontSize.dp12))
          ]),
        ),
        SizedBox(
          height: resources.dimen.dp5,
        ),
        Text.rich(
          style: context.textFontWeight400.onFontSize(resources.fontSize.dp12),
          TextSpan(text: 'Delegated to : ', children: [
            TextSpan(
                text: delegationItem.delegateTO ?? '',
                style: context.textFontWeight700
                    .onFontSize(resources.fontSize.dp12))
          ]),
        ),
        SizedBox(
          height: resources.dimen.dp5,
        ),
        // Text.rich(
        //   style: context.textFontWeight400.onFontSize(resources.fontSize.dp12),
        //   TextSpan(text: 'Dept. Name : ', children: [
        //     TextSpan(
        //         text: delegationItem.tYPEDISPLAY ?? '',
        //         style: context.textFontWeight700
        //             .onFontSize(resources.fontSize.dp12))
        //   ]),
        // ),
        Text.rich(
          style: context.textFontWeight400.onFontSize(resources.fontSize.dp12),
          TextSpan(text: 'From ', children: [
            TextSpan(
                text: getDateByformat(
                    'dd/MM/yyyy',
                    getDateTimeByString(
                        'yyyy-MM-ddThh:mm:ss', delegationItem.bEGINDATE ?? '')),
                style: context.textFontWeight700
                    .onFontSize(resources.fontSize.dp12)),
            TextSpan(
                text: ' to ',
                style: context.textFontWeight400
                    .onFontSize(resources.fontSize.dp12)),
            TextSpan(
                text: getDateByformat(
                    'dd/MM/yyyy',
                    getDateTimeByString(
                        'yyyy-MM-ddThh:mm:ss', delegationItem.eNDDATE ?? '')),
                style: context.textFontWeight700
                    .onFontSize(resources.fontSize.dp12))
          ]),
        ),
      ],
    );
  }
}
