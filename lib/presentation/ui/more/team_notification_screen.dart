// ignore_for_file: must_be_immutable
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:malomati/injection_container.dart';
import 'package:malomati/presentation/bloc/services/services_bloc.dart';
import 'package:malomati/presentation/ui/utils/dialogs.dart';
import 'package:malomati/presentation/ui/widgets/right_icon_text_widget.dart';
import 'package:malomati/res/resources.dart';
import '../services/widgets/submit_cancel_widget.dart';
import '../widgets/alert_dialog_widget.dart';
import '../widgets/back_app_bar.dart';
import '../widgets/notification_dialog_widget.dart';

class TeamNotificationScreen extends StatelessWidget {
  static const String route = '/TeamNotificationScreen';
  TeamNotificationScreen({super.key});
  late Resources resources;
  final _servicesBloc = sl<ServicesBloc>();
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  late BuildContext context;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  onSubmit(String clickedButton) async {
    if (_formKey.currentState!.validate()) {
      if (clickedButton == context.string.test) {
        await _sendPushNotifications(
            context.userDB.get(userNameKey, defaultValue: 'a'));
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return NotificationDialogWidget(
                title: titleController.text,
                message: bodyController.text,
                imageUrl: urlController.text,
                actionButtionTitle: context.string.send,
              );
            }).then((value) {
          if (value != null) {
            _sendPushNotifications('MALOMATI');
          }
        });
      }
    }
  }

  _sendPushNotifications(String to) {
    _servicesBloc.sendPushNotifications(
        requestParams: getFCMMessageData(
            to: to,
            title: titleController.text,
            body: bodyController.text,
            type: 'POPUP',
            imageUrl: urlController.text,
            notificationId: '${Random(123456).nextInt(123456)}'),
        showLoader: true);
  }

  @override
  Widget build(BuildContext context) {
    resources = context.resources;
    this.context = context;
    userName = context.userDB.get(userNameKey, defaultValue: '');
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.resources.color.appScaffoldBg,
        body: BlocProvider<ServicesBloc>(
          create: (context) => _servicesBloc,
          child: BlocListener<ServicesBloc, ServicesState>(
            listener: (context, state) {
              if (state is OnServicesLoading) {
                Dialogs.loader(context);
              } else if (state is OnFCMSuccess) {
                Navigator.of(context, rootNavigator: true).pop();
                Dialogs.showInfoDialog(context, PopupType.success,
                    'Notification sent successfully');
              } else if (state is OnServicesError) {
                Navigator.of(context, rootNavigator: true).pop();
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
                  BackAppBarWidget(title: context.string.teamNotification),
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
                            RightIconTextWidget(
                              isEnabled: true,
                              height: resources.dimen.dp27,
                              labelText: context.string.title,
                              errorMessage: context.string.title,
                              textController: titleController,
                              fontFamily: fontFamilyEN,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              isEnabled: true,
                              height: resources.dimen.dp27,
                              labelText: context.string.imageorVideoURL,
                              textController: urlController,
                            ),
                            SizedBox(
                              height: resources.dimen.dp20,
                            ),
                            RightIconTextWidget(
                              height: resources.dimen.dp100,
                              isEnabled: true,
                              maxLines: 8,
                              labelText: context.string.description,
                              errorMessage: context.string.description,
                              textController: bodyController,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: resources.dimen.dp20,
                  ),
                  SubmitCancelWidget(
                    callBack: onSubmit,
                    actionButtonName: context.string.preview,
                    cancelButtonName: context.string.test,
                  ),
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
