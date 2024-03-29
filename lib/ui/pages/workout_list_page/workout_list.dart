import 'package:extumany/db/models/models.dart';
import 'package:extumany/ui/widgets/widgets.dart';
import 'package:extumany/ui/pages/pages.dart';
import 'package:flutter/material.dart';

class WorkoutList extends StatelessWidget {
  const WorkoutList(
      {super.key,
      required this.workouts,
      required this.deleteWorkout,
      required this.loadWorkouts});

  final List<Workout> workouts;
  final void Function(int) deleteWorkout;
  final void Function() loadWorkouts;

  @override
  Widget build(BuildContext context) {
    if (workouts.isEmpty) {
      return const EmptyState();
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: WorkoutBoxItem(
                workout: workouts[index],
                deleteWorkout: deleteWorkout,
                loadWorkouts: loadWorkouts,
              ));
        },
        childCount: workouts.length,
      ),
    );
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
      required this.loadWorkouts});

  final Workout workout;
  final void Function(int) deleteWorkout;
  final void Function() loadWorkouts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            WorkoutDetailsPage.routeName,
            arguments: workout.id,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  workout.description ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        WorkoutEditor(
                          workout: workout,
                          successCallback: () => loadWorkouts(),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_forever_rounded,
                            size: 18,
                          ),
                          onPressed: () => deleteWorkout(workout.id!),
                          tooltip: 'Delete ${workout.title}',
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.play_circle_filled_rounded,
                        size: 18,
                      ),
                      tooltip: 'Start workout',
                      onPressed: () => Navigator.pushNamed(
                        context,
                        StartWorkoutPage.routeName,
                        arguments: workout.id,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
