import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/domain/entities/delegation_entity.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

class ItemDelegationList extends StatelessWidget {
  final DelegationItemEntity delegationItem;
  final Function(DelegationItemEntity)? callBack;
  const ItemDelegationList(
      {required this.delegationItem, this.callBack, super.key});

  bool _isActive() {
    final startDays = getDays(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        getDateTimeByString(
            'yyyy-MM-ddThh:mm:ss', delegationItem.bEGINDATE ?? ''));
    final endDays = getDays(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
        getDateTimeByString(
            'yyyy-MM-ddThh:mm:ss', delegationItem.eNDDATE ?? ''));
    return startDays <= 0 && endDays > 0;
  }

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
                    backgroundTint: _isActive() ? null : Colors.grey,
                    padding: EdgeInsets.all(resources.dimen.dp5))
                .loadImageWithMoreTapArea,
            // InkWell(
            //   onTap: () {
            //     UpdateDelegationScreen.start(context, delegationItem);
            //   },
            //   child: ImageWidget(
            //           path: DrawableAssets.icDelegateEdit,
            //           backgroundTint: _isExpaired() ? Colors.grey : null,
            //           padding: EdgeInsets.all(resources.dimen.dp5))
            //       .loadImageWithMoreTapArea,
            // ),
            InkWell(
              onTap: () {
                callBack?.call(delegationItem);
              },
              child: ImageWidget(
                      path: DrawableAssets.icDelegateDelete,
                      padding: EdgeInsets.all(resources.dimen.dp5))
                  .loadImageWithMoreTapArea,
            ),
          ],
        ),
        SizedBox(
          height: resources.dimen.dp5,
        ),
        Text.rich(
          style: context.textFontWeight400.onFontSize(resources.fontSize.dp12),
          TextSpan(text: '${context.string.delegateFor} : ', children: [
            TextSpan(
                text: delegationItem.mESSAGETYPE == '*'
                    ? 'ALL'
                    : delegationItem.tYPEDISPLAY ?? '',
                style: context.textFontWeight700
                    .onFontSize(resources.fontSize.dp12)
                    .onFontFamily(fontFamily: fontFamilyEN))
          ]),
        ),
        SizedBox(
          height: resources.dimen.dp5,
        ),
        Text.rich(
          style: context.textFontWeight400.onFontSize(resources.fontSize.dp12),
          TextSpan(text: '${context.string.delegateTo} : ', children: [
            TextSpan(
                text: delegationItem.delegateTO ?? '',
                style: context.textFontWeight700
                    .onFontSize(resources.fontSize.dp12)
                    .onFontFamily(fontFamily: fontFamilyEN))
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
          TextSpan(text: '${context.string.from} ', children: [
            TextSpan(
                text: getDateByformat(
                    'dd/MM/yyyy',
                    getDateTimeByString(
                        'yyyy-MM-ddThh:mm:ss', delegationItem.bEGINDATE ?? '')),
                style: context.textFontWeight700
                    .onFontSize(resources.fontSize.dp12)
                    .onFontFamily(fontFamily: fontFamilyEN)),
            TextSpan(
                text: ' ${context.string.to} ',
                style: context.textFontWeight400
                    .onFontSize(resources.fontSize.dp12)),
            TextSpan(
                text: getDateByformat(
                    'dd/MM/yyyy',
                    getDateTimeByString(
                            'yyyy-MM-ddThh:mm:ss', delegationItem.eNDDATE ?? '')
                        .add(const Duration(days: -1))),
                style: context.textFontWeight700
                    .onFontSize(resources.fontSize.dp12)
                    .onFontFamily(fontFamily: fontFamilyEN))
          ]),
        ),
      ],
    );
  }
}
