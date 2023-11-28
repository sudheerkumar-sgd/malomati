// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/submit_cancel_widget.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/resources.dart';
import '../../../core/common/common_utils.dart';
import '../../../data/model/api_request_model.dart';
import '../../../domain/entities/invoice_list_entity.dart';
import '../../../domain/entities/leave_details_entity.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';
import '../widgets/right_icon_text_widget.dart';

class CancelInvoiceScreen extends StatelessWidget {
  static const String route = '/CancelInvoiceScreen';
  CancelInvoiceScreen({super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  final ValueNotifier<List<InvoiceListEntity>> _invoiceList =
      ValueNotifier<List<InvoiceListEntity>>([]);
  String? leave;
  bool isLoading = false;
  InvoiceListEntity? _selectedInvoiceEntity;
  final ValueNotifier<String?> _selectedInvoiceID = ValueNotifier(null);

  onLeavesSelected(LeaveDetailsEntity? value) {
    leave = value?.id ?? '';
  }

  onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      _submitCancelInvoiceRequest();
    }
  }

  onInvoiceNumberSelect(InvoiceListEntity? invoiceListEntity) {
    _selectedInvoiceEntity = invoiceListEntity;
    _selectedInvoiceID.value = _selectedInvoiceEntity?.invoiceID;
  }

