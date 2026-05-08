import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/constants/data_constants.dart';
import 'package:malomati/domain/entities/payslip_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import '../../../core/common/common_utils.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class PayslipsScreen extends StatefulWidget {
  static const String route = '/PayslipsScreen';
  const PayslipsScreen({super.key});

  @override
  State<PayslipsScreen> createState() => _PayslipsScreenState();
}

class _PayslipsScreenState extends State<PayslipsScreen> {
  final _servicesBloc = sl<ServicesBloc>();
  String userName = '';
  final ValueNotifier<PayslipEntity?> _payslipDetails =
      ValueNotifier<PayslipEntity?>(null);
  final ValueNotifier<List<String>> _months = ValueNotifier<List<String>>([]);
  final TextEditingController _commentsController = TextEditingController();
  String? leave;
  String selectedMonth = '';
  String selectedYear = '';
  final playslipFontSize = 8.0;
  final textHeight = 1.5;
  final fontFamily = fontFamilyEN;
  final grayLightColor = const Color(0xFFF1F1F1);
  bool _didInit = false;
  bool _isLoaderShowing = false;
  late final List<String> _years;

  onYearSelected(String? year) {
    selectedYear = year ?? '';
    getMonthsList(year);
  }

  void getMonthsList(String? selectedYear) {
    final year = DateTime.now().year;
    final month = DateTime.now().month;
    final monthsList = '$year' == selectedYear
        ? months.sublist(0, month - 1)
        : List<String>.from(months);
    selectedMonth = '$year' == selectedYear ? monthsList[month - 2] : monthsList[0];
    _months.value = monthsList;
    onMonthSelected(selectedMonth);
  }

  onMonthSelected(String? month) {
    selectedMonth = month ?? '';
    _servicesBloc.getPayslipDetails(requestParams: {
      'User_name': userName,
      'endDate': getDateByformat(
          'yyy-MM-dd',
          DateTime(
              int.parse(selectedYear), months.indexOf(selectedMonth) + 2, 0))
    });
  }

  void _showLoader(BuildContext context) {
    if (_isLoaderShowing) return;
    _isLoaderShowing = true;
    Dialogs.loader(context).then((_) {
      _isLoaderShowing = false;
    });
  }

