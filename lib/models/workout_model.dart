import 'exercise_model.dart';

class Workout {
  String id;
  String name;
  List<Exercise> exercises;

  Workout({this.id, this.name, this.exercises});

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
      id: json['id'],
      name: json['name'],
      exercises: new List<Exercise>.from(
          json["exercises"].map((x) => Exercise.fromJson(x))));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'exercises': new List<dynamic>.from(exercises.map((x) => x.toJson()))
      };
}

class WorkoutEdit {
  String action;
  Workout workout;

  WorkoutEdit({this.action, this.workout});
}
