import 'package:doanmobile/bloc/workout_cubit.dart';
import 'package:doanmobile/helpers.dart';
import 'package:doanmobile/model/workout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';

class EditExerciseScreen extends StatefulWidget {
  final Workout? workout;
  final int index;
  final int? exIndex;
  const EditExerciseScreen({
    Key? key,
    this.workout,
    this.exIndex,
    required this.index,
  }) : super(key: key);

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  TextEditingController? _title;

  @override
  void initState() {
    _title = TextEditingController(
        text: widget.workout!.exercises[widget.exIndex!].title);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: InkWell(
              onLongPress: () => showDialog(
                  context: context,
                  builder: (_) {
                    final controller = TextEditingController(
                        text: widget.workout!.exercises[widget.exIndex!].prelude
                            .toString());
                    return AlertDialog(
                      content: TextField(
                        controller: controller,
                        decoration:
                            const InputDecoration(labelText: "Khởi đầu (s)"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                Navigator.pop(context);
                                setState(() {
                                  widget.workout!.exercises[widget.exIndex!] =
                                      widget.workout!.exercises[widget.exIndex!]
                                          .copyWith(
                                    prelude: int.parse(
                                      controller.text
                                    ),
                                  );
                                  BlocProvider.of<WorkoutCubit>(context)
                                      .SaveWorkout(
                                          widget.workout!, widget.index);
                                });
                              }
                            },
                            child: const Text("Lưu"))
                      ],
                    );
                  }),
              child: NumberPicker(
                itemHeight: 25,
                value: widget.workout!.exercises[widget.exIndex!].prelude!,
                minValue: 0,
                maxValue: 1000,
                textMapper: (strVal) => fortmatTime(int.parse(strVal), false),
                onChanged: (value) => setState(() {
                  widget.workout!.exercises[widget.exIndex!] =
                      widget.workout!.exercises[widget.exIndex!].copyWith(
                    prelude: value,
                  );
                  BlocProvider.of<WorkoutCubit>(context)
                      .SaveWorkout(widget.workout!, widget.index);
                }),
              ),
            )),
            Expanded(
                child: TextField(
              textAlign: TextAlign.center,
              controller: _title,
              onChanged: (value) => setState(() {
                widget.workout!.exercises[widget.exIndex!] =
                    widget.workout!.exercises[widget.exIndex!].copyWith(
                  title: value,
                );
                BlocProvider.of<WorkoutCubit>(context)
                    .SaveWorkout(widget.workout!, widget.index);
              }),
            )),
            Expanded(
                child: InkWell(
              onLongPress: () => showDialog(
                  context: context,
                  builder: (_) {
                    final controller = TextEditingController(
                        text: widget.workout!.exercises[widget.exIndex!].duration
                            .toString());
                    return AlertDialog(
                      content: TextField(
                        controller: controller,
                        decoration:
                            const InputDecoration(labelText: "Khởi đầu (s)"),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                Navigator.pop(context);
                                setState(() {
                                  widget.workout!.exercises[widget.exIndex!] =
                                      widget.workout!.exercises[widget.exIndex!]
                                          .copyWith(
                                    duration: int.parse(
                                      controller.text
                                    ),
                                  );
                                  BlocProvider.of<WorkoutCubit>(context)
                                      .SaveWorkout(
                                          widget.workout!, widget.index);
                                });
                              }
                            },
                            child: const Text("Lưu"))
                      ],
                    );
                  }),
              child: NumberPicker(
                itemHeight: 25,
                value: widget.workout!.exercises[widget.exIndex!].duration!,
                minValue: 0,
                maxValue: 1000,
                textMapper: (strVal) => fortmatTime(int.parse(strVal), false),
                onChanged: (value) => setState(() {
                  widget.workout!.exercises[widget.exIndex!] =
                      widget.workout!.exercises[widget.exIndex!].copyWith(
                    duration: value,
                  );
                  BlocProvider.of<WorkoutCubit>(context)
                      .SaveWorkout(widget.workout!, widget.index);
                }),
              ),
            )),
          ],
        )
      ],
    );
  }
}
