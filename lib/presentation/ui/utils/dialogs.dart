import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/alert_dialog_widget.dart';
import '../../../res/drawables/drawable_assets.dart';
import '../widgets/image_widget.dart';

class Dialogs {
  static Future<T?> loader<T>(BuildContext context) {
    return showDialog<T>(
      //prevent outside touch
      barrierDismissible: false,
      context: context,
      builder: (context) {
        //prevent Back button press
        return WillPopScope(
            onWillPop: () async => true,
            child: const AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Center(
                child: CircularProgressIndicator(),
              ),
            ));
      },
    );
  }

  static Future<T?> showGenericErrorPopup<T>(
    BuildContext context,
    String title,
    String message,
  ) async {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          TextButton(
              onPressed: () => {Navigator.of(context).pop()},
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => {Navigator.pop(context)},
              child: const Text("Okay")),
        ],
      ),
    );
  }

  static Future showInfoDialog(
      BuildContext context, PopupType popupType, String message,
      {String title = ''}) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialogWidget(
        type: popupType,
        message: message,
        title: title,
      ),
    );
  }

  static showBottomSheetDialog(BuildContext context, Widget widget) {
    showBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (context) => Container(
            height: double.infinity,
            padding:
                EdgeInsets.symmetric(vertical: context.resources.dimen.dp10),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                          padding: EdgeInsets.all(context.resources.dimen.dp5),
                          margin: EdgeInsets.only(
                              right: context.resources.dimen.dp10),
                          child: ImageWidget(path: DrawableAssets.icClose)
                              .loadImage),
                    )),
                widget,
              ],
            )));
  }

  static showBottomSheetDialogTransperrent(BuildContext context, Widget widget,
      {Function(dynamic)? callback}) {
    showModalBottomSheet(
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30.0)),
        ),
        context: context,
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(alignment: Alignment.bottomCenter, child: widget),
              ],
            )).then((value) {
      if (callback != null) callback(value);
    });
  }

  Future showiOSDatePickerDialog(BuildContext context, Widget child) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Material(
                        child: Text(
                          context.string.done,
                          style: context.textFontWeight600,
                        ),
                      ),
                    ),
                  )),
              SizedBox(width: double.infinity, height: 250, child: child),
            ],
          ),
        ),
      ),
    );
  }
}
