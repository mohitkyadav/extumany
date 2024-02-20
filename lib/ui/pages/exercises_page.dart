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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Your exercises'),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: const [
          ExerciseBoxItem(),
          ExerciseBoxItem(),
          ExerciseBoxItem(),
        ],
      ),
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
      print(newExerciseId);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Exercise saved successfully!'),
          duration: Duration(seconds: 2), // Adjust the duration as needed
        ),
      );
    });
  }
}

class ExerciseBoxItem extends StatelessWidget {
  const ExerciseBoxItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'Box Item',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}