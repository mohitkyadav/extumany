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
          _isWorkoutFetched ? _workout.title : 'Fetching workout details',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
                const Divider(),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Text(
                    '${_workout.exercises.length} Exercises in this workout',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                _buildExercises(),
                const Divider(),
                _buildDeleteButton(),
              ],
            ),
    );
  }

  Widget _buildDeleteButton() {
    return ElevatedButton(
      onPressed: () => _deleteWorkout(_workout.id),
      child: const Text('Delete Workout'),
    );
  }

  void _deleteWorkout(int? id) {
    if (id == null) return;

    Workout.delete(id).then((value) => Navigator.of(context).pop());
  }

  // a small rounded card that takes the full width of the screen with workout.description and number of exercises
  Widget _buildWorkoutDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_workout.description ?? 'No description provided',
                style: const TextStyle(
                  fontSize: 14,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildExercises() {
    final exercises = _workout.exercises;

    return Expanded(
      flex: 1,
      child: ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return ListTile(
            title: Text('${index + 1}. ${exercise.title}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            subtitle: Text(exercise.description ?? ''),
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
