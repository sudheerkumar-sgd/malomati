import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';
import 'package:malomati/core/extensions/text_style_extension.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/domain/entities/finance_approval_entity.dart';
import 'package:malomati/domain/entities/hrapproval_details_entity.dart';
import 'package:malomati/presentation/ui/services/widgets/view_attachments_widget.dart';
import 'package:malomati/presentation/ui/services/widgets/view_items_widget.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../../injection_container.dart';
import '../../../bloc/services/services_bloc.dart';
import '../../utils/dialogs.dart';
import '../../widgets/alert_dialog_widget.dart';
import '../finance_approvals_screen.dart';
import 'dialog_request_answer_more_info.dart';

const APPROVE = 'APPROVE';
const REJECT = 'REJECT';
const REQUESTMOREINFO = 'REQUEST_MORE_INFO';
const ANSWERMOREINFO = 'ANSWER_MORE_INFO';

class ItemFinancePRApprovals extends StatefulWidget {
  final FinanceApprovalEntity data;
  final Function(String, BuildContext) callBack;
  const ItemFinancePRApprovals(
      {required this.data, required this.callBack, super.key});

  @override
  State<StatefulWidget> createState() => _ItemFinanceApprovalsState();
}

class _ItemFinanceApprovalsState extends State<ItemFinancePRApprovals> {
  final ValueNotifier _isExpanded = ValueNotifier<bool>(false);
  final _servicesBloc = sl<ServicesBloc>();
  HrapprovalDetailsEntity? financeDetailsItems;
  bool showItems = false;
  String selectedAction = '';

  _submitHrApproval(BuildContext context, String id, String action,
      {String? comments}) {
    selectedAction = action;
    final requestParams = {
      "ACTION_TYPE": action,
      "NOTIFICATION_ID": id,
      "TO_USER": "",
      "FROM_USER": "",
      "COMMENTS": comments ?? action
    };
    _servicesBloc.submitHrApproval(requestParams: requestParams);
  }

  @override
  void dispose() {
    super.dispose();
    _servicesBloc.close();
    _isExpanded.dispose();
  }

