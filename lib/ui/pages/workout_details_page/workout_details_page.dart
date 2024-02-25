import 'package:extumany/ui/pages/pages.dart';
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
  List<Exercise> _unselectedExercises = [];
  Exercise? _selectedOption;

  @override
  Widget build(BuildContext context) {
    final workoutId = ModalRoute.of(context)!.settings.arguments as int;

    if (!_isWorkoutFetched) {
      _loadWorkout(workoutId);
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
                  successCallback: () => _loadWorkout(workoutId),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: !_isWorkoutFetched
          ? const LinearProgressIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildWorkoutDetails(),
                _buildInfoSection(),
                _buildExercises(),
              ],
            ),
      bottomNavigationBar: _buildBottomAppBar(workoutId),
    );
  }

  BottomAppBar _buildBottomAppBar(int workoutId) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () => _showAddExerciseDialog(workoutId),
              icon: const Icon(Icons.add),
              tooltip: 'Add Exercise',
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              )),
          IconButton(
            onPressed: () => _deleteWorkout(_workout.id),
            icon: const Icon(Icons.delete_forever_rounded),
            tooltip: 'Delete this workout',
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.play_circle_filled_rounded,
            ),
            tooltip: 'Start workout',
            onPressed: () => Navigator.pushNamed(
              context,
              StartWorkoutPage.routeName,
              arguments: _workout.id,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      margin: const EdgeInsets.all(16).copyWith(bottom: 18, top: 22),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_workout.exercises.length} Exercises in this workout',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, size: 24),
              SizedBox(width: 16),
              Flexible(
                child: Text(
                  'The order is not important here, when you start the workout, '
                  'you can do the exercises and log your sets in any order you like.',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddExerciseDialog(int workoutId) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, setStateSB) {
          return AlertDialog(
            content: Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              child: DropdownButton<Exercise>(
                hint: const Text('Select an exercise'),
                padding: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(10),
                value: _selectedOption,
                onChanged: (Exercise? newValue) {
                  setStateSB(() {
                    _selectedOption = newValue!;
                  });
                },
                elevation: 0,
                isExpanded: true,
                items: _unselectedExercises
                    .map<DropdownMenuItem<Exercise>>((exercise) {
                  return DropdownMenuItem<Exercise>(
                    value: exercise,
                    child: Text(exercise.title),
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  setStateSB(() {
                    _selectedOption = null;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final exerciseId = _selectedOption!.id;
                  _addExerciseToWorkout(workoutId, exerciseId!).then((value) {
                    _loadWorkout(workoutId);
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Exercise added to workout'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  });
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addExerciseToWorkout(int workoutId, int exerciseId) async {
    final newWorkoutExercise =
        WorkoutExercise(workoutId: workoutId, exerciseId: exerciseId);
    await newWorkoutExercise.persistInDb();
  }

  void _deleteWorkout(int? id) {
    if (id == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Delete workout',
          content: const Text('This action cannot be undone.'),
          confirmText: 'Yes, delete',
          onConfirm: () =>
              Workout.delete(id).then((value) => Navigator.of(context).pop()),
        );
      },
    );
  }

  Widget _buildWorkoutDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildExercises() {
    final exercises = _workout.exercises;
    final workoutId = _workout.id!;

    return Expanded(
      // flex: FlexFit.tight.index,
      child: ListView.builder(
        itemCount: exercises.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          return ListTile(
              leading: Text(
                '${index + 1}.',
                style: const TextStyle(fontSize: 18),
              ),
              title: Text(exercise.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              subtitle: Text(exercise.description ?? ''),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_rounded,
                  size: 16,
                ),
                onPressed: () {
                  WorkoutExercise.delete(exercise.id!).then((value) {
                    _loadWorkout(workoutId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Exercise removed from workout'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  });
                },
              ));
        },
      ),
    );
  }

  Future<void> _loadWorkout(int id) async {
    final workout = await Workout.getOneWorkoutWithExercises(id);
    final unselectedExercises = await Exercise.getAllExcept(
        workout.exercises.map((e) => e.id!).toList(growable: false));

    setState(() {
      _isWorkoutFetched = true;
      _workout = workout;
      _unselectedExercises = unselectedExercises;
      _selectedOption = null;
    });
  }
}
