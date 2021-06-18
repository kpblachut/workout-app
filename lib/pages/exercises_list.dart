import 'package:flutter/material.dart';
import 'package:spec_redone/classes/exercice_db.dart';
import 'package:spec_redone/models/exercise_model.dart';
import 'package:spec_redone/pages/add_or_edit_exercise.dart';

class ExerciseListPage extends StatefulWidget {
  ExerciseListPage({Key key}) : super(key: key);

  @override
  _ExerciseListPageState createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  ExercisesDB _database;
  ExerciseEdit _exerciseEdit;

  Future<List<Exercise>> _loadExercises() async {
    await ExerciseDBFilesRoutine().readExercises().then((json) {
      _database = databaseFromJson(json);
    });
    return _database.exercises;
  }

  void _addOrEditExercise({bool add, int index, Exercise exercise}) async {
    ExerciseEdit _exerciseEdit = ExerciseEdit(action: "Cancel", exercise: exercise);

    _exerciseEdit = await Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => AddOrEditExercise(
            add: add,
            index: index,
            exerciseEdit: _exerciseEdit,
          ),
        ));

    switch (_exerciseEdit.action) {
      case 'Save':
        if (add) {
          setState(() {
          _database.exercises.add(_exerciseEdit.exercise);
          });
        } else {
          setState(() {
            _database.exercises[index] = _exerciseEdit.exercise;
          });
        }
        ExerciseDBFilesRoutine().writeExercises(databaseToJson(_database));
        break;
      case 'Cancel':
        break;
      default:
        break;
    }
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.grey.shade900,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                radius: 22.0,
                child: Text(
                  "${snapshot.data[index].name[0]}", 
                  style: TextStyle(
                    color: Colors.deepOrange.shade500,
                    fontSize: 20.0
                  ),
                ),
                backgroundColor: Colors.grey.shade800,
              ),
              title: Text(
                snapshot.data[index].name,
                style: TextStyle(
                  color: Colors.white70
                ),
              ),
              onTap: () {
                _exerciseEdit.action = "Save";
                _exerciseEdit.exercise = Exercise(
                  id: snapshot.data[index].id,
                  name: snapshot.data[index].name,
                  sets: snapshot.data[index].sets
                );

                Navigator.pop(context, _exerciseEdit);
              },
              onLongPress: () => _addOrEditExercise(
                add: false,
                exercise: snapshot.data[index],
                index: index
              )
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() { 
    super.initState();
    _exerciseEdit = new ExerciseEdit();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose exercise"),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: FutureBuilder(
          initialData: [],
          future: _loadExercises(),
          builder: (context, snapshot) {
            return !snapshot.hasData
              ? Center(
                child: CircularProgressIndicator(),
              )
              : _buildListViewSeparated(snapshot);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addOrEditExercise(
          add: true,
          index: -1,
          exercise: Exercise()
        ),
      ),
    );
  }
}
