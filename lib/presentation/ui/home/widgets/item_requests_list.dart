import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/request_details_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/requests/requests_bloc.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../../core/common/common_utils.dart';
import '../../../../domain/entities/finance_approval_entity.dart';
import '../../services/widgets/dialog_request_answer_more_info.dart';

class ItemRequestsList extends StatelessWidget {
  final ValueNotifier _isExpanded = ValueNotifier<bool>(false);
  final _requestsBloc = sl<RequestsBloc>();

  final FinanceApprovalEntity data;
  final ValueNotifier<RequestDetailsEntity?> _requestDetails =
      ValueNotifier(null);

  ItemRequestsList({required this.data, super.key});

  Color getColorByAction(String action) {
    switch (action.toUpperCase()) {
      case 'APPROVED':
        return const Color(0xff26B757);
      case 'REJECTED':
        return const Color(0xffD32030);
      default:
        return const Color(0xffEB920C);
    }
  }

  String getStatusByAction(RequestDetailsEntity requestDetails) {
    switch (requestDetails.action) {
      case 'APPROVED':
        return requestDetails.action ?? '';
      case 'REJECTED':
        return 'Rejected by ${requestDetails.rejectedBy}';
      case 'QUESTION':
        return 'Return for correction';
      default:
        return 'Pending with ${requestDetails.approversList.join(', ')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    var resources = context.resources;
    return BlocProvider(
      create: (context) => _requestsBloc,
      child: BlocListener<RequestsBloc, RequestsState>(
        listener: (context, state) {
          if (state is OnRequestDetailsSuccess) {
            _requestDetails.value = state.requestlDetails;
          }
        },
        child: ValueListenableBuilder(
            valueListenable: _isExpanded,
            builder: (context, isExpaned, widget) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                margin: EdgeInsets.symmetric(
                    horizontal: context.resources.dimen.dp5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageWidget(
                            path: data.aCTION == 'APPROVED'
                                ? DrawableAssets.icApprovedCircle
                                : data.aCTION == 'REJECTED'
                                    ? DrawableAssets.icRejectCircle
                                    : DrawableAssets.icPendingCircle)
                        .loadImage,
                    SizedBox(
                      width: context.resources.dimen.dp8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              _isExpanded.value = !isExpaned;
                              if (_requestDetails.value == null) {
                                _requestsBloc.getRequestlDetails(
                                    requestParams: {
                                      'NOTIFICATION_ID': data.nOTIFICATIONID,
                                      'ITEM_KEY': data.iTEMKEY
                                    });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: RichText(
                                      text: TextSpan(
                                          text: '${data.sUBJECT ?? ''}\n',
                                          style: context.textFontWeight400
                                              .onColor(context
                                                  .resources.color.textColor)
                                              .onFontSize(context
                                                  .resources.fontSize.dp12)
                                              .onFontFamily(
                                                  fontFamily: isLocalEn
                                                      ? fontFamilyEN
                                                      : fontFamilyAR)
                                              .copyWith(height: 1),
                                          children: [
                                        TextSpan(
                                          text: context.string.submittedOn,
                                          style: context.textFontWeight400
                                              .onColor(context
                                                  .resources.color.textColor)
                                              .onFontSize(context
                                                  .resources.fontSize.dp12)
                                              .onFontFamily(
                                                  fontFamily: isLocalEn
                                                      ? fontFamilyEN
                                                      : fontFamilyAR)
                                              .copyWith(height: 1.5),
                                        ),
                                        TextSpan(
                                          text: getDateByformat(
                                              ': dd/MM/yyyy, hh:mm a',
                                              getDateTimeByString(
                                                  'yyyy-MM-ddThh:mm:ss',
                                                  data.cREATIONDATE ?? '')),
                                          style: context.textFontWeight400
                                              .onColor(context
                                                  .resources.color.textColor)
                                              .onFontSize(context
                                                  .resources.fontSize.dp12)
                                              .onFontFamily(
                                                  fontFamily: fontFamilyEN),
                                        )
                                      ])),
                                ),
                                ImageWidget(
                                        path: isExpaned
                                            ? DrawableAssets.icChevronUp
                                            : DrawableAssets.icChevronDown)
                                    .loadImage
                              ],
                            ),
                          ),
                          Visibility(
                            visible: isExpaned,
                            child: ValueListenableBuilder(
                                valueListenable: _requestDetails,
                                builder: (context, details, child) {
                                  return details == null
                                      ? Center(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: resources.dimen.dp20),
                                            height: resources.dimen.dp20,
                                            width: resources.dimen.dp20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: resources.dimen.dp2,
                                            ),
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height:
                                                  context.resources.dimen.dp8,
                                            ),
                                            Text(
                                              context.string.requestDetails,
                                              style: context.textFontWeight600
                                                  .onColor(context.resources
                                                      .color.textColor212B4B)
                                                  .onFontSize(context
                                                      .resources.fontSize.dp12),
                                            ),
                                            SizedBox(
                                              height:
                                                  context.resources.dimen.dp5,
                                            ),
                                            // Text(
                                            //   '${details.days ?? ''} ${int.parse(details.days ?? '0') == 1 ? 'day' : 'days'}, ${details.dateStart ?? ''} to ${details.dateEnd ?? ''}',
                                            //   style: context.textFontWeight600
                                            //       .onColor(context.resources
                                            //           .color.textColor212B4B)
                                            //       .onFontSize(context
                                            //           .resources.fontSize.dp12),
                                            // ),
                                            // SizedBox(
                                            //   height:
                                            //       context.resources.dimen.dp15,
                                            // ),
                                            // Text(
                                            //   context.string.action,
                                            //   style: context.textFontWeight600
                                            //       .onColor(context.resources
                                            //           .color.textColor212B4B)
                                            //       .onFontSize(context
                                            //           .resources.fontSize.dp12),
                                            // ),
                                            Column(
                                              children: List.generate(
                                                details
                                                    .notificationDetails.length,
                                                (index) => index > 1 &&
                                                        (details
                                                                    .notificationDetails[
                                                                        index]
                                                                    .fVALUE ??
                                                                '')
                                                            .isNotEmpty
                                                    ? Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              details
                                                                      .notificationDetails[
                                                                          index]
                                                                      .fNAME ??
                                                                  '',
                                                              style: context
                                                                  .textFontWeight400
                                                                  .onFontSize(
                                                                      resources
                                                                          .fontSize
                                                                          .dp12)
                                                                  .copyWith(
                                                                      height:
                                                                          1.5),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              details
                                                                      .notificationDetails[
                                                                          index]
                                                                      .fVALUE ??
                                                                  '',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                      resources
                                                                          .fontSize
                                                                          .dp12)
                                                                  .copyWith(
                                                                      height:
                                                                          1.2),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox(),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  context.resources.dimen.dp15,
                                            ),
                                            Text(
                                              context.string.action,
                                              style: context.textFontWeight600
                                                  .onFontSize(context
                                                      .resources.fontSize.dp12),
                                            ),
                                            SizedBox(
                                              height:
                                                  context.resources.dimen.dp3,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 7,
                                                  height: 7,
                                                  margin: const EdgeInsets.only(
                                                      top: 4),
                                                  decoration: ShapeDecoration(
                                                      shape:
                                                          const CircleBorder(),
                                                      color: getColorByAction(
                                                          details.action ??
                                                              '')),
                                                ),
                                                SizedBox(
                                                  width: context
                                                      .resources.dimen.dp8,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    getStatusByAction(details),
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontSize(context
                                                            .resources
                                                            .fontSize
                                                            .dp12),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (details.action ==
                                                'QUESTION') ...[
                                              SizedBox(
                                                height: context
                                                    .resources.dimen.dp15,
                                              ),
                                              Text(
                                                '${context.string.question} : ${details.question ?? ''}',
                                                style: context.textFontWeight400
                                                    .onColor(context.resources
                                                        .color.textColor212B4B)
                                                    .onFontSize(context
                                                        .resources
                                                        .fontSize
                                                        .dp11),
                                              ),
                                              SizedBox(
                                                height:
                                                    context.resources.dimen.dp6,
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: context
                                                        .resources.dimen.dp3,
                                                    horizontal: context
                                                        .resources.dimen.dp10),
                                                decoration: BackgroundBoxDecoration(
                                                        boxColor: context
                                                            .resources
                                                            .color
                                                            .viewBgColorLight,
                                                        radious: context
                                                            .resources
                                                            .dimen
                                                            .dp10)
                                                    .roundedCornerBox,
                                                child: InkWell(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            DialogRequestAnswerMoreInfo(
                                                              questionText:
                                                                  'test',
                                                            )).then((value) {
                                                      if (value != null) {
                                                        final requestParams = {
                                                          "ACTION_TYPE":
                                                              'ANSWER_MORE_INFO',
                                                          "NOTIFICATION_ID": data
                                                              .nOTIFICATIONID,
                                                          "TO_USER": "",
                                                          "FROM_USER": "",
                                                          "COMMENTS": value
                                                        };
                                                        _requestsBloc
                                                            .submitHrApproval(
                                                                requestParams:
                                                                    requestParams);
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    context.string.answer,
                                                    style: context
                                                        .textFontWeight400
                                                        .onColor(context
                                                            .resources
                                                            .color
                                                            .colorWhite)
                                                        .onFontSize(context
                                                            .resources
                                                            .fontSize
                                                            .dp10)
                                                        .copyWith(height: 1),
                                                  ),
                                                ),
                                              )
                                            ]
                                          ],
                                        );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
