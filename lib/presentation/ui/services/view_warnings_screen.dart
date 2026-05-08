import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/domain/entities/warning_list_entity.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/item_warnings.dart';

import '../../../injection_container.dart';
import '../utils/dialogs.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';

class ViewWarningsScreen extends StatefulWidget {
  const ViewWarningsScreen({super.key});

  @override
  State<ViewWarningsScreen> createState() => _ViewWarningsScreenState();
}

class _ViewWarningsScreenState extends State<ViewWarningsScreen> {
  final _serviceBloc = sl<ServicesBloc>();
  final ValueNotifier<List<WarningListEntity>> _warningsList =
      ValueNotifier<List<WarningListEntity>>([]);
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);
  final ScrollController _scrollController = ScrollController();

  String _userName = '';
  String _noWarningsText = '';
  bool _didInit = false;

  void _fetchWarnings() {
    _isLoading.value = true;
    _serviceBloc.getWarningList(requestParams: {
      'USER_NAME': _userName,
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInit) return;
    _didInit = true;
    _userName = context.userDB.get(userNameKey, defaultValue: '');
    _fetchWarnings();
  }

  @override
  Widget build(BuildContext context) {
    var resources = context.resources;
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _serviceBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnWarningListSuccess) {
                _noWarningsText = context.string.noWarnings;
                _warningsList.value = state.warningList;
                _isLoading.value = false;
              } else if (state is OnServicesError) {
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
                  BackAppBarWidget(title: context.string.viewWarnings),
                  SizedBox(
                    height: context.resources.dimen.dp20,
                  ),
                  Expanded(child: ValueListenableBuilder<bool>(
                      valueListenable: _isLoading,
                      builder: (context, isLoading, _) {
                        if (isLoading) {
                          return const Center(
                              child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: CircularProgressIndicator()));
                        }
                        return ValueListenableBuilder<List<WarningListEntity>>(
                            valueListenable: _warningsList,
                            builder: (context, warningsList, child) {
                              return warningsList.isEmpty
                                  ? Center(
                                      child: Text(
                                        _noWarningsText,
                                        style: context.textFontWeight600,
                                      ),
                                    )
                                  : ListView.separated(
                                      controller: _scrollController,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) =>
                                          ItemWarnings(
                                            data: warningsList[index],
                                          ),
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            height: resources.dimen.dp20,
                                          ),
                                      itemCount: warningsList.length);
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
    _warningsList.dispose();
    _isLoading.dispose();
    _scrollController.dispose();
    _serviceBloc.close();
    super.dispose();
  }
}
