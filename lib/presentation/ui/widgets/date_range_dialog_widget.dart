import 'package:flutter/material.dart';
import 'package:malomati/core/common/common.dart';
import 'package:malomati/core/common/common_utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangeDialogWidget extends StatelessWidget {
  final String? title;
  final DateRangePickerSelectionMode selectionMode;
  final DateTime? initialSelectedDate;
  final List<DateTime>? initialSelectedDates;
  final PickerDateRange? initialSelectedRange;
  final List<PickerDateRange>? initialSelectedRanges;
  const DateRangeDialogWidget(
      {this.title,
      this.selectionMode = DateRangePickerSelectionMode.single,
      this.initialSelectedDate,
      this.initialSelectedDates,
      this.initialSelectedRange,
      this.initialSelectedRanges,
      super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title ??
            (selectionMode == DateRangePickerSelectionMode.single
                ? (isLocalEn ? 'Select Date' : 'اختر التاريخ')
                : (isLocalEn ? 'Selct Date Range' : 'اختر نطاق التاريخ')),
        style: context.textFontWeight600,
      ),
      content: MediaQuery.removePadding(
        removeBottom: true,
        context: context,
        child: SizedBox(
          height: 350,
          width: getScrrenSize(context).width * 0.7,
          child: SfDateRangePicker(
            view: DateRangePickerView.month,
            selectionMode: selectionMode,
            showNavigationArrow: true,
            rangeTextStyle: context.textFontWeight400,
            selectionTextStyle: context.textFontWeight400
                .onColor(context.resources.color.colorWhite),
            navigationMode: DateRangePickerNavigationMode.snap,
            showActionButtons:
                selectionMode != DateRangePickerSelectionMode.single,
            initialSelectedDate: initialSelectedDate,
            initialSelectedDates: initialSelectedDates,
            initialSelectedRange: initialSelectedRange,
            initialSelectedRanges: initialSelectedRanges,
            onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
              if (selectionMode == DateRangePickerSelectionMode.single) {
                Navigator.pop(
                    context, dateRangePickerSelectionChangedArgs.value);
              }
            },
            cancelText: isLocalEn ? 'Cancel' : 'إلغاء',
            confirmText: isLocalEn ? 'OK' : 'موافق',
            onCancel: () {
              Navigator.pop(context);
            },
            onSubmit: (Object? value) {
              if (value is PickerDateRange) {
                Navigator.pop(context, value);
              } else {
                Navigator.pop(context);
              }
            },
            onViewChanged: (dateRangePickerViewChangedArgs) {},
            monthViewSettings: DateRangePickerMonthViewSettings(
                firstDayOfWeek: 1,
                showTrailingAndLeadingDates: true,
                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: context.textFontWeight600.onFontSize(isLocalEn
                        ? 14
                        : (getScrrenSize(context).width * 0.022)
                            .clamp(8, 12)))),
          ),
        ),
      ),
    );
  }
}
