import 'package:extumany/db/models/models.dart';
import 'package:flutter/material.dart';

class WorkoutList extends StatelessWidget {
  const WorkoutList(
      {super.key,
      required this.workouts,
      required this.deleteWorkout,
      required this.showEditWorkoutForm});

  final List<Workout> workouts;
  final void Function(int) deleteWorkout;
  final void Function(BuildContext, Workout) showEditWorkoutForm;

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const EmptyState();
    }

    return ListView.builder(
        itemCount: workouts.length,
        itemBuilder: (context, index) => WorkoutBoxItem(
              workout: workouts[index],
              deleteWorkout: deleteWorkout,
              showEditWorkoutForm: showEditWorkoutForm,
            ));
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.list_alt_rounded, size: 48),
          SizedBox(
            height: 24,
          ),
          Text(
            'No workouts yet',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'Add your first workout to get started',
            style: TextStyle(fontSize: 14),
          ),
          Text(
            'Click on the + button to create a workout plan',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class WorkoutBoxItem extends StatelessWidget {
  const WorkoutBoxItem(
      {super.key,
      required this.workout,
      required this.deleteWorkout,
      required this.showEditWorkoutForm});

  final Workout workout;
  final void Function(int) deleteWorkout;
  final void Function(BuildContext, Workout) showEditWorkoutForm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0,
        child: Column(
          children: [
            ListTile(
              title: Text(
                workout.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                workout.description ?? '',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit_rounded,
                    size: 16,
                  ),
                  onPressed: () => showEditWorkoutForm(context, workout),
                  tooltip: 'Edit ${workout.title}',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    size: 16,
                  ),
                  onPressed: () => deleteWorkout(workout.id!),
                  tooltip: 'Delete ${workout.title}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
