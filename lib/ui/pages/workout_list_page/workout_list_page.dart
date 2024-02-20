import 'package:extumany/db/models/models.dart';
import 'package:extumany/ui/pages/workout_list_page/workout_list.dart';
import 'package:flutter/material.dart';

class WorkoutListPage extends StatefulWidget {
  const WorkoutListPage({super.key});

  @override
  State<WorkoutListPage> createState() => _WorkoutListPageState();
}

class _WorkoutListPageState extends State<WorkoutListPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  List<Workout> workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Your workouts'),
      ),
      body: WorkoutList(workouts: workouts, deleteWorkout: _deleteWorkout),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _showCreateWorkoutForm(context);
        },
        tooltip: 'Create new workout',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _loadWorkouts() async {
    List<Workout> loadedWorkouts = await Workout.getAll();
    setState(() {
      workouts = loadedWorkouts;
    });
  }

  Future<void> _deleteWorkout(int id) async {
    await Workout.delete(id);
    _loadWorkouts();
  }
}
