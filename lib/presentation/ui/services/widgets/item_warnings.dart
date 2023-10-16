import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';
import 'package:malomati/core/extensions/text_style_extension.dart';
import 'package:malomati/domain/entities/finance_approval_entity.dart';
import 'package:malomati/domain/entities/hrapproval_details_entity.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../../core/common/common_utils.dart';
import '../../../../injection_container.dart';
import '../../../bloc/services/services_bloc.dart';
import '../../utils/dialogs.dart';
import '../../widgets/alert_dialog_widget.dart';

class ItemWarnings extends StatelessWidget {
  final FinanceApprovalEntity data;
  ItemWarnings({required this.data, super.key});
  final _servicesBloc = sl<ServicesBloc>();
  final ValueNotifier<HrapprovalDetailsEntity> _notificationDetails =
      ValueNotifier(HrapprovalDetailsEntity());

  @override
  Widget build(BuildContext context) {
    var resources = context.resources;
    return BlocProvider(
      create: (context) => _servicesBloc,
      child: Container(
        decoration: BackgroundBoxDecoration(
                boxColor: resources.color.colorWhite,
                radious: resources.dimen.dp15)
            .roundedCornerBox,
        child: BlocListener<ServicesBloc, ServicesState>(
          listener: (context, state) {
            if (state is OnServicesLoading) {
              Dialogs.loader(context);
            } else if (state is OnHrApprovalsDetailsSuccess) {
              _notificationDetails.value = state.hrApprovalDetails;
            } else if (state is OnServicesError) {
              Navigator.of(context, rootNavigator: true).pop();
              Dialogs.showInfoDialog(context, PopupType.fail, state.message);
            }
          },
          child: Column(
            children: [
              // RichText(
              //   text: TextSpan(
              //     text: '${context.string.receivedBy}: ',
              //     style: context.textFontWeight400.onFontFamily(
              //         fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
              //     children: [
              //       TextSpan(
              //         text: isLocalEn
              //             ? data.empNameEN ?? ''
              //             : data.empNameAR ?? '',
              //         style: context.textFontWeight600.onFontFamily(
              //             fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
              //       ),
              //     ],
              //   ),
              //   textAlign: TextAlign.start,
              // ),
              // SizedBox(
              //   height: context.resources.dimen.dp5,
              // ),
              // RichText(
              //   text: TextSpan(
              //     text: '${context.string.deptName}: ',
              //     style: context.textFontWeight400.onFontFamily(
              //         fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
              //     children: [
              //       TextSpan(
              //         text: isLocalEn
              //             ? data.departmentNameEn ?? ''
              //             : data.departmentNameAr ?? '',
              //         style: context.textFontWeight600.onFontFamily(
              //             fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: context.resources.dimen.dp5,
              // ),
              // RichText(
              //   text: TextSpan(
              //       text: '${context.string.reason}: ',
              //       style: context.textFontWeight400.onFontFamily(
              //           fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
              //       children: [
              //         TextSpan(
              //           text: isLocalEn
              //               ? data.reasonEn ?? ''
              //               : data.reasonAr ?? '',
              //           style: context.textFontWeight600.onFontFamily(
              //               fontFamily:
              //                   isLocalEn ? fontFamilyEN : fontFamilyAR),
              //         ),
              //       ]),
              // ),
              // SizedBox(
              //   height: context.resources.dimen.dp5,
              // ),
              // RichText(
              //   text: TextSpan(
              //     text: '${context.string.date}: ',
              //     style: context.textFontWeight400.onFontFamily(
              //         fontFamily: isLocalEn ? fontFamilyEN : fontFamilyAR),
              //     children: [
              //       TextSpan(
              //         text: data.creationDate ?? '',
              //         style: context.textFontWeight600
              //             .onFontFamily(fontFamily: fontFamilyEN),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
