
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:water_tracker/Models/SettingsModel.dart';


class Calendar extends StatefulWidget {
  //  final List<DateTime> dailyGoalReachedDates;
  // // final DateTime startDate;
  // //
  //  Calendar(this.dailyGoalReachedDates);

  @override
  State<StatefulWidget> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  List<DateTime> dailyGoalReachDates ;

  List<Color> gradientColors = [
    const Color(0xffed882f),
    const Color(0xfff54831),
  ];

  List<Color> gradientColorsGreen = [
    const Color(0xFF49873C),
    const Color(0xff09ff16),
  ];



  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 24, right: 8, bottom: 10, left: 7),
        child: TableCalendar(
         // rowHeight: MediaQuery.of(context).size.height / 24,
            locale:'en_US' ,
            firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            // Use `selectedDayPredicate` to determine which day is currently selected.
            // If this returns true, then `day` will be marked as selected.

            // Using `isSameDay` is recommended to disregard
            // the time-part of compared DateTime objects.
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              // Call `setState()` when updating the selected day
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                Provider.of<SettingsModel>(context, listen: false)
                    .setSelectedDate(_selectedDay);
              });
            }
          },
          onFormatChanged: (format) {
            if (_calendarFormat != format) {
              // Call `setState()` when updating calendar format
              setState(() {
                _calendarFormat = format;
              });
            }
          },
          onPageChanged: (focusedDay) {
            // No need to call `setState()` here
            _focusedDay = focusedDay;
          },
          eventLoader: (day) {
             return [DateTime.utc(2010, 10, 16)];
          },

          calendarStyle: CalendarStyle(
            selectedDecoration:   BoxDecoration(gradient: LinearGradient(
          begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).accentColor
            ],
          ), shape: BoxShape.circle),
              todayDecoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                   Theme.of(context).primaryColor.withOpacity(0.4),
                   Theme.of(context).accentColor.withOpacity(0.4),
                ],
              ), shape: BoxShape.circle),
            markerDecoration: BoxDecoration(gradient: LinearGradient(colors: gradientColorsGreen), shape: BoxShape.circle,  ),
              markersAutoAligned: true,
            markerSizeScale:0.4


          ),

        ),
    );
  }
}
