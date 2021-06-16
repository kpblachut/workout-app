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

  void _addExercise() async {
    ExerciseEdit _exerciseEdit = ExerciseEdit(action: "Cancel", exercise: Exercise());

    _exerciseEdit = await Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => AddOrEditExercise(
            add: true,
            index: -1,
            exerciseEdit: _exerciseEdit,
          ),
        ));

    switch (_exerciseEdit.action) {
      case 'Save':
        setState(() {
          _database.exercises.add(_exerciseEdit.exercise);
        });

        ExerciseDBFilesRoutine().writeExercises(databaseToJson(_database));
        break;
      case 'Cancel':
        break;
      default:
        break;
    }
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.separated(
      itemCount: snapshot.data.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: Colors.grey,
        );      
      },
      itemBuilder: (context, index) {
        return Card(
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              child: Text("${snapshot.data[index].name[0]}"),
              backgroundColor: Colors.grey.shade600,
            ),
            title: Text(snapshot.data[index].name),
            onTap: () {
              _exerciseEdit.action = "Save";
              _exerciseEdit.exercise = Exercise(
                id: snapshot.data[index].id,
                name: snapshot.data[index].name,
                sets: snapshot.data[index].sets
              );

              Navigator.pop(context, _exerciseEdit);
            },
          ),
        );
      },
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
        onPressed: () => _addExercise(),
      ),
    );
  }
}
