import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/data/data_sources/api_urls.dart';
import 'package:malomati/data/model/api_request_model.dart';
import 'package:malomati/data/model/department_model.dart';
import 'package:malomati/domain/entities/department_entity.dart';
import 'package:malomati/domain/entities/employee_entity.dart';
import 'package:malomati/domain/entities/thankyou_entity.dart';
import 'package:malomati/domain/entities/thankyou_reason_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/item_thankyou_received.dart';
import 'package:malomati/presentation/ui/services/widgets/submit_cancel_widget.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/dropdown_widget.dart';
import 'package:malomati/presentation/ui/widgets/image_widget.dart';
import 'package:malomati/presentation/ui/services/widgets/item_thankyou_month.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/drawables/background_box_decoration.dart';
import 'package:malomati/res/drawables/drawable_assets.dart';
import 'package:malomati/res/resources.dart';
import '../../../core/constants/data_constants.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

enum ThankyouListType {
  create,
  received,
  granted,
}

class ThankyouScreen extends StatefulWidget {
  static const String route = '/ThankyouScreen';
  const ThankyouScreen({super.key});

  @override
  State<ThankyouScreen> createState() => _ThankyouScreenState();
}

class _ThankyouScreenState extends State<ThankyouScreen> {
  late Resources resources;
  final ValueNotifier<ThankyouListType> _selectedListType =
      ValueNotifier<ThankyouListType>(ThankyouListType.create);
  final _servicesBloc = sl<ServicesBloc>();
  List<DepartmentEntity> _departments = [];
  List<ThankyouReasonEntity> _reasons = [];
  final ValueNotifier<List<EmployeeEntity>> _employees =
      ValueNotifier<List<EmployeeEntity>>([]);
  final ValueNotifier<List<ThankyouEntity>> _thankYouList =
      ValueNotifier<List<ThankyouEntity>>([]);
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();
  DepartmentEntity? department;
  EmployeeEntity? employee;
  ThankyouReasonEntity? reason;
  final ValueNotifier<int> selectedMonth = ValueNotifier<int>(0);
  List<Map> monthYearList = [];
  final ScrollController _monthScrollController = ScrollController();
  final ScrollController _listScrollController = ScrollController();
  String userName = '';
  String personId = '';
  bool _didInit = false;
  bool _isLoaderShowing = false;

  onDepartmentSelected(DepartmentEntity? value) {
    employee = null;
    department = value;
    _servicesBloc.getEmployeesByDepartment(
        requestParams: {'DEPARTMENT_NUMBER': department?.pAYROLLID ?? ''});
  }

  onEmployeeSelected(EmployeeEntity? value) {
    employee = value;
  }

  onReasonSelected(ThankyouReasonEntity? value) {
    reason = value;
  }

  onSubmit(String clickedButton) {
    if (_formKey.currentState!.validate()) {
      _submitThankyouRequest();
    }
  }

  _submitThankyouRequest() {
    final thankyouRequestModel = ApiRequestModel();
    thankyouRequestModel.uSERNAME = userName;
    thankyouRequestModel.dEPARTMENTNAME = department?.pAYROLLID ?? '';
    thankyouRequestModel.eMPLOYEE = employee?.pERSONID ?? '';
    thankyouRequestModel.rEASON = reason?.lOOKUP_CODE ?? '';
    thankyouRequestModel.nOTE = _noteController.text;
    _servicesBloc.submitServicesRequest(
        apiUrl: submitThankyouApiUrl,
        requestParams: thankyouRequestModel.toThankyouRequest());
  }

  _getYearMonth() {
    monthYearList.clear();
    int currentMonth = DateTime.now().month;
    int currentYear = DateTime.now().year;
    for (int i = 1; i <= currentMonth; i++) {
      var date = DateTime(currentYear, i);
      monthYearList.add({
        'index': i - 1,
        'year': '$currentYear',
        'month': getDateByformat('MMM', date),
        'start_date': getDateByformat('yyy-MM-dd', DateTime(currentYear, i, 1)),
        'end_date':
            getDateByformat('yyy-MM-dd', DateTime(currentYear, i + 1, 0))
      });
    }
    selectedMonth.value = currentMonth - 1;
  }