  _submitCancelInvoiceRequest() {
    final cancelInvoiceRequestModel = ApiRequestModel();
    cancelInvoiceRequestModel.oRGID =
        _selectedInvoiceEntity?.departmentId ?? '';
    cancelInvoiceRequestModel.iNVOICEID =
        _selectedInvoiceEntity?.invoiceID ?? '';
    _servicesBloc.submitServicesRequest(
        apiUrl: cancelInvoiceApiUrl,
        requestParams: cancelInvoiceRequestModel.toCancelInvoiceRequest());
  }

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    String noInvoiceText = '';
    userName = context.userDB.get(userNameKey, defaultValue: '');
    Future.delayed(const Duration(milliseconds: 100), () {
      _servicesBloc.getInvoicesList(requestParams: {
        "DEPARTMENT_ID": context.userDB.get(departmentIdKey, defaultValue: '')
      });
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                isLoading = true;
                Dialogs.loader(context);
              } else if (state is OnInvoicesListSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
                noInvoiceText = context.string.noDeleteInvoices;
                _invoiceList.value = state.invoiceList;
              } else if (state is OnServicesRequestSubmitSuccess) {
                if (isLoading) {
                  Navigator.of(context, rootNavigator: true).pop();
                  isLoading = false;
                }
                if (state.servicesRequestSuccessResponse.isSuccess ?? false) {
                  Dialogs.showInfoDialog(
                          context,
                          PopupType.success,
                          state.servicesRequestSuccessResponse
                              .getDisplayMessage(resources))
                      .then((value) => Navigator.pop(context));
                  for (int i = 0;
                      i <
                          (state.servicesRequestSuccessResponse.entity
                                  ?.aPPROVERSLIST.length ??
                              0);
                      i++) {
                    _servicesBloc.sendPushNotifications(
                        requestParams: getFCMMessageData(
                            to: state.servicesRequestSuccessResponse.entity
                                    ?.aPPROVERSLIST[i] ??
                                '',
                            title: 'Cancel Invoice',
                            body:
                                '${context.userDB.get(userFullNameUsKey)} has Requested to Cancel Invoice',
                            type: '',
                            notificationId: state.servicesRequestSuccessResponse
                                    .entity?.nTFID ??
                                ''));
                  }
                } else {
                  Dialogs.showInfoDialog(
                      context,
                      PopupType.fail,
                      state.servicesRequestSuccessResponse
                          .getDisplayMessage(resources));
                }
              } else if (state is OnServicesError) {
                if (isLoading) {
                  Navigator.of(context, rootNavigator: true).pop();
                  isLoading = false;
                }
                Dialogs.showInfoDialog(context, PopupType.fail, state.message);
              }
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: context.resources.dimen.dp20,
                  horizontal: context.resources.dimen.dp25),
              child: Column(
                children: [
                  SizedBox(
                    height: context.resources.dimen.dp10,
                  ),
                  BackAppBarWidget(title: context.string.cancelInvoice),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder(
                                valueListenable: _invoiceList,
                                builder: (context, invoiceList, child) {
                                  return invoiceList.isNotEmpty
                                      ? LayoutBuilder(
                                          builder: (context, constraints) {
                                          return Autocomplete<
                                              InvoiceListEntity>(
                                            optionsBuilder: (TextEditingValue
                                                textEditingValue) {
                                              if (textEditingValue.text == '') {
                                                return const Iterable<
                                                    InvoiceListEntity>.empty();
                                              }
                                              return invoiceList.where(
                                                  (InvoiceListEntity option) {
                                                return option
                                                    .toString()
                                                    .contains(textEditingValue
                                                        .text
                                                        .toLowerCase());
                                              });
                                            },
                                            fieldViewBuilder: (context,
                                                textEditingController,
                                                focusNode,
                                                onFieldSubmitted) {
                                              return RightIconTextWidget(
                                                isEnabled: true,
                                                height: resources.dimen.dp27,
                                                labelText: context
                                                    .string.invoiceNumber,
                                                hintText: context
                                                    .string.invoiceNumber,
                                                errorMessage: context
                                                    .string.invoiceNumber,
                                                fontFamily: fontFamilyEN,
                                                textController:
                                                    textEditingController,
                                                focusNode: focusNode,
                                              );
                                            },
                                            optionsViewBuilder: (context,
                                                    onSelected, options) =>
                                                Align(
                                              alignment: Alignment.topLeft,
                                              child: Material(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          bottom:
                                                              Radius.circular(
                                                                  4.0)),
                                                ),
                                                child: SizedBox(
                                                  height: 52.0 * options.length,
                                                  width:
                                                      constraints.biggest.width,
                                                  child: ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    itemCount: options.length,
                                                    shrinkWrap: false,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final InvoiceListEntity
                                                          option = options
                                                              .elementAt(index);
                                                      return InkWell(
                                                        onTap: () =>
                                                            onSelected(option),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          child: Text(
                                                            option.invoiceNumber ??
                                                                '',
                                                            style: context
                                                                .textFontWeight400
                                                                .onFontFamily(
                                                                    fontFamily:
                                                                        fontFamilyEN),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onSelected:
                                                (InvoiceListEntity selection) {
                                              _selectedInvoiceEntity =
                                                  selection;
                                              _selectedInvoiceID.value =
                                                  selection.invoiceID;
                                            },
                                          );
                                        })
                                      : Center(
                                          child: Text(
                                            noInvoiceText,
                                            style: context.textFontWeight600,
                                          ),
                                        );
                                }),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            ValueListenableBuilder(
                                valueListenable: _selectedInvoiceID,
                                builder: (context, selectedInvoiceId, child) {
                                  return selectedInvoiceId != null
                                      ? Container(
                                          padding: EdgeInsets.all(
                                              resources.dimen.dp20),
                                          decoration: BackgroundBoxDecoration(
                                                  boxColor: resources
                                                      .color.colorWhite,
                                                  radious: resources.dimen.dp10)
                                              .roundedCornerBox,
                                          child: Column(
                                            children: [
                                              Container(
                                                color: const Color(0xFFF1F1F1),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            resources
                                                                .dimen.dp10),
                                                        color: const Color(
                                                            0xFFF1F1F1),
                                                        child: Text(
                                                          context.string
                                                              .operatingUnit,
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp12),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            resources
                                                                .dimen.dp10),
                                                        color: const Color(
                                                            0xFFFFFFFF),
                                                        child: Text(
                                                          isLocalEn
                                                              ? _selectedInvoiceEntity
                                                                      ?.departmentNameEn ??
                                                                  ''
                                                              : _selectedInvoiceEntity
                                                                      ?.departmentNameAr ??
                                                                  '',
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp12),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: const Color(0xFFF1F1F1),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            resources
                                                                .dimen.dp10),
                                                        color: const Color(
                                                            0xFFF1F1F1),
                                                        child: Text(
                                                          context.string
                                                              .invoiceDate,
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp12),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            resources
                                                                .dimen.dp10),
                                                        color: const Color(
                                                            0xFFFFFFFF),
                                                        child: Text(
                                                          getDateByformat(
                                                              'dd MMM yyyy',
                                                              getDateTimeByString(
                                                                  'yyyy-MM-ddThh:mm:ss',
                                                                  _selectedInvoiceEntity
                                                                          ?.invoiceDate ??
                                                                      '')),
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp12),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: const Color(0xFFF1F1F1),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            resources
                                                                .dimen.dp10),
                                                        color: const Color(
                                                            0xFFF1F1F1),
                                                        child: Text(
                                                          context.string
                                                              .creationDate,
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp12),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            resources
                                                                .dimen.dp10),
                                                        color: const Color(
                                                            0xFFFFFFFF),
                                                        child: Text(
                                                          getDateByformat(
                                                              'dd MMM yyyy',
                                                              getDateTimeByString(
                                                                  'yyyy-MM-ddThh:mm:ss',
                                                                  _selectedInvoiceEntity
                                                                          ?.creationDate ??
                                                                      '')),
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp12),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: const Color(0xFFF1F1F1),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            resources
                                                                .dimen.dp10),
                                                        color: const Color(
                                                            0xFFF1F1F1),
                                                        child: Text(
                                                          context.string
                                                              .vendorName,
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp12),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            resources
                                                                .dimen.dp10),
                                                        color: const Color(
                                                            0xFFFFFFFF),
                                                        child: Text(
                                                          _selectedInvoiceEntity
                                                                  ?.vendorName ??
                                                              '',
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp12)
                                                              .onFontFamily(
                                                                  fontFamily:
                                                                      getFontNameByString(
                                                                          _selectedInvoiceEntity?.vendorName ??
                                                                              '')),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: const Color(0xFFF1F1F1),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            resources
                                                                .dimen.dp10),
                                                        color: const Color(
                                                            0xFFF1F1F1),
                                                        child: Text(
                                                          context.string
                                                              .invoiceAmount,
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp12),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            resources
                                                                .dimen.dp10),
                                                        color: const Color(
                                                            0xFFFFFFFF),
                                                        child: Text(
                                                          _selectedInvoiceEntity
                                                                  ?.invoiceAmount ??
                                                              '',
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp12),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: const Color(0xFFF1F1F1),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            resources
                                                                .dimen.dp10),
                                                        color: const Color(
                                                            0xFFF1F1F1),
                                                        child: Text(
                                                          context.string
                                                              .invoiceType,
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp12),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            resources
                                                                .dimen.dp10),
                                                        color: const Color(
                                                            0xFFFFFFFF),
                                                        child: Text(
                                                          _selectedInvoiceEntity
                                                                  ?.invoiceType ??
                                                              '',
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp12),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                color: const Color(0xFFF1F1F1),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            resources
                                                                .dimen.dp10),
                                                        color: const Color(
                                                            0xFFF1F1F1),
                                                        child: Text(
                                                          context.string
                                                              .description,
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp12),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            resources
                                                                .dimen.dp10),
                                                        color: const Color(
                                                            0xFFFFFFFF),
                                                        child: Text(
                                                          _selectedInvoiceEntity
                                                                  ?.description ??
                                                              '',
                                                          style: context
                                                              .textFontWeight400
                                                              .onFontSize(
                                                                  resources
                                                                      .fontSize
                                                                      .dp12)
                                                              .onFontFamily(
                                                                  fontFamily:
                                                                      getFontNameByString(
                                                                          _selectedInvoiceEntity?.description ??
                                                                              '')),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox();
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  ValueListenableBuilder(
                      valueListenable: _invoiceList,
                      builder: (context, value, child) {
                        return value.isNotEmpty
                            ? SubmitCancelWidget(callBack: onSubmit)
                            : const SizedBox();
                      }),
                  SizedBox(
                    height: resources.dimen.dp10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
