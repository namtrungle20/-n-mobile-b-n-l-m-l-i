import 'dart:convert';

import 'package:doanmobile/model/exercises.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:http/http.dart' as http;

import '../model/workout.dart';

class WorkoutCubit extends HydratedCubit<List<Workout>> {
  WorkoutCubit() : super([]);

  Future<void> getWorkouts() async {
  final List<Workout> workouts = [];
  try {
    final response1 = await http.get(Uri.parse('http://10.0.2.2:3000/1'));
    final response2 = await http.get(Uri.parse('http://10.0.2.2:3000/2'));
    if (response1.statusCode == 200 && response2.statusCode == 200) {
      final dynamic data1 = jsonDecode(response1.body);
      final dynamic data2 = jsonDecode(response2.body);
      print('API Response: $data1');
      print('API Response: $data2');
      // Check if the data1 contains 'title' field
      if (data1 is Map<String, dynamic> && data1.containsKey('title')) {
        workouts.add(Workout.fromJson(data1));
      }
      // Check if the data2 contains 'title' field
      if (data2 is Map<String, dynamic> && data2.containsKey('title')) {
        workouts.add(Workout.fromJson(data2));
      }
      emit(workouts);
    } else {
      // Handle error response
      print('Failed to load workouts: ${response1.statusCode}');
      print('Failed to load workouts: ${response2.statusCode}');
    }
  } catch (e) {
    // Handle error
    print('Failed to load workouts: $e');
  }
}

  SaveWorkout(Workout workout, int index) {
    Workout newWorkout = Workout(exercises: [], title: workout.title);
    int exIndex = 0;
    int startTime = 0;
    for (var ex in workout.exercises) {
      newWorkout.exercises.add(Exercises(
          title: ex.title,
          prelude: ex.prelude,
          duration: ex.duration,
          index: ex.index,
          startTime: ex.startTime));
      exIndex++;
      startTime += ex.prelude! + ex.duration!;
    }
    state[index] = newWorkout;
    emit([...state]);
  }

  @override
  List<Workout>? fromJson(Map<String, dynamic> json) {
    if (json.containsKey('workouts')) {
      return (json['workouts'] as List<dynamic>)
          .map((el) => Workout.fromJson(el))
          .toList();
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(List<Workout> state) {
    if (state is List<Workout>) {
      return {'workouts': state.map((workout) => workout.toJson()).toList()};
    }
    return null;
  }
}
