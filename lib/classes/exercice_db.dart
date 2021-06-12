import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:spec_redone/models/exercise_model.dart';

class ExerciseDBFilesRoutine {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/exercises_test.json');
  }

  Future<String> readExercises() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        print("File does not Exist: ${file.absolute}");
        await writeExercises('{"exercises": []}');
      }
      String contents = await file.readAsString();
      return contents;
      } catch (e) {
        print("error readExercises: $e");
        return "";
      }
  }

  Future<File> writeExercises(String json) async {
    final file = await _localFile;

    return file.writeAsString('$json');
  }
}

ExercisesDB databaseFromJson(String str) {
  final dataFromJson = json.decode(str);
  return ExercisesDB.fromJson(dataFromJson);
}

String databaseToJson(ExercisesDB data) {
  final dataToJson = data.toJson();
  return json.encode(dataToJson);
}


class ExercisesDB {
  List<Exercise> workout;
  ExercisesDB({this.workout});
  factory ExercisesDB.fromJson(Map<String, dynamic> json) => ExercisesDB(
        workout: List<Exercise>.from(
            json["exercises"].map((x) => Exercise.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {"exercises": List<dynamic>.from(workout.map((x) => x.toJson()))};
}