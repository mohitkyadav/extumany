import 'package:extumany/db/models/models.dart';
import 'package:flutter/material.dart';
import 'package:animate_gradient/animate_gradient.dart';

class StartWorkoutPage extends StatefulWidget {
  const StartWorkoutPage({super.key});

  static const routeName = '/play';

  @override
  State<StartWorkoutPage> createState() => _StartWorkoutPageState();
}

class _StartWorkoutPageState extends State<StartWorkoutPage> {
  bool _isWorkoutFetched = false;
  late Workout _workout;

  @override
  Widget build(BuildContext context) {
    final workoutId = ModalRoute.of(context)!.settings.arguments as int;

    if (!_isWorkoutFetched) {
      _loadWorkout(workoutId);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
            _isWorkoutFetched ? _workout.title : 'Fetching workout details'),
      ),
      body: _buildWorkoutDetails(),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        surfaceTintColor: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _isWorkoutFetched
                ? TextButton.icon(
                    onPressed: () => {},
                    icon: const Icon(
                      Icons.stop_circle_rounded,
                      size: 24,
                    ),
                    label: const Text('Stop and save'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red.shade400,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutDetails() {
    if (!_isWorkoutFetched) {
      return const LinearProgressIndicator();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInfoSection(),
        _buildExercises(),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: AnimateGradient(
            primaryBegin: Alignment.topLeft,
            primaryEnd: Alignment.bottomLeft,
            secondaryBegin: Alignment.bottomLeft,
            secondaryEnd: Alignment.topRight,
            primaryColors: const [
              Color.fromRGBO(112, 241, 172, 0.4),
              Color.fromRGBO(112, 241, 172, 0.6),
            ],
            secondaryColors: const [
              Color.fromRGBO(106, 80, 239, 0.4),
              Color.fromRGBO(106, 80, 239, 0.6),
            ],
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text('Workout In Progress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                    ..._workout.description != null
                        ? [
                            const SizedBox(height: 10),
                            Text(_workout.description!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                )),
                          ]
                        : [const SizedBox(height: 0)],
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 24,
                color: Colors.grey,
              ),
              SizedBox(width: 16),
              Flexible(
                child: Text(
                  'Click on the plus button to add log a set for each exercise',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExercises() {
    if (_workout.exercises.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16).copyWith(top: 28),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        height: 300,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.dangerous_rounded,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 12),
              Text(
                '0 exercises',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  'You need to add exercises to this workout to start logging',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _workout.exercises.length,
        itemBuilder: (BuildContext context, int index) {
          final exercise = _workout.exercises[index];
          return ListTile(
            title: Text(exercise.title,
                style: const TextStyle(fontSize: 18, color: Colors.white)),
            subtitle: Text(exercise.description ?? 'No description',
                style: TextStyle(color: Colors.white.withOpacity(0.8))),
            trailing: const Icon(Icons.add_rounded, color: Colors.white),
          );
        },
      ),
    );
  }

  Future<void> _loadWorkout(int id) async {
    final workout = await Workout.getOneWorkoutWithExercises(id);

    setState(() {
      _isWorkoutFetched = true;
      _workout = workout;
    });
  }
}
