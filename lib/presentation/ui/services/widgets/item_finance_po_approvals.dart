import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';
import 'package:malomati/core/extensions/text_style_extension.dart';
import 'package:malomati/domain/entities/finance_approval_entity.dart';
import 'package:malomati/domain/entities/hrapproval_details_entity.dart';
import 'package:malomati/presentation/ui/services/finance_approvals_screen.dart';
import 'package:malomati/presentation/ui/services/widgets/view_attachments_widget.dart';
import 'package:malomati/presentation/ui/services/widgets/view_items_widget.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../../data/data_sources/api_urls.dart';
import '../../../../injection_container.dart';
import '../../../bloc/services/services_bloc.dart';
import '../../utils/dialogs.dart';
import '../../widgets/alert_dialog_widget.dart';

const APPROVE = 'APPROVE';
const REJECT = 'REJECT';
const REQUESTMOREINFO = 'REQUEST_MORE_INFO';
const ANSWERMOREINFO = 'ANSWER_MORE_INFO';

class ItemFinancePOApprovals extends StatefulWidget {
  final FinanceApprovalEntity data;
  final Function(String, BuildContext) callBack;
  const ItemFinancePOApprovals(
      {required this.data, required this.callBack, super.key});

  @override
  State<StatefulWidget> createState() => _ItemFinanceApprovalsState();
}

