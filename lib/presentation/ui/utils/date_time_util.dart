import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/presentation/ui/widgets/date_range_dialog_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'dialogs.dart';

Future<void> selectDate(BuildContext context,
    {DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String dateFormat = '',
    required Function(DateTime) callBack}) async {
  final currentDate = DateTime.now();
  DateTime selectedDate = initialDate ?? firstDate ?? currentDate;
  if (Platform.isAndroid) {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? firstDate ?? currentDate,
      firstDate: firstDate ?? DateTime(currentDate.year - 1, currentDate.month),
      lastDate: lastDate ?? DateTime(currentDate.year + 1, currentDate.month),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: context.resources.color.viewBgColor, // header text color
            onSurface: context.resources.color.viewBgColor, // body text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor:
                  context.resources.color.viewBgColor, // button text color
            ),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      callBack(picked);
    }
  } else {
    Dialogs()
        .showiOSDatePickerDialog(
            context,
            CupertinoDatePicker(
              initialDateTime: initialDate ?? currentDate,
              minimumDate: firstDate ??
                  DateTime(currentDate.year - 1, currentDate.month),
              maximumDate:
                  lastDate ?? DateTime(currentDate.year + 1, currentDate.month),
              mode: CupertinoDatePickerMode.date,
              use24hFormat: true,
              // This is called when the user changes the time.
              onDateTimeChanged: (DateTime newTime) {
                selectedDate = newTime;
              },
            ))
        .then((value) {
      callBack(selectedDate);
    });
  }
}

Future<void> selectTime(BuildContext context,
    {DateTime? startTime, required Function(DateTime) callBack}) async {
  DateTime selectedTime = startTime ?? DateTime.now();

  if (Platform.isAndroid) {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startTime ?? DateTime.now()),
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.resources.color.viewBgColor,
              onSurface: context.resources.color.viewBgColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    context.resources.color.viewBgColor, // button text color
              ),
            ),
          ),
          child: child!,
        ),
      ),
    );
    if (picked != null) {
      callBack(DateTime(selectedTime.year, selectedTime.month, selectedTime.day,
          picked.hour, picked.minute));
    }
  } else {
    Dialogs()
        .showiOSDatePickerDialog(
            context,
            CupertinoDatePicker(
              initialDateTime: startTime ?? DateTime.now(),
              mode: CupertinoDatePickerMode.time,
              use24hFormat: true,
              // This is called when the user changes the time.
              onDateTimeChanged: (DateTime newTime) {
                selectedTime = newTime;
              },
            ))
        .then((value) {
      callBack(selectedTime);
    });
  }
}

Future showDateRangePickerDialog(BuildContext context,
    {String? title,
    DateRangePickerSelectionMode selectionMode =
        DateRangePickerSelectionMode.single,
    DateTime? initialSelectedDate,
    List<DateTime>? initialSelectedDates,
    PickerDateRange? initialSelectedRange,
    List<PickerDateRange>? initialSelectedRanges}) {
  return showDialog(
      context: context,
      builder: (context) => DateRangeDialogWidget(
            title: title,
            selectionMode: selectionMode,
            initialSelectedDate: initialSelectedDate,
            initialSelectedDates: initialSelectedDates,
            initialSelectedRange: initialSelectedRange,
            initialSelectedRanges: initialSelectedRanges,
          ));
}
