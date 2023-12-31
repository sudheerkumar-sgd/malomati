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

class ItemNotifications extends StatelessWidget {
  final FinanceApprovalEntity data;
  final Function(String, BuildContext) callBack;
  ItemNotifications({required this.data, required this.callBack, super.key});
  final ValueNotifier _isExpanded = ValueNotifier<bool>(false);
  final _servicesBloc = sl<ServicesBloc>();
  final ValueNotifier<HrapprovalDetailsEntity> _notificationDetails =
      ValueNotifier(HrapprovalDetailsEntity());

  _submitHrApproval(BuildContext context, String id, String action,
      {String? comments}) {
    final requestParams = {
      "ACTION_TYPE": action,
      "NOTIFICATION_ID": id,
      "TO_USER": "",
      "FROM_USER": "",
      "COMMENTS": comments ?? action
    };
    _servicesBloc.submitHrApproval(requestParams: requestParams);
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var resources = context.resources;
    return BlocProvider(
      create: (context) => _servicesBloc,
      child: Container(
        decoration: BackgroundBoxDecoration(
                boxColor: resources.color.viewBgColor,
                radious: resources.dimen.dp15)
            .roundedCornerBox,
        child: BlocListener<ServicesBloc, ServicesState>(
          listener: (context, state) {
            if (state is OnServicesLoading) {
              Dialogs.loader(context);
            } else if (state is OnHrApprovalsDetailsSuccess) {
              _notificationDetails.value = state.hrApprovalDetails;
            } else if (state is OnsubmitHrApprovalSuccess) {
              Navigator.of(context, rootNavigator: true).pop();
              if (state.apiEntity.isSuccess ?? false) {
                callBack(data.nOTIFICATIONID ?? '', context);
              } else {
                Dialogs.showInfoDialog(context, PopupType.fail,
                    state.apiEntity.getDisplayMessage(resources));
              }
            } else if (state is OnServicesError) {
              Navigator.of(context, rootNavigator: true).pop();
              Dialogs.showInfoDialog(context, PopupType.fail, state.message);
            }
          },
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _isExpanded.value = true;
                      },
                      child: Container(
                        padding: EdgeInsets.all(resources.dimen.dp17),
                        decoration: BackgroundBoxDecoration(
                                boxColor: resources.color.colorWhite,
                                radious: resources.dimen.dp15)
                            .roundedCornerBox,
                        child: RichText(
                          text: TextSpan(
                              text: '${data.sUBJECT}\n',
                              style: context.textFontWeight400
                                  .onFontSize(resources.fontSize.dp12)
                                  .copyWith(height: 1.5),
                              children: [
                                TextSpan(
                                  text: '${context.string.submittedOn} : ',
                                  style: context.textFontWeight400
                                      .onFontSize(resources.fontSize.dp12),
                                ),
                                TextSpan(
                                  text: getDateByformat(
                                      'dd/MM/yyyy, hh:mm a',
                                      getDateTimeByString('yyyy-MM-ddThh:mm:ss',
                                          data.bEGINDATE ?? '')),
                                  style: context.textFontWeight400
                                      .onFontFamily(fontFamily: fontFamilyEN)
                                      .onFontSize(resources.fontSize.dp12),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                      valueListenable: _isExpanded,
                      builder: (context, value, child) {
                        return Visibility(
                          visible: value,
                          child: InkWell(
                            onTap: () {
                              callBack('${data.nOTIFICATIONID ?? ''}', context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: ImageWidget(
                                path: DrawableAssets.icTrash,
                                padding: EdgeInsets.all(resources.dimen.dp5),
                              ).loadImage,
                            ),
                          ),
                        );
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
