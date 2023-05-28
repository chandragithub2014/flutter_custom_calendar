import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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

  @override
  void initState() {

    super.initState();
    _selectedDate = DateTime.now();
    _focusedDay = _selectedDate;
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
    return Column(
      children: [
       /* Text(
          'Selected Date: ${_selectedDate.toString()}',
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),*/
        TableCalendar(
          // Customize the calendar appearance and behavior as needed
          // using various properties and call
          // onDaySelected: _handleDaySelected,
          onDaySelected: _selectDate,
          focusedDay: _selectedDate,
          firstDay: DateTime(DateTime.now().year - 1),
          lastDay: DateTime(DateTime.now().year + 1),
          selectedDayPredicate: (day) => _isSameDay(day, _selectedDate),
          calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.blue, // Customize the background color of the selected date
              shape: BoxShape.circle,
            ),
          ),
          eventLoader: (day) => _events[day] ?? [],
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.red, // Customize the color of the event marker
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Add Event'),
                content: SingleChildScrollView(
                  child: TextField(
                    controller: _eventController,
                    decoration: const InputDecoration(labelText: 'Event Name'),
                    onChanged: (value) {
                      // Handle event name change
                    },
                  ),

                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      String eventName = _eventController.text;
                      _addEvent(_selectedDate, eventName);
                      _eventController.clear();
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            );
          },
          child: const Text('Add Event'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _getEventsForDay(_selectedDate).length,
            itemBuilder: (context, index) {
              final event = _getEventsForDay(_selectedDate)[index];
              return ListTile(
                title: Text(event),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildEventMarkers(),
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
