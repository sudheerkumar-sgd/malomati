import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/domain/entities/finance_details_item_entity.dart';
import 'package:malomati/presentation/ui/services/finance_approvals_screen.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../../res/drawables/background_box_decoration.dart';

class ViewItemsWidget extends StatelessWidget {
  final List<FinanceDetailsItemEntity> data;
  final FinanceApprovalType type;
  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  ViewItemsWidget({required this.type, required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final pageController = PageController(
      initialPage: _currentPage.value,
    );
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
          vertical: (getScrrenSize(context).height * .18),
          horizontal: resources.dimen.dp20),
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(context.resources.dimen.dp15))),
      child: Container(
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(
            horizontal: resources.dimen.dp20, vertical: resources.dimen.dp10),
        child: Column(
          children: [
            Text(context.string.viewItems, style: context.textFontWeight600),
            SizedBox(
              height: resources.dimen.dp10,
            ),
            ValueListenableBuilder(
                valueListenable: _currentPage,
                builder: (context, value, child) {
                  return Row(
                    children: [
                      InkWell(
                        onTap: () {
                          _currentPage.value = isLocalEn
                              ? (_currentPage.value - 1)
                              : (_currentPage.value + 1);
                          pageController.animateToPage(_currentPage.value,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.linear);
                        },
                        child: Visibility(
                          visible:
                              isLocalEn ? value > 0 : value < data.length - 1,
                          child: Container(
                            width: resources.dimen.dp20,
                            height: resources.dimen.dp20,
                            decoration: ShapeDecoration(
                                shape: const CircleBorder(),
                                color: resources.color.viewBgColor),
                            child: ImageWidget(
                                    path: DrawableAssets.icChevronLeft,
                                    backgroundTint: resources.color.colorWhite,
                                    boxType: BoxFit.none,
                                    isLocalEn: isLocalEn)
                                .loadImage,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Visibility(
                        visible: data.isNotEmpty,
                        child: Text(
                          '${value + 1}/${data.length}',
                          style: context.textFontWeight400
                              .onColor(resources.color.viewBgColor)
                              .onFontFamily(fontFamily: fontFamilyEN),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          _currentPage.value = isLocalEn
                              ? (_currentPage.value + 1)
                              : (_currentPage.value - 1);
                          pageController.animateToPage(_currentPage.value,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.linear);
                        },
                        child: Visibility(
                          visible:
                              isLocalEn ? value < data.length - 1 : value > 0,
                          child: Container(
                            width: resources.dimen.dp20,
                            height: resources.dimen.dp20,
                            decoration: ShapeDecoration(
                                shape: const CircleBorder(),
                                color: resources.color.viewBgColor),
                            child: ImageWidget(
                                    path: DrawableAssets.icChevronRight,
                                    backgroundTint: resources.color.colorWhite,
                                    boxType: BoxFit.none,
                                    isLocalEn: isLocalEn)
                                .loadImage,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
            Expanded(
              child: data.isEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: resources.dimen.dp40),
                      child: Text(
                        context.string.thereAreNoItems,
                        style: context.textFontWeight400
                            .onColor(resources.color.viewBgColor),
                      ),
                    )
                  : PageView(
                      controller: pageController,
                      reverse: isLocalEn ? false : true,
                      children: [
                        for (int i = 0; i < data.length; i++) ...[
                          type == FinanceApprovalType.po
                              ? getPOViewItemWiget(context, data[i])
                              : type == FinanceApprovalType.pr
                                  ? getPRViewItemWiget(context, data[i])
                                  : getINVViewItemWiget(context, data[i])
                        ]
                      ],
                      onPageChanged: (value) {
                        _currentPage.value = value;
                      },
                    ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.resources.dimen.dp40,
                      vertical: context.resources.dimen.dp7),
                  decoration: BackgroundBoxDecoration(
                          boxColor: context.resources.color.viewBgColorLight,
                          radious: context.resources.dimen.dp15)
                      .roundedCornerBox,
                  child: Text(
                    context.string.close,
                    style: context.textFontWeight400
                        .onFontSize(context.resources.fontSize.dp15)
                        .onColor(context.resources.color.colorWhite)
                        .copyWith(height: 1),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: resources.dimen.dp20,
            ),
          ],
        ),
      ),
    );
  }

  Widget getPOViewItemWiget(
      BuildContext context, FinanceDetailsItemEntity item) {
    final resources = context.resources;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: resources.dimen.dp30,
          ),
          Text(
            '${context.string.itemNumber}:',
            style:
                context.textFontWeight400.onFontSize(resources.fontSize.dp13),
          ),
          Text(
            '${item.pOHEADERID ?? ''}',
            style: context.textFontWeight600
                .onFontSize(resources.fontSize.dp13)
                .onFontFamily(fontFamily: fontFamilyEN),
          ),
          if ((item.iTEMDESCRIPTION ?? '').isNotEmpty) ...[
            SizedBox(
              height: resources.dimen.dp30,
            ),
            Text(
              '${context.string.itemDescription}:',
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp13),
            ),
            Text(
              item.iTEMDESCRIPTION ?? '',
              style: context.textFontWeight600
                  .onFontSize(resources.fontSize.dp13)
                  .onFontFamily(
                      fontFamily: isStringArabic(item.iTEMDESCRIPTION ?? '')
                          ? fontFamilyAR
                          : fontFamilyEN),
            ),
          ],
          if ((item.qUANTITY ?? 0) > 0) ...[
            SizedBox(
              height: resources.dimen.dp20,
            ),
            Text(
              '${context.string.quantity}:',
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp13),
            ),
            Text(
              '${item.qUANTITY ?? 0}',
              style: context.textFontWeight600
                  .onFontSize(resources.fontSize.dp13)
                  .onFontFamily(fontFamily: fontFamilyEN),
            ),
          ],
          if ((item.uNITPRICE ?? 0) > 0) ...[
            SizedBox(
              height: resources.dimen.dp30,
            ),
            Text(
              '${context.string.unitPrice}:',
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp13),
            ),
            Text(
              '${item.uNITPRICE ?? 0}',
              style: context.textFontWeight600
                  .onFontSize(resources.fontSize.dp13)
                  .onFontFamily(fontFamily: fontFamilyEN),
            ),
          ],
          if ((item.lINEAMOUNT ?? 0) > 0) ...[
            SizedBox(
              height: resources.dimen.dp30,
            ),
            Text(
              '${context.string.lineAmount}:',
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp13),
            ),
            Text(
              '${item.lINEAMOUNT ?? 0}',
              style: context.textFontWeight600
                  .onFontSize(resources.fontSize.dp13)
                  .onFontFamily(fontFamily: fontFamilyEN),
            ),
          ],
          SizedBox(
            height: resources.dimen.dp20,
          ),
        ],
      ),
    );
  }

  Widget getPRViewItemWiget(
      BuildContext context, FinanceDetailsItemEntity item) {
    final resources = context.resources;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: resources.dimen.dp30,
          ),
          if ((item.iTEMDESCRIPTION ?? '').isNotEmpty) ...[
            Text(
              '${context.string.itemDescription}:',
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp13),
            ),
            Text(
              item.iTEMDESCRIPTION ?? '',
              style:
                  context.textFontWeight600.onFontSize(resources.fontSize.dp13),
            ),
            SizedBox(
              height: resources.dimen.dp20,
            ),
          ],
          if ((item.qUANTITY ?? 0) > 0) ...[
            Text(
              '${context.string.quantity}:',
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp13),
            ),
            Text(
              '${item.qUANTITY ?? 0}',
              style: context.textFontWeight600
                  .onFontSize(resources.fontSize.dp13)
                  .onFontFamily(fontFamily: fontFamilyEN),
            ),
            SizedBox(
              height: resources.dimen.dp30,
            ),
          ],
          if ((item.uNITPRICE ?? 0) > 0) ...[
            Text(
              '${context.string.unitPrice}:',
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp13),
            ),
            Text(
              '${item.uNITPRICE ?? 0}',
              style: context.textFontWeight600
                  .onFontSize(resources.fontSize.dp13)
                  .onFontFamily(fontFamily: fontFamilyEN),
            ),
            SizedBox(
              height: resources.dimen.dp30,
            ),
          ],
          if ((item.uNITPRICE ?? 0) > 0) ...[
            Text(
              '${context.string.amount}:',
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp13),
            ),
            Text(
              '${(item.uNITPRICE ?? 0) * (item.qUANTITY ?? 0)}',
              style: context.textFontWeight600
                  .onFontSize(resources.fontSize.dp13)
                  .onFontFamily(fontFamily: fontFamilyEN),
            ),
            SizedBox(
              height: resources.dimen.dp20,
            ),
          ]
        ],
      ),
    );
  }

  Widget getINVViewItemWiget(
      BuildContext context, FinanceDetailsItemEntity item) {
    final resources = context.resources;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: resources.dimen.dp20,
          ),
          Text(
            '${context.string.invoiceID}:',
            style:
                context.textFontWeight400.onFontSize(resources.fontSize.dp13),
          ),
          Text(
            '${item.iNVOICEID ?? ''}',
            style: context.textFontWeight600
                .onFontSize(resources.fontSize.dp13)
                .onFontFamily(fontFamily: fontFamilyEN),
          ),
          if ((item.dESCRIPTION ?? '').isNotEmpty) ...[
            SizedBox(
              height: resources.dimen.dp20,
            ),
            Text(
              '${context.string.itemDescription}:',
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp13),
            ),
            Text(
              item.dESCRIPTION ?? '',
              style:
                  context.textFontWeight600.onFontSize(resources.fontSize.dp13),
            ),
          ],
          if ((item.pONUMBER ?? '').isNotEmpty) ...[
            SizedBox(
              height: resources.dimen.dp20,
            ),
            Text(
              '${context.string.poNumber}:',
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp13),
            ),
            Text(
              '${item.pONUMBER ?? ''}',
              style: context.textFontWeight600
                  .onFontSize(resources.fontSize.dp13)
                  .onFontFamily(fontFamily: fontFamilyEN),
            ),
          ],
          if ((item.qUANTITY ?? 0) > 0) ...[
            SizedBox(
              height: resources.dimen.dp20,
            ),
            Text(
              '${context.string.quantity}:',
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp13),
            ),
            Text(
              '${item.qUANTITY ?? 0}',
              style: context.textFontWeight600
                  .onFontSize(resources.fontSize.dp13)
                  .onFontFamily(fontFamily: fontFamilyEN),
            ),
          ],
          if ((item.uNITPRICE ?? 0) > 0) ...[
            SizedBox(
              height: resources.dimen.dp30,
            ),
            Text(
              '${context.string.unitPrice}:',
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp13),
            ),
            Text(
              '${item.uNITPRICE ?? '0'}',
              style: context.textFontWeight600
                  .onFontSize(resources.fontSize.dp13)
                  .onFontFamily(fontFamily: fontFamilyEN),
            ),
          ],
          if ((item.aMOUNT ?? 0) > 0) ...[
            SizedBox(
              height: resources.dimen.dp20,
            ),
            Text(
              "${context.string.amount}:",
              style:
                  context.textFontWeight400.onFontSize(resources.fontSize.dp13),
            ),
            Text(
              '${item.aMOUNT ?? 0}',
              style: context.textFontWeight600
                  .onFontSize(resources.fontSize.dp13)
                  .onFontFamily(fontFamily: fontFamilyEN),
            ),
          ],
          SizedBox(
            height: resources.dimen.dp20,
          ),
        ],
      ),
    );
  }
}
