import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constant/app_size.dart';
import '../../helper/app_locals.dart';
import 'package:shuaa_alamal/core/style/app_colors.dart';
import 'package:shuaa_alamal/core/style/app_text_style.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
    super.key,
    required this.selected,
    required this.onChange,
  });

  final DateTime selected;
  final ValueChanged<DateTime> onChange;

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;
  late final DateTime _today;
  late final DateTime _oneMonthLater;
  late final String _localeCode;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selected;

    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _oneMonthLater = DateTime(_today.year, _today.month + 1, _today.day);

    _localeCode = AppLocales.currentLocale.languageCode;
  }

  void _updateSelectedDate(DateTime date) {
    setState(() => _selectedDate = date);
    widget.onChange(date);
  }

  DateTime get _initialFocus {
    if (_selectedDate.isBefore(_today)) return _today;
    if (_selectedDate.isAfter(_oneMonthLater)) return _oneMonthLater;
    return _selectedDate;
  }

  String _middleTextFor(DateTime date, bool isTodayFlag) {
    if (isTodayFlag) return 'core.today'.tr();
    return DateFormat('EEEE', _localeCode).format(date);
  }

  String _bottomTextFor(DateTime date) {
    return DateFormat('d MMMM', _localeCode).format(date);
  }

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLinePicker.itemBuilder(
      locale: AppLocales.currentLocale,
      firstDate: _today,
      lastDate: _oneMonthLater,
      focusedDate: _initialFocus,
      onDateChange: _updateSelectedDate,
      disableStrategy: const DisableStrategy.beforeToday(),
      selectionMode: const SelectionMode.alwaysFirst(),
      headerOptions: const HeaderOptions(headerType: HeaderType.none),
      daySeparatorPadding: AppSize.getWidth(8),
      itemExtent: AppSize.getWidth(76),
      timelineOptions: TimelineOptions(
        padding: EdgeInsets.zero,
        height: AppSize.getHeight(68),
      ),
      itemBuilder: (
        BuildContext context,
        DateTime date,
        bool isSelected,
        bool isDisabled,
        bool isTodayFlag,
        VoidCallback onTap,
      ) {
        final middleText = _middleTextFor(date, isTodayFlag);
        final bottomText = _bottomTextFor(date);
        final textColor = isDisabled
            ? Colors.grey.shade400
            : isSelected
                ? AppColors.brand700
                : AppColors.grey700;
        final backgroundColor =
            isSelected ? AppColors.brand50 : AppColors.white;
        final borderColor = isSelected ? AppColors.brand300 : AppColors.grey300;
        return GestureDetector(
          onTap: isDisabled ? null : onTap,
          child: Container(
            width: AppSize.getWidth(76),
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(AppSize.getSize(8)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  middleText,
                  style: TextStyle(color: textColor).xs,
                ),
                SizedBox(height: AppSize.getHeight(4)),
                Text(
                  bottomText,
                  style: TextStyle(color: textColor).xs,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
