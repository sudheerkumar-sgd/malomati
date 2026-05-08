import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/common/log.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/leaves_screen.dart';
import 'package:malomati/presentation/ui/services/widgets/submit_cancel_widget.dart';
import 'package:malomati/presentation/ui/utils/date_time_util.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/alert_dialog_widget.dart';
import 'package:malomati/presentation/ui/widgets/animated_toggle.dart';
import 'package:malomati/presentation/ui/widgets/back_app_bar.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart'
    show DateRangePickerSelectionMode, PickerDateRange;

class RemoteWorkScreen extends StatefulWidget {
  static const String route = '/RemoteWorkScreen';
  const RemoteWorkScreen({super.key});

  @override
  State<RemoteWorkScreen> createState() => _RemoteWorkScreenState();
}

class _RemoteWorkScreenState extends State<RemoteWorkScreen> {
  final _servicesBloc = sl<ServicesBloc>();
  LeaveSubType leaveSubType = LeaveSubType.planned;
  final TextEditingController _startDateController = TextEditingController();
  //final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final dateFormat = 'dd-MMM-yyyy';
  final timeFormat = 'hh:mm a';
  final _formKey = GlobalKey<FormState>();
  bool isLoaderShowing = false;
  String userName = '';
  String empNumber = '';
  String reason = '';
  DateTime? startDate;
  DateTime? endDate;
  bool _isLoaderShowing = false;

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller,
      {DateTime? initialDate,
      DateTime? firstDate,
      DateTime? lastDate,
      DateRangePickerSelectionMode selectionMode =
          DateRangePickerSelectionMode.single}) async {
    if (selectionMode == DateRangePickerSelectionMode.single) {
      selectDate(context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate, callBack: (dateTime) {
        controller.text = getDateByformat(dateFormat, dateTime);
        startDate = dateTime;
        endDate = dateTime;
      });
    } else {
      showDateRangePickerDialog(context,
              selectionMode: selectionMode,
              initialSelectedDate: initialDate,
              initialSelectedRange: PickerDateRange(startDate, endDate))
          .then((value) {
        if (value != null &&
            value is PickerDateRange &&
            value.startDate != null) {
          controller.text =
              '${getDateByformat(dateFormat, value.startDate!)} - ${getDateByformat(dateFormat, value.endDate ?? value.startDate!)}';
          startDate = value.startDate!;
          endDate = value.endDate ?? value.startDate!;
        }
      });
    }
  }

  onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      _submitLeaveRequest();
    }
  }

  _submitLeaveRequest() {
    final requestParams = {
      "seqNumber": "",
      "employeeNumber": empNumber,
      "userName": userName,
      "wfhStartDate": getDateByformat('yyyy-MM-dd', startDate!),
      "wfhEndDate": getDateByformat('yyyy-MM-dd', endDate!),
      "reason": reason,
      "processFlag": "Y",
      "errorMsg": "",
      "creationDate": getDateByformat('yyyy-MM-dd', DateTime.now()),
      "comments": _commentController.text
    };
    _servicesBloc.submitServicesRequest(
        apiUrl: workFromHomeApiUrl, requestParams: requestParams);
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
  Widget build(BuildContext context) {
    userName = context.userDB.get(userNameKey);
    empNumber = context.userDB.get(userJobIdEnKey);
    final resources = context.resources;
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                _showLoader(context);
              } else if (state is OnServicesRequestSubmitSuccess) {
                _hideLoader(context);
                if (state.servicesRequestSuccessResponse.isSuccess ?? false) {
                  Dialogs.showInfoDialog(
                          context,
                          PopupType.success,
                          state.servicesRequestSuccessResponse
                              .getDisplayMessage(resources))
                      .then((value) {
                    if (context.mounted) Navigator.pop(context);
                  });
                } else {
                  Dialogs.showInfoDialog(
                      context,
                      PopupType.fail,
                      state.servicesRequestSuccessResponse
                          .getDisplayMessage(resources));
                }
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
                  BackAppBarWidget(title: LeaveType.workFromHome.toString()),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.string.type,
                        style: context.textFontWeight400
                            .onFontSize(context.resources.fontSize.dp12)
                            .copyWith(height: 1),
                      ),
                      SizedBox(
                        width: 190,
                        child: AnimatedToggle(
                          width: 190,
                          height: 28,
                          values: [
                            context.string.planned,
                            context.string.confirmed
                          ],
                          selectedPossition:
                              leaveSubType == LeaveSubType.confirmed ? 1 : 0,
                          onToggleCallback: (value) {
                            if (value == 0) {
                              leaveSubType = LeaveSubType.planned;
                            } else {
                              leaveSubType = LeaveSubType.confirmed;
                            }
                            printLog(message: leaveSubType.name);
                          },
                          buttonColor: resources.color.viewBgColor,
                          backgroundColor:
                              resources.color.bottomSheetIconUnSelected,
                          boxRadious: resources.dimen.dp5,
                          textColor: const Color(0xFFFFFFFF),
                          textFontSize: resources.fontSize.dp13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropDownWidget<String>(
                              list: isLocalEn
                                  ? [
                                      'Internet Issue',
                                      'Personal',
                                      'Work Reason',
                                      'Others'
                                    ]
                                  : ['الإنترنت', 'شخصي', 'سبب عمل', 'آخر'],
                              height: resources.dimen.dp27,
                              labelText: context.string.absenceType,
                              hintText: context.string.chooseAbsenceType,
                              suffixIconPath: DrawableAssets.icChevronDown,
                              errorMessage: context.string.chooseAbsenceType,
                              callback: (value) {
                                reason = value ?? '';
                              },
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            InkWell(
                              onTap: () {
                                _selectDate(context, _startDateController,
                                    initialDate:
                                        _startDateController.text.isNotEmpty
                                            ? getDateTimeByString(dateFormat,
                                                _startDateController.text)
                                            : DateTime.now(),
                                    selectionMode:
                                        DateRangePickerSelectionMode.range);
                              },
                              child: RightIconTextWidget(
                                textDirection: TextDirection.ltr,
                                textAlign:
                                    isLocalEn ? TextAlign.start : TextAlign.end,
                                height: resources.dimen.dp27,
                                labelText: context.string.leaveDates,
                                hintText:
                                    '${context.string.startDate} - ${context.string.endDate}',
                                fontFamily: fontFamilyEN,
                                errorMessage: context.string.chooseLeaveDates,
                                suffixIconPath: DrawableAssets.icCalendar,
                                textController: _startDateController,
                              ),
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              height: resources.dimen.dp100,
                              isEnabled: true,
                              maxLines: 8,
                              labelText: context.string.comments,
                              textController: _commentController,
                            ),
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

  @override
  void dispose() {
    _startDateController.dispose();
    _commentController.dispose();
    _servicesBloc.close();
    super.dispose();
  }
}
