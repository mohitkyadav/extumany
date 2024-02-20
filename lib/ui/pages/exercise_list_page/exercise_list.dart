import 'package:flutter/material.dart';
import 'package:extumany/db/models/exercise.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({super.key,
    required this.exercises, required this.deleteExercise});

  final List<Exercise> exercises;
  final void Function(int) deleteExercise;

  @override
  Widget build(BuildContext context) {
    if (exercises.isEmpty) {
      return const EmptyState();
    }

    return ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (
            context, index) => ExerciseBoxItem(exercise: exercises[index], deleteExercise: deleteExercise,));
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
          Icon(Icons.fitness_center, size: 48),
          SizedBox(height: 24,),
          Text('No exercises yet', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),),
          SizedBox(height: 16,),
          Text('Add your first exercise to get started', style: TextStyle(fontSize: 14),),
          Text('Click on the + button to add an exercise', style: TextStyle(fontSize: 14),),
        ],
      ),
    );
  }
}

class ExerciseBoxItem extends StatelessWidget {
  const ExerciseBoxItem({super.key, required this.exercise, required this.deleteExercise});

  final Exercise exercise;
  final void Function(int) deleteExercise;

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
                exercise.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500,),
              ),
              subtitle: Text(
                exercise.description ?? '',
                style: const TextStyle(fontSize: 12,),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_rounded, size: 16,),
                  onPressed: () {
                  },
                  tooltip: 'Edit ${exercise.title}',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever_rounded, size: 16,),
                  onPressed: () => deleteExercise(exercise.id!),
                  tooltip: 'Delete ${exercise.title}',
                ),
                IconButton(
                  icon: const Icon(Icons.north_east_sharp, size: 16,),
                  onPressed: () {
                  },
                  tooltip: 'Open link for ${exercise.title}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}