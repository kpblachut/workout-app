import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spec_redone/classes/database.dart';
import 'package:spec_redone/models/exercise_model.dart';
import 'package:spec_redone/models/workout_model.dart';
import 'package:spec_redone/pages/add_or_edit_exercise.dart';
import 'dart:math';

import 'package:spec_redone/pages/exercises_list.dart';

class AddOrEditWorkout extends StatefulWidget {
  final bool add;
  final int index;
  final WorkoutEdit workoutEdit;

  AddOrEditWorkout({Key key, this.add, this.index, this.workoutEdit})
      : super(key: key);

  @override
  _AddOrEditWorkoutState createState() => _AddOrEditWorkoutState();
}

class _AddOrEditWorkoutState extends State<AddOrEditWorkout> {
  WorkoutEdit _workoutEdit;
  String _title;
  List<Exercise> _exercises;
  TextEditingController _workoutTitleControler = TextEditingController();

  @override
  void initState() {
    super.initState();
    _workoutEdit =
        WorkoutEdit(action: "Cancel", workout: widget.workoutEdit.workout);
    _title = widget.add ? 'New Workout' : 'Edit ${_workoutEdit.workout.name}';
    _workoutEdit.workout = widget.workoutEdit.workout;

    if (widget.add) {
      _workoutTitleControler.text = "New Workout";
      _exercises = [];
    } else {
      _workoutTitleControler.text = _workoutEdit.workout.name;
      _exercises = widget.workoutEdit.workout.exercises;
    }
  }

  @override
  void dispose() {
    _workoutTitleControler.dispose();
    super.dispose();
  }

  void _addExercise({Exercise exercise}) async {
    ExerciseEdit _exerciseEdit = ExerciseEdit(action: "", exercise: exercise);

    _exerciseEdit = await Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => ExerciseListPage(
            exerciseEdit: _exerciseEdit,
          ),
        ));
  }

  void _editExercise({int index, Exercise exercise}) async {
    ExerciseEdit _exerciseEdit =
        ExerciseEdit(action: "Cancel", exercise: exercise);

    _exerciseEdit = await Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => AddOrEditExercise(
                  add: false,
                  index: index,
                  exerciseEdit: _exerciseEdit,
                )));

    switch (_exerciseEdit.action) {
      case 'Save':
        _exercises[index] = _exerciseEdit.exercise;
        break;
      case 'Cancel':
        break;
      default:
        break;
    }
  }

  void _addOrEditExercise({bool add, int index, Exercise exercise}) async {
    ExerciseEdit _exerciseEdit =
        ExerciseEdit(action: "Cancel", exercise: exercise);
    _exerciseEdit = await Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => AddOrEditExercise(
                  add: add,
                  index: index,
                  exerciseEdit: _exerciseEdit,
                )));
    switch (_exerciseEdit.action) {
      case 'Save':
        if (add) {
          setState(() {
            _exercises.add(_exerciseEdit.exercise);
          });
        } else {
          _exercises[index] = _exerciseEdit.exercise;
        }
        break;
      case 'Cancel':
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Workout title tetxfield
        title: TextField(
          style: TextStyle(color: Colors.white, fontSize: 18.0),
          controller: _workoutTitleControler,
          inputFormatters: [LengthLimitingTextInputFormatter(32)],
          decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _workoutEdit.action = 'Save';
              String _id = widget.add
                  ? Random().nextInt(9999999).toString()
                  : _workoutEdit.workout.id;
              _workoutEdit.workout = Workout(
                id: _id,
                name: _workoutTitleControler.text,
                exercises: _exercises,
              );
              Navigator.pop(context, _workoutEdit);
            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _workoutEdit.action = 'Cancel';
              Navigator.pop(context, _workoutEdit);
            },
          )
        ],
      ),
      body: _exercises.isEmpty
          ? Center(
              child: Text("No exercises yet..."),
            )
          : ListView.separated(
              itemCount: _exercises.length,
              separatorBuilder: (context, index) {
                return Divider(color: Colors.grey);
              },
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_exercises[index].id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  secondaryBackground: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: ListTile(
                    leading: Text(
                      "${index + 1}.",
                      style:
                          TextStyle(fontSize: 20.0, color: Colors.deepOrange),
                    ),
                    title: Text(
                      _exercises[index].name,
                    ),
                    subtitle: Text("Sets: ${_exercises[index].sets}"),
                    onTap: () {
                      _addOrEditExercise(
                          add: false,
                          index: index,
                          exercise: _exercises[index]);
                    },
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _exercises.removeAt(index);
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _addExercise(exercise: Exercise());
        },
      ),
    );
  }
}
