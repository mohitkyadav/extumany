import 'package:extumany/db/models/models.dart';
import 'package:flutter/material.dart';

class StartWorkoutPage extends StatefulWidget {
  const StartWorkoutPage({super.key});

  static const routeName = '/play';

  @override
  State<StartWorkoutPage> createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  bool _isWorkoutFetched = false;
  late Workout _workout;

  @override
  Widget build(BuildContext context) {
    final workoutId = ModalRoute.of(context)!.settings.arguments as int;

    if (!_isWorkoutFetched) {
      _loadWorkout(workoutId);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
            _isWorkoutFetched ? _workout.title : 'Fetching workout details'),
      ),
      body: _buildWorkoutDetails(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        surfaceTintColor: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: () => {},
              icon: const Icon(
                Icons.stop_circle_rounded,
                size: 24,
              ),
              label: const Text('Stop and save'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutDetails() {
    if (!_isWorkoutFetched) {
      return const LinearProgressIndicator();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInfoSection(),
        _buildExercises(),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.green.shade600.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(_workout.description ?? 'No description provided',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    )),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 24,
                color: Colors.grey,
              ),
              SizedBox(width: 16),
              Flexible(
                child: Text(
                  'Click on the plus button to add log a set for each exercise',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExercises() {
    return Expanded(
      child: ListView.builder(
        itemCount: _workout.exercises.length,
        itemBuilder: (BuildContext context, int index) {
          final exercise = _workout.exercises[index];
          return ListTile(
            title: Text(exercise.title,
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            subtitle: Text(exercise.description ?? 'No description',
                style: TextStyle(color: Colors.white.withOpacity(0.8))),
            trailing: const Icon(Icons.add_rounded, color: Colors.white),
          );
        },
      ),
    );
  }

  Future<void> _loadWorkout(int id) async {
    final workout = await Workout.getOneWorkoutWithExercises(id);

    setState(() {
      _isWorkoutFetched = true;
      _workout = workout;
    });
  }
}
