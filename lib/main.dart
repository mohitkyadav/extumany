import 'package:flutter/material.dart';

import 'package:extumany/ui/pages/pages.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Extumany',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
      initialRoute: '/',
      routes: {
        '/play': (context) => const StartWorkoutPage(),
        '/exercises': (context) => const ExercisesPage(),
        '/analytics': (context) => const AnalyticsPage(),
      },
    );
  }
}
