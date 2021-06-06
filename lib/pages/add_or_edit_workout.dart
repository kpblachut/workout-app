import 'package:flutter/material.dart';
import 'package:spec_redone/classes/database.dart';
import 'package:spec_redone/pages/add_or_edit_exercise.dart';
import 'dart:math';


class AddOrEditWorkout extends StatefulWidget {
  final bool add;
  final int index; 
  final WorkoutEdit workoutEdit;

  AddOrEditWorkout({Key key, this.add, this.index, this.workoutEdit}) : super(key: key);

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
    _workoutEdit = WorkoutEdit(action: "Cancel", workout: widget.workoutEdit.workout);
    _title = widget.add ? 'Add' : 'Edit';
    _workoutEdit.workout = widget.workoutEdit.workout;
    

    if (widget.add) {
      _workoutTitleControler.text = "";
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

  void _addOrEditExercise({bool add, int index, Exercise exercise}) async {
    ExerciseEdit _exerciseEdit = ExerciseEdit(action: "", exercise: exercise);
    _exerciseEdit = await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddOrEditExercise(
          add: add,
          index: index,
          exerciseEdit: _exerciseEdit,
        )
      )
    );
    switch(_exerciseEdit.action) {
      case 'Save': 
        if(add) {
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
        // TODO: Change to TextField
        title: Text("$_title Workout"),
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
                name: "Workout#$_id",
                exercises: _exercises,
              );
              Navigator.pop(context, _workoutEdit);
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _workoutEdit.action = 'Cancel';
              Navigator.pop(context, _workoutEdit);
            },
          )
        ],
      ),
      body: _exercises.isEmpty 
        ? Center(child: Text("No exercises yet..."),)
        : ListView.separated(
            itemCount: _exercises.length,
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey
              );
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
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.deepOrange
                    ),
                  ),
                  title: Text(
                    _exercises[index].name,
                  ),
                  subtitle: Text("Sets: ${_exercises[index].sets}"),
                  onTap: () {
                    _addOrEditExercise(add: false, index: index, exercise: _exercises[index]);
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
          _addOrEditExercise(add: true, index: -1, exercise: Exercise());
        },
      ),
    );
  }
}