  void _hideLoader(BuildContext context) {
    if (!_isLoaderShowing) return;
    Navigator.of(context, rootNavigator: true).pop();
    _isLoaderShowing = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    final currentYear = DateTime.now().year;
    selectedYear = '$currentYear';
    _years = ['${currentYear - 2}', '${currentYear - 1}', '$currentYear'];
    getMonthsList(selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    final fullName = context.userDB.get(userFullNameUsKey, defaultValue: '');
    final jobTitle = context.userDB.get(userJobNameEnKey, defaultValue: '');
    final jobId = context.userDB.get(userJobIdEnKey, defaultValue: '');
    final nationality =
        context.userDB.get(userNationalityEnKey, defaultValue: '');
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                _showLoader(context);
              } else if (state is OnPayslipDetailsSuccess) {
                _hideLoader(context);
                _payslipDetails.value = state.payslipEntity;
              } else if (state is OnServicesError) {
                _hideLoader(context);
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
                  BackAppBarWidget(title: context.string.payslip),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropDownWidget<String>(
                          list: _years,
                          labelText: 'Year',
                          selectedValue: selectedYear,
                          callback: onYearSelected,
                          fontFamily: fontFamilyEN,
                        ),
                      ),
                      SizedBox(
                        width: resources.dimen.dp30,
                      ),
                      Expanded(
                        child: ValueListenableBuilder(
                            valueListenable: _months,
                            builder: (context, months, child) {
                              return DropDownWidget<String>(
                                list: months,
                                labelText: 'Month',
                                selectedValue: selectedMonth,
                                callback: onMonthSelected,
                              );
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: resources.dimen.dp30,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(resources.dimen.dp10),
                      decoration: BackgroundBoxDecoration(
                              boxColor: resources.color.colorWhite,
                              radious: resources.dimen.dp10)
                          .roundedCornerBox,
                      child: SingleChildScrollView(
                        child: ValueListenableBuilder(
                            valueListenable: _payslipDetails,
                            builder: (context, payslipDetails, child) {
                              return payslipDetails == null
                                  ? const SizedBox()
                                  : Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Text(
                                                    'Payslip\n${selectedMonth.substring(0, 3)} $selectedYear\n',
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontSize(resources
                                                            .dimen.dp12)
                                                        .onFontFamily(
                                                            fontFamily:
                                                                fontFamily)
                                                        .copyWith(height: 1.5),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: ImageWidget(
                                                        path: DrawableAssets
                                                            .icGovUAQ)
                                                    .loadImage,
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: resources.dimen.dp10,
                                          ),
                                          Text(
                                            'Personal Information',
                                            style: context.textFontWeight600
                                                .onFontFamily(
                                                    fontFamily: fontFamily)
                                                .onFontSize(playslipFontSize),
                                          ),
                                          SizedBox(
                                            height: resources.dimen.dp20,
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          resources.dimen.dp8),
                                                      color: resources
                                                          .color.colorF5C3C3,
                                                      child: RichText(
                                                          text: TextSpan(
                                                              text:
                                                                  'Full Name: $fullName\n',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                      playslipFontSize)
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .copyWith(
                                                                      height:
                                                                          textHeight),
                                                              children: [
                                                            TextSpan(
                                                              text:
                                                                  'Job: $jobTitle\n',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                      playslipFontSize)
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .copyWith(
                                                                      height:
                                                                          textHeight),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  'Employee Number : $jobId\n',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                      playslipFontSize)
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .copyWith(
                                                                      height:
                                                                          textHeight),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  'National Identifier : $nationality\n',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                      playslipFontSize)
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .copyWith(
                                                                      height:
                                                                          textHeight),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  'Nationality : $nationality\n',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                      playslipFontSize)
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .copyWith(
                                                                      height:
                                                                          textHeight),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  'Grade :${payslipDetails.gradeName}',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                      playslipFontSize)
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .copyWith(
                                                                      height:
                                                                          textHeight),
                                                            ),
                                                          ])),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.all(
                                                          resources.dimen.dp8),
                                                      color: grayLightColor,
                                                      child: RichText(
                                                          text: TextSpan(
                                                              text:
                                                                  'Alternate Name :\n',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                      playslipFontSize)
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .copyWith(
                                                                      height:
                                                                          textHeight),
                                                              children: [
                                                            TextSpan(
                                                              text:
                                                                  'Position : ${payslipDetails.employeeCategory}\n',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                      playslipFontSize)
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamilyEN)
                                                                  .copyWith(
                                                                      height:
                                                                          textHeight),
                                                            ),
                                                            TextSpan(
                                                              text: 'Group :\n',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                      playslipFontSize)
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .copyWith(
                                                                      height:
                                                                          textHeight),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  'Organization : ${payslipDetails.deptname}\n',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                      playslipFontSize)
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .copyWith(
                                                                      height:
                                                                          textHeight),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  'Location :\n',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontSize(
                                                                      playslipFontSize)
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .copyWith(
                                                                      height:
                                                                          textHeight),
                                                            ),
                                                          ])),
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                          SizedBox(
                                            height: resources.dimen.dp15,
                                          ),
                                          Text(
                                            'Payroll Information',
                                            style: context.textFontWeight600
                                                .onFontFamily(
                                                    fontFamily: fontFamily)
                                                .onFontSize(playslipFontSize),
                                          ),
                                          SizedBox(
                                            height: resources.dimen.dp5,
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        resources.dimen.dp8),
                                                    color: resources
                                                        .color.colorF5C3C3,
                                                    child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                'Payroll : ${payslipDetails.payrollName}\n',
                                                            style: context
                                                                .textFontWeight600
                                                                .onFontSize(
                                                                    playslipFontSize)
                                                                .onFontFamily(
                                                                    fontFamily:
                                                                        fontFamily)
                                                                .copyWith(
                                                                    height:
                                                                        textHeight),
                                                            children: [
                                                          TextSpan(
                                                            text:
                                                                'Period Start Date : ${payslipDetails.endDate}',
                                                            style: context
                                                                .textFontWeight600
                                                                .onFontSize(
                                                                    playslipFontSize)
                                                                .onFontFamily(
                                                                    fontFamily:
                                                                        fontFamily)
                                                                .copyWith(
                                                                    height:
                                                                        textHeight),
                                                          ),
                                                        ])),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        resources.dimen.dp8),
                                                    color: grayLightColor,
                                                    child: RichText(
                                                        text: TextSpan(
                                                            text:
                                                                'Period End Date :${payslipDetails.endDate}\n',
                                                            style: context
                                                                .textFontWeight600
                                                                .onFontSize(
                                                                    playslipFontSize)
                                                                .onFontFamily(
                                                                    fontFamily:
                                                                        fontFamily)
                                                                .copyWith(
                                                                    height:
                                                                        textHeight),
                                                            children: [
                                                          TextSpan(
                                                            text:
                                                                'Payment Date :',
                                                            style: context
                                                                .textFontWeight600
                                                                .onFontSize(
                                                                    playslipFontSize)
                                                                .onFontFamily(
                                                                    fontFamily:
                                                                        fontFamily)
                                                                .copyWith(
                                                                    height:
                                                                        textHeight),
                                                          ),
                                                        ])),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: resources.dimen.dp15,
                                          ),
                                          Text(
                                            'Summary of Payment',
                                            style: context.textFontWeight600
                                                .onFontFamily(
                                                    fontFamily: fontFamily)
                                                .onFontSize(playslipFontSize),
                                          ),
                                          SizedBox(
                                            height: resources.dimen.dp5,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(
                                                resources.dimen.dp8),
                                            color: resources.color.colorF5C3C3,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Total Earnings',
                                                    textAlign: TextAlign.center,
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontFamily(
                                                            fontFamily:
                                                                fontFamily)
                                                        .onFontSize(
                                                            playslipFontSize)
                                                        .copyWith(
                                                            height: textHeight),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Total Deduction',
                                                    textAlign: TextAlign.center,
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontFamily(
                                                            fontFamily:
                                                                fontFamily)
                                                        .onFontSize(
                                                            playslipFontSize)
                                                        .copyWith(
                                                            height: textHeight),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Net Pay',
                                                    textAlign: TextAlign.center,
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontFamily(
                                                            fontFamily:
                                                                fontFamily)
                                                        .onFontSize(
                                                            playslipFontSize)
                                                        .copyWith(
                                                            height: textHeight),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(
                                                resources.dimen.dp8),
                                            color: grayLightColor,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    '${payslipDetails.totalEarning}',
                                                    textAlign: TextAlign.center,
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontFamily(
                                                            fontFamily:
                                                                fontFamily)
                                                        .onFontSize(
                                                            playslipFontSize)
                                                        .copyWith(
                                                            height: textHeight),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${payslipDetails.totalDeduction}',
                                                    textAlign: TextAlign.center,
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontFamily(
                                                            fontFamily:
                                                                fontFamily)
                                                        .onFontSize(
                                                            playslipFontSize)
                                                        .copyWith(
                                                            height: textHeight),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${payslipDetails.netPay}',
                                                    textAlign: TextAlign.center,
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontFamily(
                                                            fontFamily:
                                                                fontFamily)
                                                        .onFontSize(
                                                            playslipFontSize)
                                                        .copyWith(
                                                            height: textHeight),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: resources.dimen.dp20,
                                          ),
                                          Table(
                                            children: [
                                              TableRow(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'Earnings',
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontFamily(
                                                              fontFamily:
                                                                  fontFamily)
                                                          .onFontSize(
                                                              playslipFontSize +
                                                                  1),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 8.0),
                                                    child: Text(
                                                      'Deductions',
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontFamily(
                                                              fontFamily:
                                                                  fontFamily)
                                                          .onFontSize(
                                                              playslipFontSize +
                                                                  1),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  resources
                                                                      .dimen
                                                                      .dp5),
                                                          color: resources.color
                                                              .colorF5C3C3,
                                                          child: Text(
                                                            'Description',
                                                            style: context
                                                                .textFontWeight600
                                                                .onFontFamily(
                                                                    fontFamily:
                                                                        fontFamily)
                                                                .onFontSize(
                                                                    playslipFontSize),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            resources.dimen.dp2,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      resources
                                                                          .dimen
                                                                          .dp5,
                                                                  horizontal:
                                                                      resources
                                                                          .dimen
                                                                          .dp8),
                                                          color: resources.color
                                                              .colorF5C3C3,
                                                          child: Text(
                                                            'Amount',
                                                            style: context
                                                                .textFontWeight600
                                                                .onFontFamily(
                                                                    fontFamily:
                                                                        fontFamily)
                                                                .onFontSize(
                                                                    playslipFontSize),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            resources.dimen.dp3,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            resources.dimen.dp3,
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  resources
                                                                      .dimen
                                                                      .dp5),
                                                          color: resources.color
                                                              .colorF5C3C3,
                                                          child: Text(
                                                            'Description',
                                                            style: context
                                                                .textFontWeight600
                                                                .onFontFamily(
                                                                    fontFamily:
                                                                        fontFamily)
                                                                .onFontSize(
                                                                    playslipFontSize),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            resources.dimen.dp2,
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      resources
                                                                          .dimen
                                                                          .dp5,
                                                                  horizontal:
                                                                      resources
                                                                          .dimen
                                                                          .dp8),
                                                          color: resources.color
                                                              .colorF5C3C3,
                                                          child: Text(
                                                            'Amount',
                                                            style: context
                                                                .textFontWeight600
                                                                .onFontFamily(
                                                                    fontFamily:
                                                                        fontFamily)
                                                                .onFontSize(
                                                                    playslipFontSize),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  TableCell(
                                                    verticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .fill,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    resources
                                                                        .dimen
                                                                        .dp5),
                                                            color:
                                                                grayLightColor,
                                                            child: Text(
                                                              'Basic Salary',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp2,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        resources
                                                                            .dimen
                                                                            .dp5,
                                                                    horizontal:
                                                                        resources
                                                                            .dimen
                                                                            .dp8),
                                                            color:
                                                                grayLightColor,
                                                            child: Text(
                                                              '${payslipDetails.basicSalary ?? '0'}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp3,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  IntrinsicHeight(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp3,
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    resources
                                                                        .dimen
                                                                        .dp5),
                                                            color:
                                                                grayLightColor,
                                                            child: Text(
                                                              'Unpaid Leave Deduction',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp2,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        resources
                                                                            .dimen
                                                                            .dp5,
                                                                    horizontal:
                                                                        resources
                                                                            .dimen
                                                                            .dp8),
                                                            color:
                                                                grayLightColor,
                                                            child: Text(
                                                              '${payslipDetails.unpaidLeaveDeduction ?? '0'}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    resources
                                                                        .dimen
                                                                        .dp5),
                                                            color: resources
                                                                .color
                                                                .colorLightBg,
                                                            child: Text(
                                                              'Cost of Living Allowance',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp2,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        resources
                                                                            .dimen
                                                                            .dp5,
                                                                    horizontal:
                                                                        resources
                                                                            .dimen
                                                                            .dp8),
                                                            color: resources
                                                                .color
                                                                .colorLightBg,
                                                            child: Text(
                                                              '${payslipDetails.costOfLivingAllowance ?? '0'}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp3,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  TableCell(
                                                    verticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .fill,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp3,
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    resources
                                                                        .dimen
                                                                        .dp5),
                                                            color: resources
                                                                .color
                                                                .colorLightBg,
                                                            child: Text(
                                                              'Employee Pension',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp2,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        resources
                                                                            .dimen
                                                                            .dp5,
                                                                    horizontal:
                                                                        resources
                                                                            .dimen
                                                                            .dp8),
                                                            color: resources
                                                                .color
                                                                .colorLightBg,
                                                            child: Text(
                                                              '${payslipDetails.employeePension}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    resources
                                                                        .dimen
                                                                        .dp5),
                                                            color:
                                                                grayLightColor,
                                                            child: Text(
                                                              'Housing Allowance',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp2,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        resources
                                                                            .dimen
                                                                            .dp5,
                                                                    horizontal:
                                                                        resources
                                                                            .dimen
                                                                            .dp8),
                                                            color:
                                                                grayLightColor,
                                                            child: Text(
                                                              '${payslipDetails.housingAllowance ?? '0'}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp3,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  TableCell(
                                                    verticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .fill,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp3,
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    resources
                                                                        .dimen
                                                                        .dp5),
                                                            color:
                                                                grayLightColor,
                                                            child: Text(
                                                              'Tax',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp2,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        resources
                                                                            .dimen
                                                                            .dp5,
                                                                    horizontal:
                                                                        resources
                                                                            .dimen
                                                                            .dp8),
                                                            color:
                                                                grayLightColor,
                                                            child: Text(
                                                              '0',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    resources
                                                                        .dimen
                                                                        .dp5),
                                                            color: resources
                                                                .color
                                                                .colorLightBg,
                                                            child: Text(
                                                              'Overtime Money',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp2,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        resources
                                                                            .dimen
                                                                            .dp5,
                                                                    horizontal:
                                                                        resources
                                                                            .dimen
                                                                            .dp8),
                                                            color: resources
                                                                .color
                                                                .colorLightBg,
                                                            child: Text(
                                                              '${payslipDetails.overtime ?? '0'}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp3,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  TableCell(
                                                    verticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .fill,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp3,
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    resources
                                                                        .dimen
                                                                        .dp5),
                                                            color: resources
                                                                .color
                                                                .bottomSheetIconUnSelected,
                                                            child: Text(
                                                              'Total',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp2,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        resources
                                                                            .dimen
                                                                            .dp5,
                                                                    horizontal:
                                                                        resources
                                                                            .dimen
                                                                            .dp8),
                                                            color: resources
                                                                .color
                                                                .bottomSheetIconUnSelected,
                                                            child: Text(
                                                              '${payslipDetails.totalDeduction ?? '0'}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    resources
                                                                        .dimen
                                                                        .dp5),
                                                            color:
                                                                grayLightColor,
                                                            child: Text(
                                                              'Supplementary Allowance',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp2,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        resources
                                                                            .dimen
                                                                            .dp5,
                                                                    horizontal:
                                                                        resources
                                                                            .dimen
                                                                            .dp8),
                                                            color:
                                                                grayLightColor,
                                                            child: Text(
                                                              '${payslipDetails.supplementaryAllowance ?? '0'}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp3,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    resources
                                                                        .dimen
                                                                        .dp5),
                                                            color: resources
                                                                .color
                                                                .colorLightBg,
                                                            child: Text(
                                                              'Transportation Allowance',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp2,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        resources
                                                                            .dimen
                                                                            .dp5,
                                                                    horizontal:
                                                                        resources
                                                                            .dimen
                                                                            .dp8),
                                                            color: resources
                                                                .color
                                                                .colorLightBg,
                                                            child: Text(
                                                              '${payslipDetails.transportationAllowance ?? '0'}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp3,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(),
                                                ],
                                              ),
                                              TableRow(
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    resources
                                                                        .dimen
                                                                        .dp5),
                                                            color: resources
                                                                .color
                                                                .bottomSheetIconUnSelected,
                                                            child: Text(
                                                              'Total',
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp2,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        resources
                                                                            .dimen
                                                                            .dp5,
                                                                    horizontal:
                                                                        resources
                                                                            .dimen
                                                                            .dp8),
                                                            color: resources
                                                                .color
                                                                .bottomSheetIconUnSelected,
                                                            child: Text(
                                                              '${payslipDetails.totalEarning ?? '0'}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: context
                                                                  .textFontWeight600
                                                                  .onFontFamily(
                                                                      fontFamily:
                                                                          fontFamily)
                                                                  .onFontSize(
                                                                      playslipFontSize),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: resources
                                                              .dimen.dp3,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: resources.dimen.dp20,
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        resources.dimen.dp5),
                                                    color: resources
                                                        .color.colorF5C3C3,
                                                    child: Text(
                                                      'Method',
                                                      textAlign: TextAlign.left,
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontFamily(
                                                              fontFamily:
                                                                  fontFamily)
                                                          .onFontSize(
                                                              playslipFontSize)
                                                          .copyWith(
                                                              height:
                                                                  textHeight),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: resources.dimen.dp2,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        resources.dimen.dp5),
                                                    color: resources
                                                        .color.colorF5C3C3,
                                                    child: Text(
                                                      'Bank Name',
                                                      textAlign: TextAlign.left,
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontFamily(
                                                              fontFamily:
                                                                  fontFamily)
                                                          .onFontSize(
                                                              playslipFontSize)
                                                          .copyWith(
                                                              height:
                                                                  textHeight),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: resources.dimen.dp2,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        resources.dimen.dp5),
                                                    color: resources
                                                        .color.colorF5C3C3,
                                                    child: Text(
                                                      'Branch Name',
                                                      textAlign: TextAlign.left,
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontFamily(
                                                              fontFamily:
                                                                  fontFamily)
                                                          .onFontSize(
                                                              playslipFontSize)
                                                          .copyWith(
                                                              height:
                                                                  textHeight),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: resources.dimen.dp2,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        resources.dimen.dp5),
                                                    color: resources
                                                        .color.colorF5C3C3,
                                                    child: Text(
                                                      'Account Number',
                                                      textAlign: TextAlign.left,
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontFamily(
                                                              fontFamily:
                                                                  fontFamily)
                                                          .onFontSize(
                                                              playslipFontSize)
                                                          .copyWith(
                                                              height:
                                                                  textHeight),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: resources.dimen.dp2,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        resources.dimen.dp5),
                                                    color: resources
                                                        .color.colorF5C3C3,
                                                    child: Text(
                                                      'Amount',
                                                      textAlign: TextAlign.left,
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontFamily(
                                                              fontFamily:
                                                                  fontFamily)
                                                          .onFontSize(
                                                              playslipFontSize)
                                                          .copyWith(
                                                              height:
                                                                  textHeight),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        resources.dimen.dp5),
                                                    color: grayLightColor,
                                                    child: Text(
                                                      payslipDetails
                                                              .paymentMethod ??
                                                          '',
                                                      textAlign: TextAlign.left,
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontFamily(
                                                              fontFamily:
                                                                  fontFamily)
                                                          .onFontSize(
                                                              playslipFontSize)
                                                          .copyWith(
                                                              height:
                                                                  textHeight),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: resources.dimen.dp2,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        resources.dimen.dp5),
                                                    color: grayLightColor,
                                                    child: Text(
                                                      '',
                                                      textAlign: TextAlign.left,
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontFamily(
                                                              fontFamily:
                                                                  fontFamily)
                                                          .onFontSize(
                                                              playslipFontSize)
                                                          .copyWith(
                                                              height:
                                                                  textHeight),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: resources.dimen.dp2,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        resources.dimen.dp5),
                                                    color: grayLightColor,
                                                    child: Text(
                                                      '',
                                                      textAlign: TextAlign.left,
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontFamily(
                                                              fontFamily:
                                                                  fontFamily)
                                                          .onFontSize(
                                                              playslipFontSize)
                                                          .copyWith(
                                                              height:
                                                                  textHeight),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: resources.dimen.dp2,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        resources.dimen.dp5),
                                                    color: grayLightColor,
                                                    child: Text(
                                                      '',
                                                      textAlign: TextAlign.left,
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontFamily(
                                                              fontFamily:
                                                                  fontFamily)
                                                          .onFontSize(
                                                              playslipFontSize)
                                                          .copyWith(
                                                              height:
                                                                  textHeight),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: resources.dimen.dp2,
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        resources.dimen.dp5),
                                                    color: grayLightColor,
                                                    child: Text(
                                                      '${payslipDetails.netPay ?? ''}',
                                                      textAlign: TextAlign.left,
                                                      style: context
                                                          .textFontWeight600
                                                          .onFontFamily(
                                                              fontFamily:
                                                                  fontFamily)
                                                          .onFontSize(
                                                              playslipFontSize)
                                                          .copyWith(
                                                              height:
                                                                  textHeight),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: resources.dimen.dp5,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      resources.dimen.dp5),
                                                  child: Text(
                                                    '',
                                                    textAlign: TextAlign.left,
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontFamily(
                                                            fontFamily:
                                                                fontFamily)
                                                        .onFontSize(
                                                            playslipFontSize)
                                                        .copyWith(
                                                            height: textHeight),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: resources.dimen.dp2,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      resources.dimen.dp5),
                                                  child: Text(
                                                    '',
                                                    textAlign: TextAlign.left,
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontFamily(
                                                            fontFamily:
                                                                fontFamily)
                                                        .onFontSize(
                                                            playslipFontSize)
                                                        .copyWith(
                                                            height: textHeight),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: resources.dimen.dp2,
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      resources.dimen.dp5),
                                                  child: Text(
                                                    '',
                                                    textAlign: TextAlign.left,
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontFamily(
                                                            fontFamily:
                                                                fontFamily)
                                                        .onFontSize(
                                                            playslipFontSize)
                                                        .copyWith(
                                                            height: textHeight),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: resources.dimen.dp2,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      resources.dimen.dp5),
                                                  color: resources.color
                                                      .bottomSheetIconUnSelected,
                                                  child: Text(
                                                    'Total',
                                                    textAlign: TextAlign.left,
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontFamily(
                                                            fontFamily:
                                                                fontFamily)
                                                        .onFontSize(
                                                            playslipFontSize)
                                                        .copyWith(
                                                            height: textHeight),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: resources.dimen.dp2,
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  padding: EdgeInsets.all(
                                                      resources.dimen.dp5),
                                                  color: resources.color
                                                      .bottomSheetIconUnSelected,
                                                  child: Text(
                                                    '${payslipDetails.netPay ?? ''}',
                                                    textAlign: TextAlign.left,
                                                    style: context
                                                        .textFontWeight600
                                                        .onFontFamily(
                                                            fontFamily:
                                                                fontFamily)
                                                        .onFontSize(
                                                            playslipFontSize)
                                                        .copyWith(
                                                            height: textHeight),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                            }),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _payslipDetails.dispose();
    _months.dispose();
    _commentsController.dispose();
    _servicesBloc.close();
    super.dispose();
  }
}
