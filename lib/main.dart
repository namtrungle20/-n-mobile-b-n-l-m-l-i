import 'package:doanmobile/bloc/Login/bloc/login_bloc.dart';
import 'package:doanmobile/bloc/Login/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/workout_cubit.dart';
import 'bloc/workout_cubits.dart';
import 'screen/edit_workout_screen.dart';
import 'screen/homepage.dart';
import 'screen/login_screen.dart';
import 'states/workout_states.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  HydratedBlocOverrides.runZoned(() => runApp(const WorkoutTime()),
      storage: storage);
}

class WorkoutTime extends StatelessWidget {
  const WorkoutTime({Key? key}) : super(key: key);

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
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(),
          ),
          BlocProvider<WorkoutCubit>(
            create: (BuildContext context) {
              WorkoutCubit workoutCubit = WorkoutCubit();
              if (workoutCubit.state.isEmpty) {
                workoutCubit.getWorkouts();
              }
              return workoutCubit;
            },
          ),
          BlocProvider<WorkoutCubits>(
            create: (BuildContext context) => WorkoutCubits(),
          ),
        ],
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginSuccess) {
              return const HomePages();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}