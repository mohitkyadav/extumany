import 'package:extumany/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:extumany/db/models/models.dart';

class WorkoutDetailsPage extends StatefulWidget {
  const WorkoutDetailsPage({super.key});

  static const routeName = '/workout';

  @override
  State<WorkoutDetailsPage> createState() => _WorkoutDetailsPage();
}

class _WorkoutDetailsPage extends State<WorkoutDetailsPage> {
  bool _isWorkoutFetched = false;
  late Workout _workout;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;

    if (!_isWorkoutFetched) {
      _loadWorkout(id);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            _isWorkoutFetched ? _workout.title : 'Fetching workout details'),
        actions: [
          _isWorkoutFetched
              ? WorkoutEditor(
                  workout: _workout,
                  successCallback: () => _loadWorkout(id),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: !_isWorkoutFetched
          ? const LinearProgressIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildWorkoutDetails(),
                _buildExercises(),
              ],
            ),
    );
  }

  void _deleteWorkout(int? id) {
    if (id == null) return;

    Workout.delete(id).then((value) => Navigator.of(context).pop());
  }

  // a small rounded card that takes the full width of the screen with workout.description and number of exercises
  Widget _buildWorkoutDetails() {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _workout?.description ?? '',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              'Exercises: ${_workout?.exercises.length ?? 0}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExercises() {
    final exercises = _workout?.exercises ?? [];

    return Expanded(
      child: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return ListTile(
            title: Text(exercise.title),
            subtitle: Text(exercise.description ?? ''),
          );
        },
      ),
    );
  }

  Future<void> _loadWorkout(int id) async {
    final workout = await Workout.getOneWorkoutWithExercises(id);

    print(workout);
    setState(() {
      _isWorkoutFetched = true;
      _workout = workout;
    });
  }
}
