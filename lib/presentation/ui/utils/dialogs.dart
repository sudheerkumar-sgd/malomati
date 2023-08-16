import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
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
    BuildContext context,
    String title,
    String message,
  ) async {
    return showDialog(
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
              onPressed: () => {Navigator.pop(context)},
              child: const Text("Okay")),
        ],
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

  static showBottomSheetDialogTransperrent(
      BuildContext context, Widget widget) {
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
            ));
  }
}
