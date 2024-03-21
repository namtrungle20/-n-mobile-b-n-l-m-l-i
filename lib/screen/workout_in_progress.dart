import 'package:doanmobile/bloc/workout_cubits.dart';
import 'package:doanmobile/helpers.dart';
import 'package:doanmobile/model/exercises.dart';
import 'package:doanmobile/model/workout.dart';
import 'package:doanmobile/states/workout_states.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkoutProgress extends StatelessWidget {
  const WorkoutProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _getStats(Workout workout, int workoutElapsed) {
      int workoutTotal = workout.getTotal();
      Exercises exercises = workout.getCurrentExercise(workoutElapsed);
      int exercisesElapsed = workoutElapsed - exercises.startTime!;

      int exercisesRemaining = exercises.prelude! - exercisesElapsed;
      bool isPrelude = exercisesElapsed < exercises.prelude!;
      int exercisesTotal = isPrelude ? exercises.prelude! : exercises.duration!;

      if (!isPrelude) {
        exercisesElapsed -= exercises.prelude!;
        exercisesRemaining += exercises.duration!;
      }

      return {
        "workoutTitle": workout.title,
        "workoutProgress": workoutElapsed/workoutTotal,
        "workoutElapsed": workoutElapsed,
        "totalExercise": workout.exercises.length,
        "currentExecireIndex": exercises.index!.toDouble(),
        "workoutRemaining": workoutTotal - workoutElapsed,
        "execireRemaining": exercisesRemaining,
        "execireProgress": exercisesElapsed/exercisesTotal,
        "isPrelude": isPrelude
      };
    }

    return BlocConsumer<WorkoutCubits, WorkoutState>(
      builder: (context, state) {
        final stats = _getStats(state.workout!, state.elapsed!);
        return Scaffold(
          appBar: AppBar(
            title: Text(state.workout!.title.toString()),
            leading: BackButton(
              onPressed: () => BlocProvider.of<WorkoutCubits>(context).goHome(),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                LinearProgressIndicator(
                  backgroundColor: Colors.blue[100],
                  minHeight: 10,
                  value: stats['workoutProgress'],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(fortmatTime(stats["workoutElapsed"], true)),
                      DotsIndicator(
                        dotsCount: stats['totalExercise'],
                        position: stats['currentExecireIndex'].toInt(),
                      ),
                      Text('-${fortmatTime(stats["workoutRemaining"], true)}')
                    ],
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap:(){
                    if(state is WorkoutInProgress){
                      BlocProvider.of<WorkoutCubits>(context).pauseWorkout();
                    }else if(state is WorkoutPaused){
                       BlocProvider.of<WorkoutCubits>(context).resumeWorkout();
                    }
                  },
                  child: Stack(
                    alignment: const Alignment(0, 0),
                    children: [
                      Center(
                        child: SizedBox(
                          height: 220,
                          width: 220,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                stats['isPrelude'] ? Colors.red : Colors.blue),
                            strokeWidth: 25,
                            value: stats['exerciseProgress'],
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Image.asset('assets/stopwatch.png'),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
