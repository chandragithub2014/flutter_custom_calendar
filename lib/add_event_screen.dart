import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  final DateTime selectedDate;
  final Function(String) onEventAdded;

  const AddEventScreen({
    required this.selectedDate,
    required this.onEventAdded,
  });

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  late DateTime _selectedDate;
  late String _eventName;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _eventName = '';
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MM-dd-yyyy').format(_selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Event for ${formattedDate.toString()}',
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  _eventName = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Event Name',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Invoke the callback function with the event name
                widget.onEventAdded(_eventName);
                // Navigate back to the CalendarWidget screen
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}