import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/constants/constants.dart';
import 'package:malomati/core/extensions/build_context_extension.dart';
import 'package:malomati/core/extensions/text_style_extension.dart';
import 'package:malomati/domain/entities/hr_approval_entity.dart';
import 'package:malomati/presentation/ui/services/widgets/dialog_request_answer_more_info.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';

import '../../../../injection_container.dart';
import '../../../bloc/services/services_bloc.dart';

const APPROVE = 'APPROVE';
const REJECT = 'REJECT';
const REQUESTMOREINFO = 'REQUEST_MORE_INFO';
const ANSWERMOREINFO = 'ANSWER_MORE_INFO';

class ItemHRApprovals extends StatefulWidget {
  final HrApprovalEntity data;
  final Function(String) callBack;
  ItemHRApprovals({required this.data, required this.callBack, super.key});

  @override
  State<StatefulWidget> createState() => _ItemHRApprovalsState();
}

class _ItemHRApprovalsState extends State<ItemHRApprovals> {
  final ValueNotifier _isExpanded = ValueNotifier<bool>(false);
  final _servicesBloc = sl<ServicesBloc>();
  final ValueNotifier<List<HrApprovalEntity>> _notificationDetails =
      ValueNotifier([]);

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
    widget.callBack(widget.data.nOTIFICATIONID ?? '');
    // Navigator.pop(context);
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
            if (state is OnHrApprovalsListSuccess) {
              _notificationDetails.value = state.hrApprovalsList;
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
                                .onFontSize(resources.dimen.dp12)
                                .copyWith(height: 1.5),
                            children: [
                              TextSpan(
                                text: '${context.string.submittedOn} : ',
                                style: context.textFontWeight400
                                    .onFontSize(resources.dimen.dp12),
                              ),
                              TextSpan(
                                text: widget.data.bEGINDATECHAR,
                                style: context.textFontWeight400
                                    .onFontFamily(fontFamily: fontFamilyEN)
                                    .onFontSize(resources.dimen.dp12),
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
                            return notificationDetails.isEmpty
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
                                        Text(
                                          '${notificationDetails[0].fVALUE ?? ''} - ${notificationDetails[1].fVALUE ?? ''}',
                                          style: context.textFontWeight700,
                                        ),
                                        SizedBox(
                                          height: resources.dimen.dp10,
                                        ),
                                        Column(
                                            children: List.generate(
                                          notificationDetails.length,
                                          (index) => index > 1
                                              ? Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        notificationDetails[
                                                                    index]
                                                                .fNAME ??
                                                            '',
                                                        style: context
                                                            .textFontWeight400
                                                            .onFontSize(
                                                                resources
                                                                    .dimen.dp13)
                                                            .copyWith(
                                                                height: 2),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        notificationDetails[
                                                                    index]
                                                                .fVALUE ??
                                                            '',
                                                        style: context
                                                            .textFontWeight600
                                                            .onFontSize(
                                                                resources.dimen
                                                                    .dp13),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : const SizedBox(),
                                        )),
                                        SizedBox(
                                          height: resources.dimen.dp20,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _submitHrApproval(
                                                context,
                                                widget.data.nOTIFICATIONID ??
                                                    '',
                                                APPROVE);
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: context
                                                    .resources.dimen.dp15,
                                                vertical: context
                                                    .resources.dimen.dp5),
                                            decoration: BackgroundBoxDecoration(
                                                    boxColor: context.resources
                                                        .color.colorGreen26B757,
                                                    radious: context
                                                        .resources.dimen.dp15)
                                                .roundedCornerBox,
                                            child: Text(
                                              context.string.approve,
                                              style: context.textFontWeight400
                                                  .onFontSize(context
                                                      .resources.dimen.dp15)
                                                  .onColor(context.resources
                                                      .color.colorWhite)
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
                                                      widget.data
                                                              .nOTIFICATIONID ??
                                                          '',
                                                      REJECT);
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: context
                                                          .resources.dimen.dp15,
                                                      vertical: context
                                                          .resources.dimen.dp5),
                                                  decoration:
                                                      BackgroundBoxDecoration(
                                                              boxColor: context
                                                                  .resources
                                                                  .color
                                                                  .viewBgColor,
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
                                                            .dimen
                                                            .dp15)
                                                        .onColor(context
                                                            .resources
                                                            .color
                                                            .colorWhite)
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
                                                  showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              DialogRequestAnswerMoreInfo())
                                                      .then((value) =>
                                                          _submitHrApproval(
                                                              context,
                                                              widget.data
                                                                      .nOTIFICATIONID ??
                                                                  '',
                                                              REQUESTMOREINFO,
                                                              comments: value));
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: context
                                                          .resources.dimen.dp15,
                                                      vertical: context
                                                          .resources.dimen.dp5),
                                                  decoration:
                                                      BackgroundBoxDecoration(
                                                              boxColor: context
                                                                  .resources
                                                                  .color
                                                                  .colorOrangeEB920C,
                                                              radious: context
                                                                  .resources
                                                                  .dimen
                                                                  .dp15)
                                                          .roundedCornerBox,
                                                  child: Text(
                                                    context.string.returntext,
                                                    style: context
                                                        .textFontWeight400
                                                        .onFontSize(context
                                                            .resources
                                                            .dimen
                                                            .dp15)
                                                        .onColor(context
                                                            .resources
                                                            .color
                                                            .colorWhite)
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
