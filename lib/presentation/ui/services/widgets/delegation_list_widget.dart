// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/core/network/api_urls.dart';
import 'package:malomati/domain/entities/delegation_entity.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/services/widgets/item_delegation_list.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/alert_dialog_widget.dart';

class DelegationListWidget extends StatelessWidget {
  final Function(DelegationItemEntity)? onChange;
  DelegationListWidget({this.onChange, super.key});
  final _servicesBloc = sl<ServicesBloc>();
  String? deletedUserName;
  bool showLoading = true;
  final ValueNotifier<bool> _doRefresh = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final userName = context.userDB.get(userNameKey, defaultValue: '');

    return BlocProvider(
      create: (context) => _servicesBloc,
      child: BlocListener<ServicesBloc, ServicesState>(
        listener: (context, state) {
          if (state is OnServicesLoading) {
            Dialogs.loader(context);
          } else if (state is OnServicesRequestSubmitSuccess) {
            Dialogs.dismiss(context);
            if (state.servicesRequestSuccessResponse.isSuccess ?? false) {
              Dialogs.showInfoDialog(
                  context,
                  PopupType.success,
                  state.servicesRequestSuccessResponse
                      .getDisplayMessage(context.resources));
              _servicesBloc.sendPushNotifications(
                  requestParams: getFCMMessageData(
                to: deletedUserName ?? '',
                title:
                    '${context.userDB.get(userFullNameUsKey, defaultValue: '').toString()} has deleted your delegation.',
                body: '',
              ));
            } else {
              Dialogs.showInfoDialog(
                  context,
                  PopupType.fail,
                  state.servicesRequestSuccessResponse
                      .getDisplayMessage(context.resources));
            }
            deletedUserName = '';
            _doRefresh.value = !_doRefresh.value;
          } else if (state is OnServicesError) {
            deletedUserName = '';
            Dialogs.dismiss(context);
            Dialogs.showInfoDialog(context, PopupType.fail, state.message);
          }
        },
        child: ValueListenableBuilder(
            valueListenable: _doRefresh,
            builder: (context, doRefresh, child) {
              return FutureBuilder(
                  future: _servicesBloc
                      .getDelegationList(requestParams: {'UserName': userName}),
                  builder: (context, snapShot) {
                    if (snapShot.data == null) {
                      if (showLoading) {
                        showLoading = false;
                        return const Center(
                          child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator()),
                        );
                      } else {
                        return Center(
                          child: Text(
                            context.string.noHrRequests,
                            style: context.textFontWeight600,
                          ),
                        );
                      }
                    }
                    List<DelegationItemEntity> list = snapShot.data ?? [];
                    return ListView.separated(
                        itemBuilder: (context, index) {
                          return ItemDelegationList(
                            delegationItem: list[index],
                            callBack: (item) async {
                              deletedUserName = item.delegateTO;
                              final requestParams = {
                                "ruleId": item.rULEID,
                                "userName": userName,
                                "action": "FORWARD",
                                "beginDate": item.bEGINDATE,
                                "endDate": item.eNDDATE,
                                "messageType": item.mESSAGETYPE,
                                "messageName": "",
                                "delegatedUser": item.delegateTO,
                                "ruleComment": item.message,
                                "securityGroupId": ""
                              };
                              _servicesBloc.submitServicesRequest(
                                  apiUrl: delegationDeleteApiUrl,
                                  requestParams: requestParams);
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: context.resources.color.colorD6D6D6,
                          );
                        },
                        itemCount: list.length);
                  });
            }),
      ),
    );
  }
}
