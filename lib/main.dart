import 'package:flutter/material.dart';
import 'package:spec_redone/pages/home.dart';

void main() => runApp(MyApp());
// test comment

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      theme: ThemeData(
          primarySwatch: Colors.deepOrange, canvasColor: Colors.grey.shade800),
      home: Home(),
    );
  }
}
