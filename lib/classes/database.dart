import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class DatabaseFileRoutines {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/local_persistence.json');
  }

  Future<String> readWorkouts() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        print("File does not Exist: ${file.absolute}");
        await writeWorkouts('{"workouts": []}');
      }
      String contents = await file.readAsString();
      return contents;
      } catch (e) {
        print("error readWorkouts: $e");
        return "";
      }
    }

  Future<File> writeWorkouts(String json) async {
    final file = await _localFile;

    return file.writeAsString('$json');
  }
}

Database databaseFromJson(String str) {
  final dataFromJson = json.decode(str);
  return Database.fromJson(dataFromJson);
}

String databaseToJson(Database data) {
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}

class Database {
  List<Workout> workout;
  Database({this.workout});
  factory Database.fromJson(Map<String, dynamic> json) => Database(
        workout: List<Workout>.from(
            json["workouts"].map((x) => Workout.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {"workouts": List<dynamic>.from(workout.map((x) => x.toJson()))};
}

class Workout {
  String id;
  String name;
  List<Exercise> exercises;
  

  Workout({this.id, this.name, this.exercises});

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
      id: json['id'],
      name: json['name'],
      exercises: new List<Exercise>.from(json["exercises"].map((x) => Exercise.fromJson(x)))
    );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'exercises': new List<dynamic>.from(exercises.map((x) => x.toJson()))
      };
}

class Exercise {
  String id;
  String name;
  String sets;

  Exercise({
    this.id, this.sets, this.name
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => new Exercise(
    id: json['id'],
    name: json['name'],
    sets: json['sets']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "sets": sets
  };
}

class WorkoutEdit {
  String action;
  Workout workout;

  WorkoutEdit({this.action, this.workout});
}

class ExerciseEdit {
  String action;
  Exercise exercise;

  ExerciseEdit({this.action, this.exercise});
}