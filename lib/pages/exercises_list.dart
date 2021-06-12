import 'package:flutter/material.dart';
import 'package:spec_redone/classes/exercice_db.dart';
import 'package:spec_redone/models/exercise_model.dart';


class ExerciseListPage extends StatefulWidget {
  ExerciseListPage({Key key}) : super(key: key);

  @override
  _ExerciseListPageState createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  ExercisesDB _database;

  Future<List<Exercise>> _loadWorkouts() async {
    await ExerciseDBFilesRoutine().readExercises().then((json) {
      _database = databaseFromJson(json);
    });
    return _database.workout;
  }

  _addExercise() async {
    // TODO: Add _addExercise controller
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Create Layout for ExerciseListPage 
    return Container(
       child: null,
    );
  }
}