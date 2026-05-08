import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/bloc/attendance/attendance_bloc.dart';
import 'package:malomati/presentation/bloc/requests/requests_bloc.dart';
import 'package:malomati/presentation/ui/home/widgets/item_attendance_list.dart';
import 'package:malomati/presentation/ui/home/widgets/item_requests_list.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/alert_dialog_widget.dart';
import '../../../core/common/common_utils.dart';
import '../../../domain/entities/finance_approval_entity.dart';
import '../../../injection_container.dart';
import '../../../res/drawables/background_box_decoration.dart';
import '../../../res/drawables/drawable_assets.dart';
import '../utils/date_time_util.dart';
import '../widgets/right_icon_text_widget.dart';
import '../widgets/services_app_bar.dart';

enum SelectedListType {
  attendance,
  requests,
}

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  final _attendanceBloc = sl<AttendanceBloc>();
  final _requestsBloc = sl<RequestsBloc>();
  final ValueNotifier<SelectedListType> _selectedListType =
      ValueNotifier<SelectedListType>(SelectedListType.attendance);
  final ValueNotifier<List<FinanceApprovalEntity>> _requestsList =
      ValueNotifier<List<FinanceApprovalEntity>>([]);
  final ScrollController controller = ScrollController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  DateTime _endDateTime = DateTime.now();
  final dateFormat = 'yyyy-MM-dd';
  String userName = '';
  final ValueNotifier<bool> _isRequestsLoading = ValueNotifier<bool>(false);
  bool _didInit = false;
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller,
      {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
    selectDate(context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate, callBack: (dateTime) {
      if (controller == _endDateController) {
        _endDateTime = dateTime.add(const Duration(days: 1));
      }
      controller.text = getDateByformat(dateFormat, dateTime);
    });
  }

  getRequests() {
    _isRequestsLoading.value = true;
    _requestsList.value = [FinanceApprovalEntity()];
    _requestsBloc.getRequestsList(requestParams: {
      'USER_NAME': userName,
      'START_DATE': _startDateController.text,
      'END_DATE': DateFormat(dateFormat).format(_endDateTime),
    });
  }

  void _onStartDateChanged() {
    _endDateController.text = '';
  }

  void _onEndDateChanged() {
    if (_endDateController.text.isNotEmpty) {
      getRequests();
    }
  }

  void _loadAttendanceHistory() {
    final date = DateTime.now();
    final dateCurrent = DateFormat('ddMMyyyy').format(date);
    final dateStart =
        DateFormat('ddMMyyyy').format(DateTime(date.year, date.month, 1));
    final attendanceRequestParams = {
      'date-range': '$dateStart-$dateCurrent',
    };
    _attendanceBloc.getAttendance(requestParams: attendanceRequestParams);
    _attendanceBloc.getAttendanceDetails(
        dateRange: '${dateStart}000000-${dateCurrent}235959');
  }

  @override
  void initState() {
    super.initState();
    _startDateController.addListener(_onStartDateChanged);
    _endDateController.addListener(_onEndDateChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    final date = DateTime.now();
    _startDateController.text =
        DateFormat(dateFormat).format(DateTime(date.year, date.month, 1));
    _endDateController.text = DateFormat(dateFormat).format(date);
    _endDateTime = date.add(const Duration(days: 1));
    _loadAttendanceHistory();
    getRequests();
  }

  @override
  void dispose() {
    _startDateController.removeListener(_onStartDateChanged);
    _endDateController.removeListener(_onEndDateChanged);
    _selectedListType.dispose();
    _requestsList.dispose();
    _isRequestsLoading.dispose();
    controller.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _attendanceBloc.close();
    _requestsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<RequestsBloc>(
          create: (context) => _requestsBloc,
          child: BlocListener<RequestsBloc, RequestsState>(
            listener: (context, state) {
              _isRequestsLoading.value = false;
              if (state is OnRequestListSuccess) {
                _requestsList.value = state.requestsList;
              } else if (state is OnRequestsApiError) {
                Dialogs.showInfoDialog(context, PopupType.fail, state.message);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.resources.dimen.dp10,
                ),
                Container(
                    margin: EdgeInsets.symmetric(
                        vertical: context.resources.dimen.dp20,
                        horizontal: context.resources.dimen.dp25),
                    child:
                        ServicesAppBarWidget(title: context.string.requests)),
                // Row(
                //   children: [
                //     Expanded(
                //       child: ItemDashboardLeaves(
                //         balanceCount: '${ConstantConfig.requestsApprovalCount}',
                //         balancetype: context.string.approved,
                //         padding: context.resources.dimen.dp20,
                //       ),
                //     ),
                //     Expanded(
                //       child: ItemDashboardLeaves(
                //         balanceCount: '${ConstantConfig.requestsPendingCount}',
                //         balancetype: context.string.pending,
                //         padding: context.resources.dimen.dp20,
                //       ),
                //     ),
                //     Expanded(
                //       child: ItemDashboardLeaves(
                //         balanceCount: '${ConstantConfig.requestsRejectCount}',
                //         balancetype: context.string.rejected,
                //         padding: context.resources.dimen.dp20,
                //       ),
                //     ),
                //   ],
                // ),
                Container(
                  margin: EdgeInsets.only(
                    left: context.resources.dimen.dp25,
                    right: context.resources.dimen.dp25,
                    bottom: context.resources.dimen.dp12,
                  ),
                  child: Text(
                    context.string.historyLogs,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: context.textFontWeight600
                        .onColor(context.resources.color.textColor)
                        .onFontSize(context.resources.fontSize.dp17),
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: _selectedListType,
                    builder: (context, listType, widget) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: context.resources.dimen.dp25),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: double.infinity,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        _selectedListType.value =
                                            SelectedListType.attendance;
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                context.resources.dimen.dp8,
                                            horizontal:
                                                context.resources.dimen.dp10),
                                        decoration: BackgroundBoxDecoration(
                                          boxColor: listType ==
                                                  SelectedListType.attendance
                                              ? context.resources.color
                                                  .viewBgColorLight
                                              : context
                                                  .resources.color.colorF5C3C3,
                                          radious: context.resources.dimen.dp25,
                                        ).roundedCornerBox,
                                        child: Text(
                                          context.string.attendance,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textFontWeight600
                                              .onColor(context
                                                  .resources.color.colorWhite)
                                              .onFontSize(context
                                                  .resources.fontSize.dp17),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: context.resources.dimen.dp20,
                                ),
                                Expanded(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: double.infinity,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        _selectedListType.value =
                                            SelectedListType.requests;
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                context.resources.dimen.dp8,
                                            horizontal:
                                                context.resources.dimen.dp10),
                                        decoration: BackgroundBoxDecoration(
                                          boxColor: listType ==
                                                  SelectedListType.requests
                                              ? context.resources.color
                                                  .viewBgColorLight
                                              : context
                                                  .resources.color.colorF5C3C3,
                                          radious: context.resources.dimen.dp25,
                                        ).roundedCornerBox,
                                        child: Text(
                                          context.string.requests,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: context.textFontWeight600
                                              .onColor(context
                                                  .resources.color.colorWhite)
                                              .onFontSize(context
                                                  .resources.fontSize.dp17),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: context.resources.dimen.dp10,
                            ),
                          ],
                        ),
                      );
                    }),
                ValueListenableBuilder(
                    valueListenable: _selectedListType,
                    builder: (context, value, widget) {
                      return Expanded(
                        child: Container(
                          margin: context.resources.isLocalEn
                              ? EdgeInsets.only(
                                  right: context.resources.dimen.dp20)
                              : EdgeInsets.only(
                                  left: context.resources.dimen.dp20),
                          child: Scrollbar(
                            controller: controller,
                            thumbVisibility: true,
                            trackVisibility: true,
                            child: (_selectedListType.value ==
                                    SelectedListType.attendance)
                                ? StreamBuilder(
                                    stream: _attendanceBloc.getAttendanceReport,
                                    builder: (context, snapshot) {
                                      return snapshot.data?.isEmpty ?? true
                                          ? const Center(
                                              child: SizedBox(
                                                  width: 40,
                                                  height: 40,
                                                  child:
                                                      CircularProgressIndicator()),
                                            )
                                          : ListView.separated(
                                              controller: controller,
                                              itemCount:
                                                  snapshot.data?.length ?? 0,
                                              itemBuilder: (context, index) {
                                                return ItemAttendanceList(
                                                  attendanceEntity:
                                                      snapshot.data![index],
                                                );
                                              },
                                              separatorBuilder: (context,
                                                      index) =>
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: context
                                                                .resources
                                                                .dimen
                                                                .dp25),
                                                    color: context.resources
                                                        .color.colorD6D6D6,
                                                    height: 0.5,
                                                  ));
                                    })
                                : ValueListenableBuilder(
                                    valueListenable: _requestsList,
                                    builder: (context, list, child) {
                                      return ListView.separated(
                                          controller: controller,
                                          itemCount: list.length + 1,
                                          itemBuilder: (context, index) {
                                            return index == 0
                                                ? Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        width: context.resources
                                                            .dimen.dp20,
                                                      ),
                                                      Expanded(
                                                        child: InkWell(
                                                          onTap: () {
                                                            _selectDate(context,
                                                                _startDateController,
                                                                initialDate: _startDateController
                                                                        .text
                                                                        .isNotEmpty
                                                                    ? getDateTimeByString(
                                                                        dateFormat,
                                                                        _startDateController
                                                                            .text)
                                                                    : DateTime
                                                                        .now());
                                                          },
                                                          child:
                                                              RightIconTextWidget(
                                                            height: context
                                                                .resources
                                                                .dimen
                                                                .dp27,
                                                            labelText: context
                                                                .string
                                                                .startDate,
                                                            hintText: context
                                                                .string
                                                                .chooseStartDate,
                                                            fontFamily:
                                                                fontFamilyEN,
                                                            errorMessage: context
                                                                .string
                                                                .chooseStartDate,
                                                            suffixIconPath:
                                                                DrawableAssets
                                                                    .icCalendar,
                                                            textController:
                                                                _startDateController,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: context.resources
                                                            .dimen.dp20,
                                                      ),
                                                      Expanded(
                                                        child: InkWell(
                                                          onTap: () {
                                                            _selectDate(context,
                                                                _endDateController,
                                                                initialDate: getDateTimeByString(
                                                                    dateFormat,
                                                                    _endDateController
                                                                            .text
                                                                            .isEmpty
                                                                        ? _startDateController
                                                                            .text
                                                                        : _endDateController
                                                                            .text),
                                                                firstDate: getDateTimeByString(
                                                                    dateFormat,
                                                                    _startDateController
                                                                        .text));
                                                          },
                                                          child:
                                                              RightIconTextWidget(
                                                            height: context
                                                                .resources
                                                                .dimen
                                                                .dp27,
                                                            labelText: context
                                                                .string.endDate,
                                                            hintText: context
                                                                .string
                                                                .chooseEndDate,
                                                            fontFamily:
                                                                fontFamilyEN,
                                                            errorMessage: context
                                                                .string
                                                                .chooseEndDate,
                                                            suffixIconPath:
                                                                DrawableAssets
                                                                    .icCalendar,
                                                            textController:
                                                                _endDateController,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: context.resources
                                                            .dimen.dp10,
                                                      ),
                                                    ],
                                                  )
                                                : ValueListenableBuilder<bool>(
                                                    valueListenable:
                                                        _isRequestsLoading,
                                                    builder:
                                                        (context, isLoading, _) {
                                                      return isLoading
                                                          ? Center(
                                                              child: Container(
                                                                margin: EdgeInsets.only(
                                                                    top: context
                                                                        .resources
                                                                        .dimen
                                                                        .dp20),
                                                                height: context
                                                                    .resources
                                                                    .dimen
                                                                    .dp20,
                                                                width: context
                                                                    .resources
                                                                    .dimen
                                                                    .dp20,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  strokeWidth: context
                                                                      .resources
                                                                      .dimen
                                                                      .dp2,
                                                                ),
                                                              ),
                                                            )
                                                          : ItemRequestsList(
                                                              data:
                                                                  list[index - 1],
                                                              onDataChange:
                                                                  (value) {
                                                                if (value ==
                                                                    true) {
                                                                  getRequests();
                                                                }
                                                              },
                                                            );
                                                    },
                                                  );
                                          },
                                          separatorBuilder: (context, index) =>
                                              index > 0
                                                  ? Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  context
                                                                      .resources
                                                                      .dimen
                                                                      .dp25),
                                                      color: context.resources
                                                          .color.colorD6D6D6,
                                                      height: 0.5,
                                                    )
                                                  : const SizedBox());
                                    }),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
