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
import '../../../res/drawables/drawable_assets.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';
import '../widgets/dropdown_widget.dart';

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
  final ValueNotifier<InvoiceListEntity?> _selectedInvoiceEntity =
      ValueNotifier(null);

  onLeavesSelected(LeaveDetailsEntity? value) {
    leave = value?.id ?? '';
  }

  onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      _submitAdvanceSalaryRequest();
    }
  }

  onInvoiceNumberSelect(InvoiceListEntity? invoiceListEntity) {
    _selectedInvoiceEntity.value = invoiceListEntity;
  }

  _submitAdvanceSalaryRequest() {
    final advanceSalaryRequestModel = ApiRequestModel();
    advanceSalaryRequestModel.uSERNAME = userName;
    advanceSalaryRequestModel.lEAVE = leave;
    _servicesBloc.submitServicesRequest(
        apiUrl: advanceSalaryApiUrl,
        requestParams: advanceSalaryRequestModel.toAdvanceSalaryRequest());
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
                noInvoiceText = context.string.noDeleteLeaves;
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
                                '${context.userDB.get(userFullNameUsKey)} has Requested Cancel Invoice',
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
                                      ? Autocomplete<InvoiceListEntity>(
                                          optionsBuilder: (TextEditingValue
                                              textEditingValue) {
                                            if (textEditingValue.text == '') {
                                              return const Iterable<
                                                  InvoiceListEntity>.empty();
                                            }
                                            return invoiceList.where(
                                                (InvoiceListEntity option) {
                                              return option.toString().contains(
                                                  textEditingValue.text
                                                      .toLowerCase());
                                            });
                                          },
                                          onSelected:
                                              (InvoiceListEntity selection) {
                                            _selectedInvoiceEntity.value =
                                                selection;
                                          },
                                        )
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
                                valueListenable: _selectedInvoiceEntity,
                                builder:
                                    (context, selectedInvoiceEntity, child) {
                                  return selectedInvoiceEntity != null
                                      ? Container(
                                          padding: EdgeInsets.all(
                                              resources.dimen.dp20),
                                          decoration: BackgroundBoxDecoration(
                                                  boxColor: resources
                                                      .color.colorWhite,
                                                  radious: resources.dimen.dp10)
                                              .roundedCornerBox,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      resources.dimen.dp10),
                                                  color:
                                                      const Color(0xFFF1F1F1),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        context.string
                                                            .operatingUnit,
                                                        style: context
                                                            .textFontWeight400
                                                            .onFontSize(
                                                                resources
                                                                    .fontSize
                                                                    .dp10),
                                                      ),
                                                      SizedBox(
                                                        height: resources
                                                            .dimen.dp20,
                                                      ),
                                                      Text(
                                                        context
                                                            .string.invoiceDate,
                                                        style: context
                                                            .textFontWeight400
                                                            .onFontSize(
                                                                resources
                                                                    .fontSize
                                                                    .dp10),
                                                      ),
                                                      SizedBox(
                                                        height: resources
                                                            .dimen.dp20,
                                                      ),
                                                      Text(
                                                        context.string
                                                            .creationDate,
                                                        style: context
                                                            .textFontWeight400
                                                            .onFontSize(
                                                                resources
                                                                    .fontSize
                                                                    .dp10),
                                                      ),
                                                      SizedBox(
                                                        height: resources
                                                            .dimen.dp20,
                                                      ),
                                                      Text(
                                                        context
                                                            .string.vendorName,
                                                        style: context
                                                            .textFontWeight400
                                                            .onFontSize(
                                                                resources
                                                                    .fontSize
                                                                    .dp10),
                                                      ),
                                                      SizedBox(
                                                        height: resources
                                                            .dimen.dp20,
                                                      ),
                                                      Text(
                                                        context.string
                                                            .invoiceAmount,
                                                        style: context
                                                            .textFontWeight400
                                                            .onFontSize(
                                                                resources
                                                                    .fontSize
                                                                    .dp10),
                                                      ),
                                                      SizedBox(
                                                        height: resources
                                                            .dimen.dp20,
                                                      ),
                                                      Text(
                                                        context
                                                            .string.invoiceType,
                                                        style: context
                                                            .textFontWeight400
                                                            .onFontSize(
                                                                resources
                                                                    .fontSize
                                                                    .dp10),
                                                      ),
                                                      SizedBox(
                                                        height: resources
                                                            .dimen.dp20,
                                                      ),
                                                      Text(
                                                        context
                                                            .string.description,
                                                        style: context
                                                            .textFontWeight400
                                                            .onFontSize(
                                                                resources
                                                                    .fontSize
                                                                    .dp10),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: resources.dimen.dp20,
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      selectedInvoiceEntity
                                                              .departmentId ??
                                                          '',
                                                      style: context
                                                          .textFontWeight400
                                                          .onFontSize(resources
                                                              .fontSize.dp10),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          resources.dimen.dp20,
                                                    ),
                                                    Text(
                                                      getDateByformat(
                                                          'dd MMM yyyy',
                                                          getDateTimeByString(
                                                              'yyyy-MM-ddThh:mm:ss',
                                                              selectedInvoiceEntity
                                                                      .invoiceDate ??
                                                                  '')),
                                                      style: context
                                                          .textFontWeight400
                                                          .onFontSize(resources
                                                              .fontSize.dp10)
                                                          .onFontFamily(
                                                              fontFamily:
                                                                  fontFamilyEN),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          resources.dimen.dp20,
                                                    ),
                                                    Text(
                                                      getDateByformat(
                                                          'dd MMM yyyy',
                                                          getDateTimeByString(
                                                              'yyyy-MM-ddThh:mm:ss',
                                                              selectedInvoiceEntity
                                                                      .invoiceDate ??
                                                                  '')),
                                                      style: context
                                                          .textFontWeight400
                                                          .onFontSize(resources
                                                              .fontSize.dp10)
                                                          .onFontFamily(
                                                              fontFamily:
                                                                  fontFamilyEN),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          resources.dimen.dp20,
                                                    ),
                                                    Text(
                                                      selectedInvoiceEntity
                                                              .vendorName ??
                                                          '',
                                                      style: context
                                                          .textFontWeight400
                                                          .onFontSize(resources
                                                              .fontSize.dp10),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          resources.dimen.dp20,
                                                    ),
                                                    Text(
                                                      selectedInvoiceEntity
                                                              .invoiceAmount ??
                                                          '',
                                                      style: context
                                                          .textFontWeight400
                                                          .onFontSize(resources
                                                              .fontSize.dp10),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          resources.dimen.dp20,
                                                    ),
                                                    Text(
                                                      selectedInvoiceEntity
                                                              .invoiceType ??
                                                          '',
                                                      style: context
                                                          .textFontWeight400
                                                          .onFontSize(resources
                                                              .fontSize.dp10),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          resources.dimen.dp20,
                                                    ),
                                                    Text(
                                                      selectedInvoiceEntity
                                                              .description ??
                                                          '',
                                                      style: context
                                                          .textFontWeight400
                                                          .onFontSize(resources
                                                              .fontSize.dp10),
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
                  SubmitCancelWidget(callBack: onSubmit),
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
