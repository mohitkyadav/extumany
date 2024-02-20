import 'package:extumany/ui/pages/exercise_page/exercise_list.dart';
import 'package:flutter/material.dart';
import 'package:extumany/db/models/exercise.dart';


class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _link = '';
  List<Exercise> exercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    List<Exercise> loadedExercises = await Exercise.getAll();
    setState(() {
      exercises = loadedExercises;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Your exercises'),
      ),
      body: ExerciseList(exercises: exercises, deleteExercise: _deleteExercise),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddExerciseForm(context);
        },
        tooltip: 'Add new exercise',
        child: const Icon(Icons.add),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  void _showAddExerciseForm(BuildContext context) {
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
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Link',
                    ),
                    onSaved: (value) => _link = value!,
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
    final exercise = Exercise(
        title: _title,
        description: _description,
        link: _link);

    exercise.persistInDb().then((newExerciseId) {
      _loadExercises();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exercise saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _deleteExercise(int id) {
    Exercise.delete(id).then((_) {
      _loadExercises();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exercise deleted successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
}

