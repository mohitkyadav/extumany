import 'package:flutter/material.dart';

class StartWorkoutPage extends StatelessWidget {
  const StartWorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Start workout'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          WorkoutBoxItem(),
          WorkoutBoxItem(),
          WorkoutBoxItem(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.stop_circle, size: 28,),
              tooltip: 'Stop workout',
              onPressed: () {
                // Handle home button press
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutBoxItem extends StatelessWidget {
  const WorkoutBoxItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 300,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'Box Item',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}