class _ItemFinanceApprovalsState extends State<ItemFinancePOApprovals> {
  final ValueNotifier _isExpanded = ValueNotifier<bool>(false);
  final _servicesBloc = sl<ServicesBloc>();
  HrapprovalDetailsEntity? financeDetailsItems;
  bool showItems = false;

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
  }

  _showItemsOrAttachements(BuildContext context) {
    if (financeDetailsItems == null) {
      _servicesBloc.getFinanceItemDetailsList(
          apiUrl: financePOItemsApiUrl,
          requestParams: {'NOTIFICATION_ID': widget.data.nOTIFICATIONID});
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return showItems
                ? ViewItemsWidget(
                    type: FinanceApprovalType.po,
                    data: financeDetailsItems?.financeNotificationDetails ?? [],
                  )
                : ViewAttachmentsWidget(
                    data: financeDetailsItems?.attachements ?? []);
          });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _servicesBloc.close();
    _isExpanded.dispose();
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
                            text:
                                '${approvalDetails.sUPPLIERNAME}\n${approvalDetails.sUBJECT?.trim()}\n',
                            style: context.textFontWeight400
                                .onFontSize(resources.fontSize.dp12)
                                .copyWith(height: 1.5),
                            children: [
                              TextSpan(
                                text: '${context.string.submittedOn} : ',
                                style: context.textFontWeight400
                                    .onFontSize(resources.fontSize.dp12)
                                    .onFontFamily(
                                        fontFamily: isLocalEn
                                            ? fontFamilyEN
                                            : fontFamilyAR),
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
                    SizedBox(
                      width: resources.dimen.dp10,
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
                            // Text(
                            //   'Standard Purchase Order ${approvalDetails.dOCUMENTNUMBER}',
                            //   style: context.textFontWeight600
                            //       .onFontSize(resources.fontSize.dp13),
                            // ),
                            // SizedBox(
                            //   height: resources.dimen.dp10,
                            // ),
                            Table(
                              children: [
                                TableRow(children: [
                                  Text(
                                    context.string.supplier,
                                    style: context.textFontWeight400
                                        .onFontSize(resources.fontSize.dp13)
                                        .copyWith(height: 1.5),
                                  ),
                                  Text(
                                    approvalDetails.sUPPLIERNAME ?? '',
                                    style: context.textFontWeight600
                                        .onFontSize(resources.fontSize.dp13)
                                        .copyWith(height: 1.5),
                                  ),
                                ]),
                                TableRow(children: [
                                  SizedBox(
                                    height: resources.dimen.dp5,
                                  ),
                                  SizedBox(
                                    height: resources.dimen.dp5,
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(
                                    context.string.buyer,
                                    style: context.textFontWeight400
                                        .onFontSize(resources.fontSize.dp13)
                                        .copyWith(height: 1.5),
                                  ),
                                  Text(
                                    approvalDetails.fROMROLE ?? '',
                                    style: context.textFontWeight600
                                        .onFontSize(resources.fontSize.dp13)
                                        .copyWith(height: 1.5),
                                  ),
                                ]),
                                TableRow(children: [
                                  SizedBox(
                                    height: resources.dimen.dp5,
                                  ),
                                  SizedBox(
                                    height: resources.dimen.dp5,
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(
                                    context.string.description,
                                    style: context.textFontWeight400
                                        .onFontSize(resources.fontSize.dp13)
                                        .copyWith(height: 1.5),
                                  ),
                                  Text(
                                    approvalDetails.pODESCRIPTION ?? '',
                                    style: context.textFontWeight600
                                        .onFontSize(resources.fontSize.dp13)
                                        .copyWith(height: 1.5),
                                  ),
                                ]),
                                TableRow(children: [
                                  SizedBox(
                                    height: resources.dimen.dp5,
                                  ),
                                  SizedBox(
                                    height: resources.dimen.dp5,
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(
                                    context.string.amount,
                                    style: context.textFontWeight400
                                        .onFontSize(resources.fontSize.dp13)
                                        .copyWith(height: 1.5),
                                  ),
                                  Text(
                                    approvalDetails.tOTALAMOUNT ?? '',
                                    style: context.textFontWeight600
                                        .onFontSize(resources.fontSize.dp13)
                                        .onFontFamily(fontFamily: fontFamilyEN)
                                        .copyWith(height: 1.5),
                                  ),
                                ]),
                                TableRow(children: [
                                  SizedBox(
                                    height: resources.dimen.dp5,
                                  ),
                                  SizedBox(
                                    height: resources.dimen.dp5,
                                  ),
                                ]),
                                TableRow(children: [
                                  Text(
                                    context.string.tax,
                                    style: context.textFontWeight400
                                        .onFontSize(resources.fontSize.dp13)
                                        .copyWith(height: 1.5),
                                  ),
                                  Text(
                                    approvalDetails.tAXAMOUNT ?? '',
                                    style: context.textFontWeight600
                                        .onFontSize(resources.fontSize.dp13)
                                        .onFontFamily(fontFamily: fontFamilyEN)
                                        .copyWith(height: 1.5),
                                  ),
                                ]),
                                // TableRow(children: [
                                //   Text(
                                //     context.string.paymentTerms,
                                //     style: context.textFontWeight400
                                //         .onFontSize(resources.fontSize.dp13)
                                //         .copyWith(height: 1.5),
                                //   ),
                                //   Text(
                                //     '',
                                //     style: context.textFontWeight600
                                //         .onFontSize(resources.fontSize.dp13)
                                //         .copyWith(height: 1.5),
                                //   ),
                                // ]),
                                TableRow(children: [
                                  InkWell(
                                    onTap: () {
                                      showItems = true;
                                      _showItemsOrAttachements(context);
                                    },
                                    child: Container(
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
                                  InkWell(
                                    onTap: () {
                                      showItems = false;
                                      _showItemsOrAttachements(context);
                                    },
                                    child: Container(
                                      decoration: BackgroundBoxDecoration(
                                              boxColor:
                                                  resources.color.colorD6D6D6,
                                              radious: resources.dimen.dp20)
                                          .roundedCornerBox,
                                      padding:
                                          EdgeInsets.all(resources.dimen.dp5),
                                      margin: EdgeInsets.only(
                                        right:
                                            isLocalEn ? 0 : resources.dimen.dp5,
                                        left:
                                            isLocalEn ? resources.dimen.dp5 : 0,
                                        top: resources.dimen.dp25,
                                      ),
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
                                ]),
                              ],
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     _submitHrApproval(
                            //         context,
                            //         '${approvalDetails.nOTIFICATIONID ?? ''}',
                            //         APPROVE);
                            //   },
                            //   child: Container(
                            //     width: double.infinity,
                            //     padding: EdgeInsets.symmetric(
                            //         horizontal: context.resources.dimen.dp15,
                            //         vertical: context.resources.dimen.dp5),
                            //     decoration: BackgroundBoxDecoration(
                            //             boxColor: context
                            //                 .resources.color.colorGreen26B757,
                            //             radious: context.resources.dimen.dp15)
                            //         .roundedCornerBox,
                            //     child: Text(
                            //       context.string.approve,
                            //       style: context.textFontWeight400
                            //           .onFontSize(
                            //               context.resources.fontSize.dp15)
                            //           .onColor(
                            //               context.resources.color.colorWhite)
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
                                      _submitHrApproval(
                                          context,
                                          '${approvalDetails.nOTIFICATIONID ?? ''}',
                                          APPROVE);
                                      // _submitHrApproval(
                                      //     context,
                                      //     '${approvalDetails.nOTIFICATIONID ?? ''}',
                                      //     REJECT);
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
                                                  .colorGreen26B757,
                                              radious:
                                                  context.resources.dimen.dp15)
                                          .roundedCornerBox,
                                      child: Text(
                                        context.string.approve,
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
                                      // showDialog(
                                      //         context: context,
                                      //         builder: (context) =>
                                      //             DialogRequestAnswerMoreInfo())
                                      //     .then((value) => _submitHrApproval(
                                      //         context,
                                      //         '${approvalDetails.nOTIFICATIONID ?? ''}',
                                      //         REQUESTMOREINFO,
                                      //         comments: value));
                                      _submitHrApproval(
                                          context,
                                          '${approvalDetails.nOTIFICATIONID ?? ''}',
                                          REJECT);
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
