import 'package:flutter/material.dart';
import 'package:spec_redone/classes/database.dart';
import 'package:intl/intl.dart';
import 'package:spec_redone/models/exercise_model.dart';
import 'package:spec_redone/models/workout_model.dart';
import 'package:spec_redone/pages/add_or_edit_workout.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Database _database;

  Future<List<Workout>> _loadWorkouts() async {
    await DatabaseFileRoutines().readWorkouts().then((json) {
      _database = databaseFromJson(json);
    });
    return _database.workout;
  }

  void _addOrEditWorkout({bool add, int index, Workout workout}) async {
    WorkoutEdit _workoutEdit = WorkoutEdit(action: "Cancel", workout: workout);
    _workoutEdit = await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddOrEditWorkout(
          add: add,
          index: index,
          workoutEdit: _workoutEdit,
        )
      )
    );
    switch(_workoutEdit.action) {
      case 'Save': 
        if(add) {
          setState(() {
            _database.workout.add(_workoutEdit.workout);
          });
        } else {
          setState(() {
            _database.workout[index] = _workoutEdit.workout;
          });
        }
        DatabaseFileRoutines().writeWorkouts(databaseToJson(_database));
        break;
      case 'Cancel':
        break;
      default:
        break;
    }
  }

  Widget _buildWorkoutList(AsyncSnapshot snapshot) {
     
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          List<Exercise> _tempExercises = snapshot.data[index].exercises;
          String _description = "";
          _tempExercises.forEach((element) { 
            _description += "\u2022 " + element.name + "\n";
          });

          return Dismissible(
            key: Key(snapshot.data[index].id),
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
            child: Card(
              color: Colors.grey.shade900,
              child: ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.accessibility,
                      color: Colors.deepOrange,
                      size: 34.0,
                    ),
                  ],
                ),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    snapshot.data[index].name,
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
                subtitle: Text(
                  _description,
                  style: TextStyle(
                    color: Colors.white60
                  ),
                ),
                onTap: () {
                  _addOrEditWorkout(add: false, index: index, workout: snapshot.data[index]);
                },
              ),
            ),
            onDismissed: (direction) {
                setState(() {
                  _database.workout.removeAt(index);
                });
                DatabaseFileRoutines().writeWorkouts(databaseToJson(_database));
              },
          );
        },
        itemCount: snapshot.data.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 8.0,
        child: Icon(Icons.add),
        onPressed: () {
          _addOrEditWorkout(add: true, index: -1, workout: Workout());
        },
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        elevation: 8.0,
        child: Container(
          color: Colors.deepOrange,
          height: 50.0,
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          initialData: [],
          future: _loadWorkouts(),
          builder: (context, snapshot) {
            return !snapshot.hasData
              ? Center(
                child: CircularProgressIndicator()
              )
              : _buildWorkoutList(snapshot);
          },
        ),
      ),
    );
  }
}