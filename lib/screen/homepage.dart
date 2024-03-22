import 'package:doanmobile/bloc/workout_cubit.dart';
import 'package:doanmobile/bloc/workout_cubits.dart';
import 'package:doanmobile/helpers.dart';
import 'package:doanmobile/model/workout.dart';
import 'package:doanmobile/screen/DatePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePages extends StatelessWidget {
  const HomePages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bắt Đầu Nào !'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DatePicker(title: 'DatePicker'),
                ),
              );
            },
            icon: const Icon(Icons.event_available),
          ),
          IconButton(onPressed: null, icon: Icon(Icons.settings))
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<WorkoutCubit, List<Workout>>(
          builder: (context, workouts) {
            if (workouts.isEmpty) {
              // Return a placeholder widget or a loading indicator
              return Center(child: CircularProgressIndicator());
            } else {
              return ExpansionPanelList.radio(
                children: workouts.map((workout) {
                  return ExpansionPanelRadio(
                    value: workout,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        visualDensity: const VisualDensity(horizontal: 0, vertical: VisualDensity.maximumDensity),
                        leading: IconButton(
                          onPressed: () {
                            BlocProvider.of<WorkoutCubits>(context).editWorkout(workout, workouts.indexOf(workout));
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        title: Text(workout.title!),
                        trailing: Text(formatTime(workout.getTotal(), true)),
                        onTap: () => !isExpanded
                            ? BlocProvider.of<WorkoutCubits>(context).startWorkout(workout)
                            : null,
                      );
                    },
                    body: ListView.builder(
                      shrinkWrap: true,
                      itemCount: workout.exercises.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: null,
                          visualDensity: const VisualDensity(horizontal: 0, vertical: VisualDensity.maximumDensity),
                          leading: Text(formatTime(workout.exercises[index].prelude!, true)),
                          title: Text(workout.exercises[index].title!),
                          trailing: Text(formatTime(workout.exercises[index].duration!, true)),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}