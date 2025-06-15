import 'package:flutter/material.dart';
import 'package:libby_guild/res/colors.dart';
import 'package:libby_guild/res/text_themes.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../common/logger.dart';

class Calendar extends StatefulWidget {
  final OnDaySelected onDaySelected;

  const Calendar({super.key, required this.onDaySelected, required this.focusedDay});

  final DateTime focusedDay;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    logger.i(">>> calendar >> ${widget.focusedDay}");
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), border: Border.all(width: 1, color: colorScheme.grayGray2)),
        child: TableCalendar(
          onDaySelected: (selectedDay, focusedDay) {
            // 일요일 막음
            if (selectedDay.weekday == DateTime.sunday || focusedDay.weekday == DateTime.sunday ||
                selectedDay.weekday == DateTime.saturday || focusedDay.weekday == DateTime.saturday) {

            } else {
              setState(() {
                logger.i(">>> calendar >> selectedDay : $selectedDay, focusedDay : $focusedDay}");
                widget.onDaySelected(selectedDay, focusedDay);
                _selectedDate = selectedDay;
              });
            }
          },
          selectedDayPredicate: (date) =>
              date.year == _selectedDate?.year && date.month == _selectedDate?.month && date.day == _selectedDate?.day,
          weekendDays: const [DateTime.sunday, DateTime.saturday],
          locale: 'ko_KR',
          focusedDay: widget.focusedDay,
          firstDay: DateTime(2023, 1, 1),
          lastDay: DateTime(3000, 1, 1),
          headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: textTheme.titleH3Bold.copyWith(color: colorScheme.primaryBlack)),
          daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: textTheme.captionC1Bold.copyWith(color: colorScheme.primaryBlack),
              weekendStyle: textTheme.captionC1Bold.copyWith(color: colorScheme.secondaryRed)),
          calendarStyle: CalendarStyle(
              outsideTextStyle: textTheme.bodyB2Regular.copyWith(color: colorScheme.grayGray1),
              disabledTextStyle: textTheme.bodyB2Regular.copyWith(color: colorScheme.grayGray1),
              defaultTextStyle: textTheme.bodyB2Regular.copyWith(color: colorScheme.primaryBlack),
              weekendTextStyle: textTheme.bodyB2Regular.copyWith(color: colorScheme.grayGray1),
              selectedTextStyle: textTheme.bodyB2Bold.copyWith(color: colorScheme.primaryWhite),
              selectedDecoration: BoxDecoration(color: colorScheme.primarySubMain, shape: BoxShape.circle),
              todayTextStyle: textTheme.bodyB2Regular.copyWith(color: colorScheme.primaryBlack),
              todayDecoration: BoxDecoration(color: colorScheme.opacity10SecondaryOrange, shape: BoxShape.circle)),
        ));
  }
}
