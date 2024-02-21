import 'package:extumany/db/models/models.dart';
import 'package:flutter/material.dart';

class WorkoutEditor extends StatefulWidget {
  const WorkoutEditor({super.key, required this.workout, this.successCallback});

  final Workout workout;
  final void Function()? successCallback;

  @override
  State<WorkoutEditor> createState() => _WorkoutEditorState();
}

class _WorkoutEditorState extends State<WorkoutEditor> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit_rounded),
      onPressed: () => _showEditWorkoutForm(context, widget.workout),
    );
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
    }
    final updatedWorkout = Workout(
      id: workout.id,
      title: _title,
      description: _description,
    );

    updatedWorkout.persistInDb().then((newWorkoutId) {
      if (widget.successCallback != null) {
        widget.successCallback!();
      }

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
}
