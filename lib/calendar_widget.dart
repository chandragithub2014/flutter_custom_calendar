import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'add_event_screen.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({Key? key}) : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDate;
  late DateTime _focusedDay;
  Map<DateTime, List<String>> _events = {};
  TextEditingController _eventController = TextEditingController();
  late CalendarFormat _calendarFormat;

  @override
  void initState() {

    super.initState();
    _selectedDate = DateTime.now();
    _focusedDay = _selectedDate;
    _calendarFormat = CalendarFormat.month;
  //  _loadEvents();
  }

  void _addEvent(DateTime date, String event) {
    setState(() {
      if (_events.containsKey(date)) {
        _events[date]!.add(event);
      } else {
        _events[date] = [event];
      }
    });
  }

  void _loadEvents() {
    // Simulated event loading
    _events = {
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): ['Event 1', 'Event 2'],
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1): ['Event 3'],
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2): ['Event 4', 'Event 5'],
    };
  }
  void _selectDate(DateTime date, DateTime focusedDay) {
    setState(() {
      _selectedDate = date;
      _focusedDay = focusedDay;
    });

  }
  bool _isSameDay(DateTime dayA, DateTime dayB) {
    return dayA.year == dayB.year && dayA.month == dayB.month && dayA.day == dayB.day;
  }
  List<String> _getEventsForDay(DateTime day) {
    // Retrieve events for the selected day
    return _events[day] ?? [];
  }

  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    List<String>? eventsForSelectedDate = _events[_selectedDate];

    return Column(
      children: [
        TableCalendar(
          calendarFormat: _calendarFormat,
          focusedDay: _focusedDay,
          firstDay: DateTime(2000),
          lastDay: DateTime(2050),
          selectedDayPredicate: (date) {
            return isSameDay(_selectedDate, date);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
                _focusedDay = date;
              });
            },
            child: Center(
              child: Text(
                date.day.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          );
        },
        selectedBuilder: (context, date, _) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
                _focusedDay = date;
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
        // Custom marker builder
        markerBuilder: (context, date, events) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (events.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0), // Adjust the bottom margin as needed
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          );
        },
      ),




          eventLoader: (day) {
            return _events[day] ?? [];
          },

        ),
        Expanded(
          child: ListView.builder(
            itemCount: _events[_selectedDate]?.length ?? 0,
            itemBuilder: (context, index) {
              final event = _events[_selectedDate]![index];
              return ListTile(
                title: Text(event),
              );
            },
          ),
        ),
        FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEventScreen(
                  selectedDate: _selectedDate,
                  onEventAdded: (event) {
                    setState(() {
                      if (_events.containsKey(_selectedDate)) {
                        _events[_selectedDate]!.add(event);
                      } else {
                        _events[_selectedDate] = [event];
                      }
                    });
                  },
                ),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ],
    );
  }
  List<Widget> _buildEventMarkers() {
    final eventMarkers = <Widget>[];
    final events = _getEventsForDay(_selectedDate);
    events.forEach((event) {
      eventMarkers.add(
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(
            color: Colors.red, // Customize the color of the event marker
            shape: BoxShape.circle,
          ),
        ),
      );
    });
    return eventMarkers;
  }
}
