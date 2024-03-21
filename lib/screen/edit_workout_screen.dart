

import 'package:doanmobile/bloc/workout_cubit.dart';
import 'package:doanmobile/bloc/workout_cubits.dart';
import 'package:doanmobile/helpers.dart';
import 'package:doanmobile/model/exercises.dart';
import 'package:doanmobile/model/workout.dart';
import 'package:doanmobile/screen/edit_exercise_screen.dart';
import 'package:doanmobile/states/workout_states.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditWorkoutScreen extends StatelessWidget {
  const EditWorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: BlocBuilder<WorkoutCubits, WorkoutState>(
          builder: (context, state) {
            WorkoutEditing we = state as WorkoutEditing;
            return Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () =>
                      BlocProvider.of<WorkoutCubits>(context).goHome(),
                ),
                title: InkWell(
                  child: Text(we.workout!.title!),
                  onTap: () => showDialog(
                      context: context,
                      builder: (_) {
                        final controller =
                            TextEditingController(text: we.workout!.title);
                        return AlertDialog(
                          content: TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                                labelText: "Tiêu đề tập luyện"),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  if (controller.text.isNotEmpty) {
                                    Navigator.pop(context);
                                    Workout rename = we.workout!
                                        .copyWith(title: controller.text);
                                    BlocProvider.of<WorkoutCubit>(context)
                                        .SaveWorkout(rename, we.index);
                                    BlocProvider.of<WorkoutCubits>(context)
                                        .editWorkout(rename, we.index);
                                  }
                                },
                                child: const Text("Thay Đổi"))
                          ],
                        );
                      }),
                ),
              ),
              body: ListView.builder(
                  itemCount: we.workout!.exercises.length,
                  itemBuilder: (context, index) {
                    Exercises exercises = we.workout!.exercises[index];

                    if (we.exIndex == index) {
                      return EditExerciseScreen(
                          workout: we.workout,
                          index: we.index,
                          exIndex: we.exIndex);
                    } else {
                      return ListTile(
                          leading: Text(fortmatTime(exercises.prelude!, true)),
                          title: Text(exercises.title!),
                          trailing:
                              Text(fortmatTime(exercises.duration!, true)),
                          onTap: () => BlocProvider.of<WorkoutCubits>(context)
                              .editExercise(index));
                    }
                  }),
            );
          },
        ),
        onWillPop: () => BlocProvider.of<WorkoutCubits>(context).goHome());
  }
}
