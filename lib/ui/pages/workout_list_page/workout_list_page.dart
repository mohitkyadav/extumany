import 'package:extumany/db/models/models.dart';
import 'package:extumany/ui/pages/workout_list_page/workout_list.dart';
import 'package:flutter/material.dart';

class WorkoutListPage extends StatefulWidget {
  const WorkoutListPage({super.key});

  static const routeName = '/workouts';

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
      body: _buildCustomScrollView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateWorkoutForm(context),
        tooltip: 'Create new workout',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCustomScrollView() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text(
            'Your workouts',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          floating: true,
          snap: true,
          expandedHeight: 80,
          actions: [
            IconButton(
              onPressed: () => _loadWorkouts(),
              icon: const Icon(Icons.refresh),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(255, 204, 153, 0.4),
                    Color.fromRGBO(255, 102, 102, 0.5),
                  ],
                ),
              ),
            ),
          ),
        ),
        _isLoading
            ? const SliverToBoxAdapter(
                child: LinearProgressIndicator(),
              )
            : WorkoutList(
                workouts: workouts,
                deleteWorkout: _deleteWorkout,
                loadWorkouts: _loadWorkouts,
              ),
      ],
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

  Future<void> _loadWorkouts() async {
    setState(() {
      _isLoading = true;
    });
    List<Workout> loadedWorkouts = await Workout.getAll();
    await Future.delayed(const Duration(milliseconds: 800));
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
