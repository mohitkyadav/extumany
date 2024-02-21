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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _loadWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Your workouts'),
      ),
      body: _isLoading
          ? const LinearProgressIndicator()
          : WorkoutList(
              workouts: workouts,
              deleteWorkout: _deleteWorkout,
              showEditWorkoutForm: _showEditWorkoutForm),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateWorkoutForm(context),
        tooltip: 'Create new workout',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateWorkoutForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add New Exercise',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onSaved: (value) => _title = value!,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    onSaved: (value) => _description = value!,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => _saveExercise(context),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveExercise(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Do something with _name
    }
    final workout = Workout(title: _title, description: _description);

    workout.persistInDb().then((newWorkoutId) {
      _loadWorkouts();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exercise saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
      _formKey.currentState!.reset();
    });
  }

  void _showEditWorkoutForm(BuildContext context, Workout workout) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Edit Workout',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: workout.title,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    onSaved: (value) => _title = value!,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: workout.description,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    onSaved: (value) => _description = value!,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () => _updateWorkout(context, workout),
                    child: const Text('Update'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _updateWorkout(BuildContext context, Workout workout) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Do something with _name
    }
    final updatedWorkout = Workout(
      id: workout.id,
      title: _title,
      description: _description,
    );

    updatedWorkout.persistInDb().then((newWorkoutId) {
      _loadWorkouts();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Workout updated successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
      _formKey.currentState!.reset();
    });
  }

  Future<void> _loadWorkouts() async {
    List<Workout> loadedWorkouts = await Workout.getAll();
    setState(() {
      workouts = loadedWorkouts;
      _isLoading = false;
    });
  }

  Future<void> _deleteWorkout(int id) async {
    await Workout.delete(id);
    _loadWorkouts();
  }
}
