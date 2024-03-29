import 'package:extumany/db/sql_helper.dart';
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
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(214, 37, 18, 1)),
        useMaterial3: true,
      ),
      home: const HomePage(),
      initialRoute: '/',
      routes: {
        StartWorkoutPage.routeName: (context) => const StartWorkoutPage(),
        WorkoutListPage.routeName: (context) => const WorkoutListPage(),
        WorkoutDetailsPage.routeName: (context) => const WorkoutDetailsPage(),
        ExerciseListPage.routeName: (context) => const ExerciseListPage(),
        AnalyticsPage.routeName: (context) => const AnalyticsPage(),
      },
    );
  }
}
