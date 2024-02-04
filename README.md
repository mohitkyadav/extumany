# extumany

An application which let's you log and export your exercise data.

## Features
### A user can
1. See a set of preloaded exercises.
2. See a create a new exercise.
3. Specify name, and target areas for the exercises they added.
4. See a set of preloaded target body areas.
5. Start today's session immediately from the first screen.
6. Select the current exercise in the active session.
7. Selected exercise appears on the current session screen.
8. Can log details about a set for any of the selected exercises in the current session.
9. Can log details such as weight, reps and maybe time under tension.
10. Finish the session.
11. See an overview screen with the highlights of each exercise.
12. See a dashboard with details about their past workouts.
13. Select the number of days they want to train per week.
14. Export the data in CSV.
15. Import the data in CSV.

### Post session highlight may contain
1. Good job! Today you hit your highest load of 26 Kg.
2. Great Job! You did one extra set today compared to the last time.
3. Looks like you were not recovered completely. Take a rest day and come back stronger.
4. Absolutely brilliant! You did 6 exercises today. Don't forget to rest.

### The dashboard may contain
1. Total unique exercises done by the user.
2. One random highlight, i.e rep max.
3. Time since last workout.
4. Streak details. At least 'x' times a week.

### Buttons at the bottom app bar
1. Play, to start the workout.
2. Analytics
3. Settings

## Models
### Exercise:
1. `id`: Unique identifier for each exercise.
2. `name`: Name of the exercise.
3. `targetAreas`: List of target body areas (e.g., legs, arms, core) associated with the exercise.

### Target Area:
1. `id`: Unique identifier for each target area.
2. `name`: Name of the target body area (e.g., legs, arms, core).

### WorkoutSession:
1. `id`: Unique identifier for each session.
2. `date`: Date of the session.
3. `exercises`: List of exercises performed during the session.

### ExerciseSet:
1. `id`: Unique identifier for each exercise set.
2. `exerciseId`: Reference to the exercise.
3. `weight`: Weight used (optional).
4. `reps`: Number of repetitions.
5. `timeUnderTension`: Duration of time under tension (optional).

### WorkoutHistory:
1. `id`: Unique identifier for each workout history entry.
2. `date`: Date of the workout.
3. `totalSets`: Total number of sets completed.
4. `totalReps`: Total number of repetitions performed.
5. `totalWeight`: Total weight lifted (optional).

### UserPreferences:
1. `id`: Unique identifier for user preferences.
2. `trainingDaysPerWeek`: Number of days the user wants to train per week.