  _showItemsOrAttachements(BuildContext context) {
    if (financeDetailsItems == null) {
      _servicesBloc.getFinanceItemDetailsList(
          apiUrl: financePRItemsApiUrl,
          requestParams: {'NOTIFICATION_ID': widget.data.nOTIFICATIONID});
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return showItems
                ? ViewItemsWidget(
                    type: FinanceApprovalType.pr,
                    data: financeDetailsItems?.financeNotificationDetails ?? [],
                  )
                : ViewAttachmentsWidget(
                    data: financeDetailsItems?.attachements ?? []);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    var resources = context.resources;
    final approvalDetails = widget.data;

    return BlocProvider(
      create: (context) => _servicesBloc,
      child: Container(
        padding: EdgeInsets.all(resources.dimen.dp17),
        decoration: BackgroundBoxDecoration(
                boxColor: resources.color.colorWhite,
                radious: resources.dimen.dp15)
            .roundedCornerBox,
        child: BlocListener<ServicesBloc, ServicesState>(
          listener: (context, state) {
            if (state is OnServicesLoading) {
              Dialogs.loader(context);
            } else if (state is OnHrApprovalsDetailsSuccess) {
              Navigator.of(context, rootNavigator: true).pop();
              financeDetailsItems = state.hrApprovalDetails;
              _showItemsOrAttachements(context);
            } else if (state is OnsubmitHrApprovalSuccess) {
              Navigator.of(context, rootNavigator: true).pop();
              if (state.apiEntity.isSuccess ?? false) {
                for (int i = 0;
                    i < (state.apiEntity.entity?.aPPROVERSLIST.length ?? 0);
                    i++) {
                  _servicesBloc.sendPushNotifications(
                      requestParams: getFCMMessageData(
                          to: state.apiEntity.entity?.aPPROVERSLIST[i] ?? '',
                          title: 'Finance Approval',
                          body: 'Finance Approval required your action!',
                          type: fcmTypeFinanceApprovals,
                          notificationId: '${widget.data.nOTIFICATIONID}'));
                }
                if ((state.apiEntity.entity?.cREATORUSERNAME ?? '')
                    .isNotEmpty) {
                  String noticationBody = '';
                  switch (selectedAction) {
                    case REJECT:
                      noticationBody =
                          'Your request Rejected by the ${context.userDB.get(userFullNameUsKey)}';
                    case REQUESTMOREINFO:
                      noticationBody =
                          '${context.userDB.get(userFullNameUsKey)} has requested more info for your request';
                    default:
                      noticationBody =
                          'Your request Approved by the ${context.userDB.get(userFullNameUsKey)}';
                  }
                  _servicesBloc.sendPushNotifications(
                      requestParams: getFCMMessageData(
                          to: state.apiEntity.entity?.cREATORUSERNAME ?? '',
                          title: 'HR Approval',
                          body: noticationBody,
                          type: '',
                          notificationId: '${widget.data.nOTIFICATIONID}'));
                }
                widget.callBack('${widget.data.nOTIFICATIONID ?? ''}', context);
              } else {
                Dialogs.showInfoDialog(context, PopupType.fail,
                    state.apiEntity.getDisplayMessage(resources));
              }
            } else if (state is OnServicesError) {
              Navigator.of(context, rootNavigator: true).pop();
              Dialogs.showInfoDialog(context, PopupType.fail, state.message);
            } else {
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  _isExpanded.value = !_isExpanded.value;
                },
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                            text: '${approvalDetails.sUPPLIERNAME}\n',
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp12)
                                .onFontFamily(
                                    fontFamily: getFontNameByString(
                                        approvalDetails.sUPPLIERNAME ?? ''))
                                .copyWith(height: 1.5),
                            children: [
                              TextSpan(
                                text: '${approvalDetails.sUBJECT}\n',
                                style: context.textFontWeight400
                                    .onFontSize(resources.fontSize.dp12),
                              ),
                              TextSpan(
                                text: '${context.string.submittedOn} : ',
                                style: context.textFontWeight400
                                    .onFontSize(resources.fontSize.dp12),
                              ),
                              TextSpan(
                                text: getDateByformat(
                                    'dd/MM/yyyy, hh:mm a',
                                    getDateTimeByString('yyyy-MM-ddThh:mm:ss',
                                        approvalDetails.sENT ?? '')),
                                style: context.textFontWeight400
                                    .onFontFamily(fontFamily: fontFamilyEN)
                                    .onFontSize(resources.fontSize.dp12),
                              ),
                            ]),
                      ),
                    ),
                    ValueListenableBuilder(
                        valueListenable: _isExpanded,
                        builder: (context, value, child) {
                          return ImageWidget(
                                  path: DrawableAssets.icChevronDown,
                                  backgroundTint: resources.color.viewBgColor,
                                  padding: EdgeInsets.all(resources.dimen.dp5),
                                  isLocalEn: !value)
                              .loadImage;
                        })
                  ],
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: _isExpanded,
                  builder: (context, value, child) {
                    return Visibility(
                      visible: value,
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RichText(
                                text: TextSpan(
                                    text:
                                        '${context.string.purchaseRequisition} ',
                                    style: context.textFontWeight600
                                        .onFontSize(resources.fontSize.dp13),
                                    children: [
                                  TextSpan(
                                    text: '${approvalDetails.pURREQNUM}',
                                    style: context.textFontWeight600
                                        .onFontSize(resources.fontSize.dp13)
                                        .onFontFamily(fontFamily: fontFamilyEN),
                                  )
                                ])),
                            SizedBox(
                              height: resources.dimen.dp10,
                            ),
                            if ((approvalDetails.hDRDESCRIPTION ?? '')
                                .isNotEmpty) ...[
                              Text(
                                context.string.description,
                                style: context.textFontWeight400
                                    .onFontSize(resources.fontSize.dp13),
                              ),
                              Text(
                                approvalDetails.hDRDESCRIPTION ?? '',
                                style: context.textFontWeight600
                                    .onFontSize(resources.fontSize.dp13)
                                    .onFontFamily(
                                        fontFamily: isStringArabic(
                                                approvalDetails
                                                        .hDRDESCRIPTION ??
                                                    '')
                                            ? fontFamilyAR
                                            : fontFamilyEN),
                              ),
                              SizedBox(
                                height: resources.dimen.dp20,
                              ),
                            ],
                            if ((approvalDetails.hDRTOTAL ?? '')
                                .isNotEmpty) ...[
                              Text(
                                context.string.total,
                                style: context.textFontWeight400
                                    .onFontSize(resources.fontSize.dp13)
                                    .copyWith(height: 1.5),
                              ),
                              Text(
                                approvalDetails.hDRTOTAL ?? '',
                                style: context.textFontWeight600
                                    .onFontSize(resources.fontSize.dp13)
                                    .onFontFamily(fontFamily: fontFamilyEN)
                                    .copyWith(height: 1.5),
                              ),
                            ],
                            if ((approvalDetails.tAXNONRECOVERABLE ?? '')
                                .isNotEmpty) ...[
                              Text(
                                '${context.string.tax} (${context.string.nonRecoverable})',
                                style: context.textFontWeight400
                                    .onFontSize(resources.fontSize.dp13)
                                    .copyWith(height: 1.5),
                              ),
                              Text(
                                approvalDetails.tAXNONRECOVERABLE ?? '',
                                style: context.textFontWeight600
                                    .onFontSize(resources.fontSize.dp13)
                                    .onFontFamily(fontFamily: fontFamilyEN)
                                    .copyWith(height: 1.5),
                              ),
                            ],
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      showItems = true;
                                      _showItemsOrAttachements(context);
                                    },
                                    child: Container(
                                      clipBehavior: Clip.none,
                                      decoration: BackgroundBoxDecoration(
                                              boxColor:
                                                  resources.color.colorD6D6D6,
                                              radious: resources.dimen.dp20)
                                          .roundedCornerBox,
                                      margin: EdgeInsets.only(
                                        right:
                                            isLocalEn ? resources.dimen.dp5 : 0,
                                        left:
                                            isLocalEn ? 0 : resources.dimen.dp5,
                                        top: resources.dimen.dp25,
                                      ),
                                      padding:
                                          EdgeInsets.all(resources.dimen.dp5),
                                      child: Text(
                                        context.string.viewItems,
                                        textAlign: TextAlign.center,
                                        style: context.textFontWeight400
                                            .onFontSize(resources.fontSize.dp13)
                                            .copyWith(
                                              height: 1.1,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      showItems = false;
                                      _showItemsOrAttachements(context);
                                    },
                                    child: Container(
                                      clipBehavior: Clip.none,
                                      decoration: BackgroundBoxDecoration(
                                              boxColor:
                                                  resources.color.colorD6D6D6,
                                              radious: resources.dimen.dp20)
                                          .roundedCornerBox,
                                      margin: EdgeInsets.only(
                                        right:
                                            isLocalEn ? 0 : resources.dimen.dp5,
                                        left:
                                            isLocalEn ? resources.dimen.dp5 : 0,
                                        top: resources.dimen.dp25,
                                      ),
                                      padding:
                                          EdgeInsets.all(resources.dimen.dp5),
                                      child: Text(
                                        context.string.viewAttachments,
                                        textAlign: TextAlign.center,
                                        style: context.textFontWeight400
                                            .onFontSize(resources.fontSize.dp13)
                                            .copyWith(
                                              height: 1.1,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            InkWell(
                              onTap: () {
                                _submitHrApproval(
                                    context,
                                    '${approvalDetails.nOTIFICATIONID ?? ''}',
                                    APPROVE);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: context.resources.dimen.dp15,
                                    vertical: context.resources.dimen.dp5),
                                decoration: BackgroundBoxDecoration(
                                        boxColor: context
                                            .resources.color.colorGreen26B757,
                                        radious: context.resources.dimen.dp15)
                                    .roundedCornerBox,
                                child: Text(
                                  context.string.approve,
                                  style: context.textFontWeight400
                                      .onFontSize(
                                          context.resources.fontSize.dp15)
                                      .onColor(
                                          context.resources.color.colorWhite)
                                      .copyWith(height: 1),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: resources.dimen.dp10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      _submitHrApproval(
                                          context,
                                          '${approvalDetails.nOTIFICATIONID ?? ''}',
                                          REJECT);
                                      // _submitHrApproval(
                                      //     context,
                                      //     '${approvalDetails.nOTIFICATIONID ?? ''}',
                                      //     APPROVE);
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              context.resources.dimen.dp15,
                                          vertical:
                                              context.resources.dimen.dp5),
                                      decoration: BackgroundBoxDecoration(
                                              boxColor: const Color(0xFFDD143A),
                                              radious:
                                                  context.resources.dimen.dp15)
                                          .roundedCornerBox,
                                      child: Text(
                                        context.string.reject,
                                        style: context.textFontWeight400
                                            .onFontSize(
                                                context.resources.fontSize.dp15)
                                            .onColor(context
                                                .resources.color.colorWhite)
                                            .copyWith(height: 1),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: resources.dimen.dp10,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      // _submitHrApproval(
                                      //     context,
                                      //     '${approvalDetails.nOTIFICATIONID ?? ''}',
                                      //     REJECT);
                                      showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  DialogRequestAnswerMoreInfo())
                                          .then((value) => _submitHrApproval(
                                              context,
                                              '${approvalDetails.nOTIFICATIONID ?? ''}',
                                              REQUESTMOREINFO,
                                              comments: value));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              context.resources.dimen.dp15,
                                          vertical:
                                              context.resources.dimen.dp5),
                                      decoration: BackgroundBoxDecoration(
                                              boxColor: context.resources.color
                                                  .colorOrangeEB920C,
                                              radious:
                                                  context.resources.dimen.dp15)
                                          .roundedCornerBox,
                                      child: Text(
                                        context.string.returntext,
                                        style: context.textFontWeight400
                                            .onFontSize(
                                                context.resources.fontSize.dp15)
                                            .onColor(context
                                                .resources.color.colorWhite)
                                            .copyWith(height: 1),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
