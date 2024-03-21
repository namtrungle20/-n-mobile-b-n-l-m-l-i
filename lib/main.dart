import 'package:doanmobile/bloc/workout_cubit.dart';
import 'package:doanmobile/bloc/workout_cubits.dart';
import 'package:doanmobile/model/workout.dart';
import 'package:doanmobile/screen/edit_workout_screen.dart';
import 'package:doanmobile/screen/homepage.dart';
import 'package:doanmobile/screen/workout_in_progress.dart';
import 'package:doanmobile/states/workout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  HydratedBlocOverrides.runZoned(() => runApp(const WorkoutTime()),
      storage: storage);
}

class WorkoutTime extends StatelessWidget {
  const WorkoutTime({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Tập Thể Dục',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyText2: TextStyle(color: Colors.blueAccent),
        ),
      ),
      home: MultiBlocProvider(
          providers: [
            BlocProvider<WorkoutCubit>(create: (BuildContext context) {
              WorkoutCubit workoutCubit = WorkoutCubit();
              if (workoutCubit.state.isEmpty) {
                workoutCubit.getWorkouts();
              }
              return workoutCubit;
            }),
            BlocProvider<WorkoutCubits>(
                create: (BuildContext context) => WorkoutCubits())
          ],
          child: BlocBuilder<WorkoutCubits, WorkoutState>(
            builder: (context, state) {
              if (state is WorkoutInitial) {
                return const HomePages();
              } else if (state is WorkoutEditing) {
                return const EditWorkoutScreen();
              }
              return const WorkoutProgress();
            },
          )),
    );
  }
}
