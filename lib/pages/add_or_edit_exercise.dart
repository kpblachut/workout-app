import 'package:flutter/material.dart';
import 'package:spec_redone/classes/database.dart';
import 'dart:math';

import 'package:spec_redone/models/exercise_model.dart';


class AddOrEditExercise extends StatefulWidget {
  final bool add;
  final int index; 
  final ExerciseEdit exerciseEdit;
  AddOrEditExercise({Key key, this.add, this.index, this.exerciseEdit}) : super(key: key);

  @override
  _AddOrEditExerciseState createState() => _AddOrEditExerciseState();
}

class _AddOrEditExerciseState extends State<AddOrEditExercise> {
  ExerciseEdit _exerciseEdit;
  String _title;
  TextEditingController _nameControler = TextEditingController();
  TextEditingController _setsControler = TextEditingController();
  FocusNode _nameFocus = FocusNode();
  FocusNode _setsFocus = FocusNode();

  @override
  void initState() { 
    super.initState();
    _exerciseEdit = new ExerciseEdit(action: 'Cancel', exercise: widget.exerciseEdit.exercise);
    _title = widget.add ? 'Add' : 'Edit';
    _exerciseEdit.exercise = widget.exerciseEdit.exercise; 

    if (widget.add) {
      _nameControler.text = '';
      _setsControler.text = '';
    } else {
      _nameControler.text = _exerciseEdit.exercise.name;
      _setsControler.text = _exerciseEdit.exercise.sets;
    }
  }

  @override
  void dispose() {
    _nameControler.dispose();
    _setsControler.dispose();
    _nameFocus.dispose();
    _setsFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(
           title: Text("$_title Edit"),
           automaticallyImplyLeading: false,
         ),
         body: SafeArea(
           child: SingleChildScrollView(
             padding: EdgeInsets.all(16.0),
             child: Column(
               children: <Widget>[
                 // TODO: change to TextFromField and add validation
                 TextField(
                  controller: _nameControler,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  focusNode: _nameFocus,
                  decoration: InputDecoration(labelText: 'Name', icon: Icon(Icons.subject)),
                  onSubmitted: (submitted) {
                    FocusScope.of(context).requestFocus(_setsFocus);
                  },
                 ),
                 TextField(
                  controller: _setsControler,
                  focusNode: _setsFocus,
                  decoration: InputDecoration(labelText: 'Sets', icon: Icon(Icons.plus_one)),
                 ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                      child: Text('Cancel'),
                      color: Colors.grey.shade100,
                      onPressed: () {
                        _exerciseEdit.action = 'Cancel';
                        Navigator.pop(context, _exerciseEdit);
                      },
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    FlatButton(
                      onPressed: () {
                        _exerciseEdit.action = 'Save';
                        String _id = widget.add
                            ? Random().nextInt(9999999).toString()
                            : _exerciseEdit.exercise.id;
                        _exerciseEdit.exercise = Exercise(
                          id: _id,
                          name: _nameControler.text,
                          sets: _setsControler.text,
                        );
                        Navigator.pop(context, _exerciseEdit);
                      },
                      child: Text('Save'),
                      color: Colors.deepOrange.shade500,
                    )
                  ],
                )
               ],
             ),
           ),
         ),
       ),
    );
  }
}