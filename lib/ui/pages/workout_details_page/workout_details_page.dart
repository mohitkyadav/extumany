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
  int? _selectedOption;

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
                Container(
                  margin:
                      const EdgeInsets.all(16).copyWith(bottom: 14, top: 22),
                  child: Text(
                    '${_workout.exercises.length} Exercises in this workout',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
                _buildExercises(),
              ],
            ),
      bottomNavigationBar: BottomAppBar(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        _buildAddExerciseButton(workoutId),
        _buildDeleteButton(),
      ])),
    );
  }

  Widget _buildAddExerciseButton(int workoutId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton.icon(
          onPressed: () => _showAddExerciseDialog(workoutId),
          icon: const Icon(Icons.add),
          label: const Text('Exercise'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          )),
    );
  }

  void _showAddExerciseDialog(int workoutId) {
    List<String> exerciseItems = _unselectedExercises
        .map((exercise) => exercise.title)
        .toList(growable: false);
    List<int?> exerciseItemsIds = _unselectedExercises
        .map((exercise) => exercise.id)
        .toList(growable: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: const EdgeInsets.only(top: 20, bottom: 10),
            child: DropdownButton<int>(
              hint: const Text('Select an exercise'),
              padding: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(10),
              value: _selectedOption,
              // value: _selectedOption != null ? _workout.exercises[int.parse(selectedOption!)].title : null,
              onChanged: (int? newValue) {
                print(newValue);
                setState(() {
                  _selectedOption = newValue!;
                });
                print(_workout.exercises[_selectedOption!].title);
              },
              elevation: 0,
              isExpanded: true,
              items: exerciseItems
                  .asMap()
                  .entries
                  .map<DropdownMenuItem<int>>((entry) {
                final index = entry.key;
                final title = entry.value;
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(title),
                );
              }).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final exerciseId = exerciseItemsIds[_selectedOption!];
                _addExerciseToWorkout(workoutId, exerciseId!).then((value) {
                  _loadWorkout(workoutId);
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addExerciseToWorkout(int workoutId, int exerciseId) async {
    final newWorkoutExercise =
        WorkoutExercise(workoutId: workoutId, exerciseId: exerciseId);
    await newWorkoutExercise.persistInDb();
  }

  Widget _buildDeleteButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton.icon(
        onPressed: () => _deleteWorkout(_workout.id),
        icon: const Icon(Icons.delete_forever_rounded),
        label: const Text('Workout'),
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }

  void _deleteWorkout(int? id) {
    if (id == null) return;

    Workout.delete(id).then((value) => Navigator.of(context).pop());
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
              style: TextStyle(fontSize: 18),
            ),
            title: Text(exercise.title,
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
