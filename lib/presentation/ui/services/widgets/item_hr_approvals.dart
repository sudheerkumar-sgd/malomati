import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';
import 'package:malomati/core/extensions/text_style_extension.dart';
import 'package:malomati/domain/entities/hr_approval_entity.dart';
import 'package:malomati/domain/entities/hrapproval_details_entity.dart';
import 'package:malomati/domain/entities/leave_type_entity.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../../core/common/common_utils.dart';
import '../../../../injection_container.dart';
import '../../../bloc/services/services_bloc.dart';
import '../../utils/dialogs.dart';
import '../../widgets/alert_dialog_widget.dart';
import 'item_list_attachment.dart';

const APPROVE = 'APPROVE';
const REJECT = 'REJECT';
const REQUESTMOREINFO = 'REQUEST_MORE_INFO';
const ANSWERMOREINFO = 'ANSWER_MORE_INFO';

class ItemHRApprovals extends StatefulWidget {
  final HrApprovalEntity data;
  final Function(String, BuildContext) callBack;
  ItemHRApprovals({required this.data, required this.callBack, super.key});

  @override
  State<StatefulWidget> createState() => _ItemHRApprovalsState();
}

class _ItemHRApprovalsState extends State<ItemHRApprovals> {
  final ValueNotifier _isExpanded = ValueNotifier<bool>(false);
  final _servicesBloc = sl<ServicesBloc>();
  final ValueNotifier<HrapprovalDetailsEntity> _notificationDetails =
      ValueNotifier(HrapprovalDetailsEntity());
  List<LeaveTypeEntity> leaveTypes = [];
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
    // Navigator.pop(context);
  }

  String _getArabicName(String name) {
    if (isLocalEn) return name;
    String arabicName = name;
    switch (name.toLowerCase()) {
      case 'confirmed':
        {
          arabicName = 'مؤكد';
        }
      case 'planned':
        {
          arabicName = 'مخطط';
        }
      case 'annual leave':
        {
          arabicName = 'الاجازة الدوريه';
        }
      case 'paid leave':
        {
          arabicName = 'اجازه مدفوعه';
        }
      case 'submitted date':
        {
          arabicName = 'تاريخ التقديم';
        }
      case 'absence status':
        {
          arabicName = 'حالة الغياب';
        }
      case 'absence type':
        {
          arabicName = 'نوع الغياب';
        }
      case 'absence category':
        {
          arabicName = 'فئة الغياب';
        }
      case 'date start':
        {
          arabicName = 'تاريخ البدء';
        }
      case 'date end':
        {
          arabicName = 'تاريخ الانتهاء';
        }
      case 'days':
        {
          arabicName = 'الايام';
        }
      case 'start time':
        {
          arabicName = 'وقت البدء';
        }
      case 'end time':
        {
          arabicName = 'وقت الإنتهاء';
        }
      case 'time start':
        {
          arabicName = 'وقت البدء';
        }
      case 'time end':
        {
          arabicName = 'وقت الانتهاء';
        }
      case 'hours':
        {
          arabicName = 'ساعات';
        }
      case 'attachement':
        {
          arabicName = 'المرفقات';
        }
      default:
        {
          final leaveType =
              leaveTypes.where((element) => element.name == name).toList();
          if (leaveType.isNotEmpty) arabicName = leaveType[0].nameAr ?? name;
        }
    }
    return arabicName;
  }

  String _getFontFamily(String name) {
    if (name != _getArabicName(name)) return fontFamilyAR;
    return fontFamilyEN;
  }

  @override
  void initState() {
    _isExpanded.value = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _servicesBloc.close();
    _isExpanded.dispose();
    _notificationDetails.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var resources = context.resources;
    _servicesBloc.getLeaveTypes(requestParams: {});
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
            } else if (state is OnLeaveTypesSuccess) {
              leaveTypes = state.leaveTypeEntity;
            } else if (state is OnHrApprovalsDetailsSuccess) {
              _notificationDetails.value = state.hrApprovalDetails;
            } else if (state is OnsubmitHrApprovalSuccess) {
              Navigator.of(context, rootNavigator: true).pop();
              if (state.apiEntity.isSuccess ?? false) {
                for (int i = 0;
                    i < (state.apiEntity.entity?.aPPROVERSLIST.length ?? 0);
                    i++) {
                  _servicesBloc.sendPushNotifications(
                      requestParams: getFCMMessageData(
                          to: state.apiEntity.entity?.aPPROVERSLIST[i] ?? '',
                          title: 'HR Approval',
                          body: 'HR Approval required your action!',
                          type: fcmTypeHRApprovals,
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
                widget.callBack(widget.data.nOTIFICATIONID ?? '', context);
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
              InkWell(
                onTap: () {
                  _isExpanded.value = !_isExpanded.value;
                  _servicesBloc.getHrApprovalDetails(requestParams: {
                    'NOTIFICATION_ID': widget.data.nOTIFICATIONID
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                            text: '${widget.data.sUBJECTUS}\n',
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
                                text: widget.data.bEGINDATECHAR,
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
                      child: ValueListenableBuilder(
                          valueListenable: _notificationDetails,
                          builder: (context, notificationDetails, child) {
                            return notificationDetails
                                    .notificationDetails.isEmpty
                                ? Container(
                                    margin: EdgeInsets.only(
                                        top: resources.dimen.dp20),
                                    height: resources.dimen.dp20,
                                    width: resources.dimen.dp20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: resources.dimen.dp2,
                                    ),
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: resources.dimen.dp20,
                                        ),
                                        RichText(
                                            text: TextSpan(
                                                text:
                                                    '${notificationDetails.notificationDetails[0].fVALUE ?? ''} - ',
                                                style: context.textFontWeight600
                                                    .onFontSize(resources
                                                        .fontSize.dp13),
                                                children: [
                                              TextSpan(
                                                text: notificationDetails
                                                        .notificationDetails[1]
                                                        .fVALUE ??
                                                    '',
                                                style: context.textFontWeight600
                                                    .onFontSize(
                                                        resources.fontSize.dp13)
                                                    .onFontFamily(
                                                        fontFamily:
                                                            fontFamilyEN),
                                              )
                                            ])),
                                        SizedBox(
                                          height: resources.dimen.dp10,
                                        ),
                                        Column(
                                          children: List.generate(
                                            notificationDetails
                                                .notificationDetails.length,
                                            (index) => index > 1
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          _getArabicName(
                                                              notificationDetails
                                                                      .notificationDetails[
                                                                          index]
                                                                      .fNAME ??
                                                                  ''),
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp13)
                                                              .copyWith(
                                                                  height: 2),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          _getArabicName(
                                                              notificationDetails
                                                                      .notificationDetails[
                                                                          index]
                                                                      .fVALUE ??
                                                                  ''),
                                                          style: context
                                                              .textFontWeight600
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp13)
                                                              .onFontFamily(
                                                                  fontFamily: _getFontFamily(notificationDetails
                                                                          .notificationDetails[
                                                                              index]
                                                                          .fVALUE ??
                                                                      ''))
                                                              .copyWith(
                                                                  height: 2),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(),
                                          ),
                                        ),
                                        SizedBox(
                                          height: resources.dimen.dp20,
                                        ),
                                        Column(
                                          children: List.generate(
                                              notificationDetails
                                                  .attachements.length,
                                              (index) => ItemListAttachment(
                                                  data: notificationDetails
                                                      .attachements[index])),
                                        ),
                                        if (widget.data.nOTIFICATIONTYPE
                                                ?.toLowerCase() !=
                                            'fyi') ...{
                                          SizedBox(
                                            height: resources.dimen.dp10,
                                          ),
                                          // InkWell(
                                          //   onTap: () {
                                          //     _submitHrApproval(
                                          //         context,
                                          //         widget.data.nOTIFICATIONID ??
                                          //             '',
                                          //         APPROVE);
                                          //   },
                                          //   child: Container(
                                          //     width: double.infinity,
                                          //     padding: EdgeInsets.symmetric(
                                          //         horizontal: context
                                          //             .resources.dimen.dp15,
                                          //         vertical: context
                                          //             .resources.dimen.dp5),
                                          //     decoration:
                                          //         BackgroundBoxDecoration(
                                          //                 boxColor: context
                                          //                     .resources
                                          //                     .color
                                          //                     .colorGreen26B757,
                                          //                 radious: context
                                          //                     .resources
                                          //                     .dimen
                                          //                     .dp15)
                                          //             .roundedCornerBox,
                                          //     child: Text(
                                          //       context.string.approve,
                                          //       style: context.textFontWeight400
                                          //           .onFontSize(context
                                          //               .resources
                                          //               .fontSize
                                          //               .dp15)
                                          //           .onColor(context.resources
                                          //               .color.colorWhite)
                                          //           .copyWith(height: 1),
                                          //       textAlign: TextAlign.center,
                                          //     ),
                                          //   ),
                                          // ),
                                          // SizedBox(
                                          //   height: resources.dimen.dp10,
                                          // ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    // _submitHrApproval(
                                                    //     context,
                                                    //     widget.data
                                                    //             .nOTIFICATIONID ??
                                                    //         '',
                                                    //     REJECT);
                                                    _submitHrApproval(
                                                        context,
                                                        widget.data
                                                                .nOTIFICATIONID ??
                                                            '',
                                                        APPROVE);
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: context
                                                                .resources
                                                                .dimen
                                                                .dp15,
                                                            vertical: context
                                                                .resources
                                                                .dimen
                                                                .dp5),
                                                    decoration:
                                                        BackgroundBoxDecoration(
                                                                boxColor: context
                                                                    .resources
                                                                    .color
                                                                    .colorGreen26B757,
                                                                radious: context
                                                                    .resources
                                                                    .dimen
                                                                    .dp15)
                                                            .roundedCornerBox,
                                                    child: Text(
                                                      context.string.approve,
                                                      style: context
                                                          .textFontWeight400
                                                          .onFontSize(context
                                                              .resources
                                                              .fontSize
                                                              .dp15)
                                                          .onColor(context
                                                              .resources
                                                              .color
                                                              .colorWhite)
                                                          .copyWith(height: 1),
                                                      textAlign:
                                                          TextAlign.center,
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
                                                    // showDialog(
                                                    //         context: context,
                                                    //         builder: (context) =>
                                                    //             DialogRequestAnswerMoreInfo())
                                                    //     .then((value) =>
                                                    //         _submitHrApproval(
                                                    //             context,
                                                    //             widget.data
                                                    //                     .nOTIFICATIONID ??
                                                    //                 '',
                                                    //             REQUESTMOREINFO,
                                                    //             comments:
                                                    //                 value));
                                                    _submitHrApproval(
                                                        context,
                                                        widget.data
                                                                .nOTIFICATIONID ??
                                                            '',
                                                        REJECT);
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: context
                                                                .resources
                                                                .dimen
                                                                .dp15,
                                                            vertical: context
                                                                .resources
                                                                .dimen
                                                                .dp5),
                                                    decoration:
                                                        BackgroundBoxDecoration(
                                                                boxColor:
                                                                    const Color(
                                                                        0xFFDD143A),
                                                                radious: context
                                                                    .resources
                                                                    .dimen
                                                                    .dp15)
                                                            .roundedCornerBox,
                                                    child: Text(
                                                      context.string.reject,
                                                      style: context
                                                          .textFontWeight400
                                                          .onFontSize(context
                                                              .resources
                                                              .fontSize
                                                              .dp15)
                                                          .onColor(context
                                                              .resources
                                                              .color
                                                              .colorWhite)
                                                          .copyWith(height: 1),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        },
                                      ],
                                    ),
                                  );
                          }),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
