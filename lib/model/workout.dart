import 'package:doanmobile/model/exercises.dart';
import 'package:equatable/equatable.dart';

class Workout extends Equatable {
  final String? title;
  final List<Exercises> exercises;
  
  const Workout({required this.title, required this.exercises});
  factory Workout.fromJson(Map<String, dynamic> json) {
    List<Exercises> exercises = [];
    int index = 0;
    int startTime = 0;
    for (var ex in json['exercises'] as Iterable) {
      exercises.add(Exercises.fromJson(ex, index, startTime));
      index++;
      startTime == exercises.last.duration!;
    }
    return Workout(
      title: json['title'],
      exercises: exercises,
    );
  }
  Map<String, dynamic> toJson() => {
    'title': title,
    'exercises': exercises.map((ex) => ex.toJson()).toList(),
  };

  Workout copyWith({String? title, List<Exercises>? exercises}) =>
      Workout(
        title: title ?? this.title,
        exercises: exercises ?? this.exercises,
      );

  int getTotal() => exercises.fold(0, (prev, ex) => prev + ex.duration!);

  Exercises getCurrentExercise(int? elapsed) =>
      exercises.lastWhere((element) => element.startTime! <= elapsed!);

  @override
  List<Object?> get props => [title, exercises];

  @override
  bool get stringify => true;
}