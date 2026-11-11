import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../core/extension/spacing_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_styles.dart';

class ArabicDateHelper {
  static String formatFull(DateTime dt) {
    try {
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'م' : 'ص';
      final formattedDate = DateFormat('EEEE، d MMMM yyyy', 'ar').format(dt);
      return '$formattedDate - $hour:$minute $period';
    } catch (_) {
      const weekdays = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
      const months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
      final weekday = weekdays[(dt.weekday - 1) % 7];
      final month = months[(dt.month - 1) % 12];
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final period = dt.hour >= 12 ? 'م' : 'ص';
      final minute = dt.minute.toString().padLeft(2, '0');
      return '$weekday، ${dt.day} $month ${dt.year} - $hour:$minute $period';
    }
  }

  static String formatMonthYear(DateTime dt) {
    try {
      return DateFormat('MMMM yyyy', 'ar').format(dt);
    } catch (_) {
      const months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
      final month = months[(dt.month - 1) % 12];
      return '$month ${dt.year}';
    }
  }
}

class HomeworkDatePickerBottomSheet extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateConfirmed;

  const HomeworkDatePickerBottomSheet({
    super.key,
    required this.initialDate,
    required this.onDateConfirmed,
  });

  static Future<void> show({
    required BuildContext context,
    required DateTime initialDate,
    required ValueChanged<DateTime> onDateConfirmed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => HomeworkDatePickerBottomSheet(
        initialDate: initialDate,
        onDateConfirmed: onDateConfirmed,
      ),
    );
  }

  @override
  State<HomeworkDatePickerBottomSheet> createState() => _HomeworkDatePickerBottomSheetState();
}

class _HomeworkDatePickerBottomSheetState extends State<HomeworkDatePickerBottomSheet> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDate;
    _focusedDay = widget.initialDate;
    _selectedTime = TimeOfDay(hour: widget.initialDate.hour, minute: widget.initialDate.minute);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          16.verticalSpace,
          Text(
            'تحديد موعد التسليم',
            style: AppStyles.font18Bold(context),
            textAlign: TextAlign.center,
          ),
          12.verticalSpace,
          TableCalendar(
            locale: 'ar',
            firstDay: DateTime.now().subtract(const Duration(days: 30)),
            lastDay: DateTime.now().add(const Duration(days: 365 * 2)),
            focusedDay: _focusedDay,
            currentDay: DateTime.now(),
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.saturday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: AppStyles.font16Bold(context),
              leftChevronIcon: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18.r,
                color: colorScheme.onSurface,
              ),
              rightChevronIcon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 18.r,
                color: colorScheme.onSurface,
              ),
              headerPadding: EdgeInsets.symmetric(vertical: 8.h),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: AppStyles.font12Medium(context).copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              weekendStyle: AppStyles.font12Medium(context).copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              defaultTextStyle: AppStyles.font14Medium(context),
              weekendTextStyle: AppStyles.font14Medium(context),
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: AppStyles.font14Bold(context).copyWith(
                color: Colors.white,
              ),
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              todayTextStyle: AppStyles.font14Bold(context).copyWith(
                color: AppColors.primary,
              ),
            ),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          16.verticalSpace,
          InkWell(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
                builder: (context, child) {
                  return Theme(
                      data: theme.copyWith(
                        timePickerTheme: TimePickerThemeData(
                          backgroundColor: colorScheme.surface,
                          hourMinuteColor: colorScheme.surfaceContainerHighest,
                          hourMinuteTextColor: colorScheme.onSurface,
                          dialHandColor: AppColors.primary,
                          dialBackgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          dialTextColor: colorScheme.onSurface,
                          entryModeIconColor: AppColors.primary,
                        ),
                      ),
                      child: child ?? const SizedBox.shrink(),
                    );
                },
              );
              if (picked != null) {
                setState(() {
                  _selectedTime = picked;
                });
              }
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: AppColors.primary,
                        size: 20.r,
                      ),
                      10.horizontalSpace,
                      Text(
                        'وقت التسليم المحدد',
                        style: AppStyles.font14Medium(context),
                      ),
                    ],
                  ),
                  Text(
                    '${_selectedTime.hourOfPeriod == 0 ? 12 : _selectedTime.hourOfPeriod}:${_selectedTime.minute.toString().padLeft(2, '0')} ${_selectedTime.period == DayPeriod.pm ? 'م' : 'ص'}',
                    style: AppStyles.font14Bold(context).copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          20.verticalSpace,
          ElevatedButton(
            onPressed: () {
              final finalDateTime = DateTime(
                _selectedDay.year,
                _selectedDay.month,
                _selectedDay.day,
                _selectedTime.hour,
                _selectedTime.minute,
              );
              widget.onDateConfirmed(finalDateTime);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'تأكيد التاريخ',
              style: AppStyles.font16Bold(context).copyWith(
                color: Colors.white,
              ),
            ),
          ),
          10.verticalSpace,
        ],
      ),
    );
  }
}
