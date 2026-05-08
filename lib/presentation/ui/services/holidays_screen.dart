import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/events_entity.dart';
import 'package:malomati/presentation/ui/guest/guest_back_app_bar.dart';
import 'package:malomati/presentation/ui/services/widgets/item_events.dart';

import '../../../injection_container.dart';
import '../../bloc/services/services_bloc.dart';
import '../utils/dialogs.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class HolidaysScreen extends StatefulWidget {
  const HolidaysScreen({super.key});

  @override
  State<HolidaysScreen> createState() => _HolidaysScreenState();
}

class _HolidaysScreenState extends State<HolidaysScreen> {
  final _servicesBloc = sl<ServicesBloc>();
  final ValueNotifier<List<EventsEntity>> _notificationList =
      ValueNotifier<List<EventsEntity>>([]);
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);

  String _noNotificationText = '';
  bool _didInit = false;
  bool _isLoaderShowing = false;

  void _fetchHolidayEvents() {
    _isLoading.value = true;
    _servicesBloc.getHolidayEvents(requestParams: {
      'START_DATE': '${DateTime.now().year}-01-01',
      'END_DATE': '${DateTime.now().year}-12-31'
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
    _fetchHolidayEvents();
  }

  @override
  Widget build(BuildContext context) {
    var resources = context.resources;
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                _showLoader(context);
              } else if (state is OnHolidayEventsSuccess) {
                _hideLoader(context);
                _noNotificationText = context.string.noHrRequests;
                _notificationList.value = state.holidayEvents;
                _isLoading.value = false;
              } else if (state is OnServicesError) {
                _hideLoader(context);
                _isLoading.value = false;
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
                  context.userDB.get(isGuestKey, defaultValue: false)
                      ? GuestBackAppBarWidget(title: context.string.holidays)
                      : BackAppBarWidget(title: context.string.holidays),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  Expanded(
                      child: ValueListenableBuilder<bool>(
                          valueListenable: _isLoading,
                          builder: (context, isLoading, _) {
                            if (isLoading) {
                              return const Center(
                                  child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: CircularProgressIndicator()));
                            }
                            return ValueListenableBuilder<List<EventsEntity>>(
                                valueListenable: _notificationList,
                                builder: (context, notificationList, child) {
                                  return (notificationList.isEmpty &&
                                          _noNotificationText.isNotEmpty)
                                      ? Center(
                                          child: Text(
                                            _noNotificationText,
                                            style: context.textFontWeight600,
                                          ),
                                        )
                                      : ListView.separated(
                                          controller: _scrollController,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) =>
                                              ItemEvents(
                                                data: notificationList[index],
                                              ),
                                          separatorBuilder: (context, index) =>
                                              SizedBox(
                                                height: resources.dimen.dp20,
                                              ),
                                          itemCount: notificationList.length);
                                });
                          })),
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
    _notificationList.dispose();
    _isLoading.dispose();
    _scrollController.dispose();
    _servicesBloc.close();
    super.dispose();
  }
}