  _setScrollByDirection(double offset) {
    _monthScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  _getThankyouList(ThankyouListType type) {
    if (monthYearList.isEmpty) return;
    final requestedParams = {
      'thankyou_type': type,
      'USER_NAME': userName,
      'PERSON_ID': personId,
      'START_DATE': monthYearList[selectedMonth.value]['start_date'],
      'END_DATE': monthYearList[selectedMonth.value]['end_date'],
    };
    _servicesBloc.getThankyouList(requestParams: requestedParams);
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

  void _onSelectedMonthChanged() {
    final type = _selectedListType.value;
    if (type != ThankyouListType.create) {
      _getThankyouList(type);
    }
  }

  void _onSelectedListTypeChanged() {
    if (!mounted) return;
    final type = _selectedListType.value;
    if (type == ThankyouListType.create) return;
    _getThankyouList(type);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_monthScrollController.hasClients) return;
      _setScrollByDirection(_monthScrollController.position.maxScrollExtent + 100);
    });
  }

  @override
  void initState() {
    super.initState();
    selectedMonth.addListener(_onSelectedMonthChanged);
    _selectedListType.addListener(_onSelectedListTypeChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;
    resources = context.resources;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    personId = context.userDB.get(userPersonIdKey, defaultValue: '');
    _departments = departments
        .map((departmentJson) =>
            DepartmentModel.fromJson(departmentJson).toDepartmentEntity())
        .toList();
    _reasons = thankYouReasonList
        .map((thankYouReasonJson) =>
            DepartmentModel.fromJson(thankYouReasonJson)
                .toThankyouReasonEntity())
        .toList();
    _getYearMonth();
  }

  @override
  void dispose() {
    selectedMonth.removeListener(_onSelectedMonthChanged);
    _selectedListType.removeListener(_onSelectedListTypeChanged);
    _selectedListType.dispose();
    _employees.dispose();
    _thankYouList.dispose();
    selectedMonth.dispose();
    _noteController.dispose();
    _monthScrollController.dispose();
    _listScrollController.dispose();
    _servicesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                _showLoader(context);
              } else if (state is OnEmployeesSuccess) {
                _hideLoader(context);
                _employees.value = state.employeesList;
              } else if (state is OnServicesRequestSubmitSuccess) {
                _hideLoader(context);
                if (state.servicesRequestSuccessResponse.isSuccess ?? false) {
                  Dialogs.showInfoDialog(
                          context,
                          PopupType.success,
                          state.servicesRequestSuccessResponse
                              .getDisplayMessage(resources))
                      .then((value) => Navigator.pop(context));
                  if ((employee?.uSERNAME ?? '').isNotEmpty) {
                    _servicesBloc.sendPushNotifications(
                        requestParams: getFCMMessageData(
                            to: employee?.uSERNAME ?? '',
                            title: 'Thank you',
                            body:
                                '${context.userDB.get(userFullNameUsKey)}  has Thanked You!',
                            type: '',
                            notificationId: state.servicesRequestSuccessResponse
                                    .entity?.nTFID ??
                                ''));
                  }
                } else {
                  Dialogs.showInfoDialog(
                      context,
                      PopupType.fail,
                      state.servicesRequestSuccessResponse.entity?.sTATUS ??
                          '');
                }
              } else if (state is OnThankyouListSuccess) {
                _hideLoader(context);
                _thankYouList.value = state.thankYouList;
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
                  BackAppBarWidget(title: context.string.thankYou),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  ValueListenableBuilder(
                      valueListenable: _selectedListType,
                      builder: (context, listType, widget) {
                        return Row(
                          children: [
                            Expanded(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: double.infinity,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    if (_selectedListType.value !=
                                        ThankyouListType.create) {
                                      _selectedListType.value =
                                          ThankyouListType.create;
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: context.resources.dimen.dp5,
                                        horizontal:
                                            context.resources.dimen.dp10),
                                    decoration: BackgroundBoxDecoration(
                                      boxColor: listType ==
                                              ThankyouListType.create
                                          ? context
                                              .resources.color.viewBgColorLight
                                          : context.resources.color.colorF5C3C3,
                                      radious: context.resources.dimen.dp10,
                                    ).roundedCornerBox,
                                    child: Text(
                                      context.string.create,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textFontWeight600
                                          .onColor(context
                                              .resources.color.colorWhite)
                                          .onFontSize(
                                              context.resources.fontSize.dp15),
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
                                    if (_selectedListType.value !=
                                        ThankyouListType.received) {
                                      _selectedListType.value =
                                          ThankyouListType.received;
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: context.resources.dimen.dp5,
                                        horizontal:
                                            context.resources.dimen.dp10),
                                    decoration: BackgroundBoxDecoration(
                                      boxColor: listType ==
                                              ThankyouListType.received
                                          ? context
                                              .resources.color.viewBgColorLight
                                          : context.resources.color.colorF5C3C3,
                                      radious: context.resources.dimen.dp10,
                                    ).roundedCornerBox,
                                    child: Text(
                                      context.string.received,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textFontWeight600
                                          .onColor(context
                                              .resources.color.colorWhite)
                                          .onFontSize(
                                              context.resources.fontSize.dp15),
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
                                    if (_selectedListType.value !=
                                        ThankyouListType.granted) {
                                      _selectedListType.value =
                                          ThankyouListType.granted;
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: context.resources.dimen.dp5,
                                        horizontal:
                                            context.resources.dimen.dp10),
                                    decoration: BackgroundBoxDecoration(
                                      boxColor: listType ==
                                              ThankyouListType.granted
                                          ? context
                                              .resources.color.viewBgColorLight
                                          : context.resources.color.colorF5C3C3,
                                      radious: context.resources.dimen.dp10,
                                    ).roundedCornerBox,
                                    child: Text(
                                      context.string.granted,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.textFontWeight600
                                          .onColor(context
                                              .resources.color.colorWhite)
                                          .onFontSize(
                                              context.resources.fontSize.dp15),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  SizedBox(
                    height: context.resources.dimen.dp30,
                  ),
                  Expanded(
                    child: ValueListenableBuilder(
                        valueListenable: _selectedListType,
                        builder: (context, type, widget) {
                          if (type == ThankyouListType.create) {
                            return SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DropDownWidget<DepartmentEntity>(
                                      list: _departments,
                                      height: resources.dimen.dp27,
                                      labelText: context.string.department,
                                      errorMessage: context.string.department,
                                      selectedValue: department,
                                      callback: onDepartmentSelected,
                                    ),
                                    SizedBox(
                                      height: resources.dimen.dp20,
                                    ),
                                    ValueListenableBuilder(
                                        valueListenable: _employees,
                                        builder: (context, employees, widget) {
                                          return DropDownWidget<EmployeeEntity>(
                                            list: employees,
                                            height: resources.dimen.dp27,
                                            labelText: context.string.employee,
                                            errorMessage:
                                                context.string.employee,
                                            selectedValue: employee,
                                            callback: onEmployeeSelected,
                                          );
                                        }),
                                    SizedBox(
                                      height: resources.dimen.dp20,
                                    ),
                                    DropDownWidget<ThankyouReasonEntity>(
                                      list: _reasons,
                                      height: resources.dimen.dp27,
                                      labelText: context.string.reason,
                                      errorMessage: context.string.reason,
                                      selectedValue: reason,
                                      callback: onReasonSelected,
                                    ),
                                    SizedBox(
                                      height: resources.dimen.dp20,
                                    ),
                                    RightIconTextWidget(
                                      isEnabled: true,
                                      height: resources.dimen.dp27,
                                      labelText: context.string.note,
                                      maxLines: 5,
                                      textController: _noteController,
                                    ),
                                    SizedBox(
                                      height: resources.dimen.dp20,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (type == ThankyouListType.received ||
                              type == ThankyouListType.granted) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 70,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          _setScrollByDirection(
                                              _monthScrollController
                                                  .position.minScrollExtent);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              right: 8.0,
                                              bottom: 8.0),
                                          child: ImageWidget(
                                            path: DrawableAssets.icChevronLeft,
                                            isLocalEn: resources.isLocalEn,
                                          ).loadImage,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          controller: _monthScrollController,
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const SizedBox(width: 20);
                                          },
                                          itemCount: monthYearList.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ItemThankyouMonth(
                                                data: monthYearList[index],
                                                selectedMonth: selectedMonth);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      InkWell(
                                        onTap: () {
                                          _setScrollByDirection(
                                              _monthScrollController.position
                                                      .maxScrollExtent +
                                                  50);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8.0,
                                            top: 8.0,
                                            right: 8.0,
                                          ),
                                          child: ImageWidget(
                                            path: DrawableAssets.icChevronRight,
                                            isLocalEn: resources.isLocalEn,
                                          ).loadImage,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: resources.dimen.dp25,
                                ),
                                Expanded(
                                  child: ValueListenableBuilder(
                                      valueListenable: _thankYouList,
                                      builder: (context, list, child) {
                                        return ListView.separated(
                                          scrollDirection: Axis.vertical,
                                          controller: _listScrollController,
                                          separatorBuilder:
                                              (BuildContext context, int index) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: resources.dimen.dp20),
                                              child: Divider(
                                                height: 1,
                                                color: resources.color
                                                    .bottomSheetIconUnSelected,
                                              ),
                                            );
                                          },
                                          itemCount: list.length,
                                          itemBuilder:
                                              (BuildContext context, int index) {
                                            return ItemThankyouReceived(
                                                data: list[index]);
                                          },
                                        );
                                      }),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                  ),
                  ValueListenableBuilder(
                      valueListenable: _selectedListType,
                      builder: (context, value, widget) {
                        return Visibility(
                          visible: (_selectedListType.value ==
                              ThankyouListType.create),
                          child: Column(
                            children: [
                              SizedBox(
                                height: resources.dimen.dp20,
                              ),
                              SubmitCancelWidget(callBack: onSubmit),
                              SizedBox(
                                height: resources.dimen.dp10,
                              ),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
