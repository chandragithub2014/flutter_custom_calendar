import 'package:flutter/material.dart';
import 'calendar_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Widget',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Calendar Widget'),
        ),
        body: const Center(
          child: CalendarWidget(),
        ),
      ),
    );
  }
}


