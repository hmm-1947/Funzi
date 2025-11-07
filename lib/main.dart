import 'package:flutter/material.dart';
import 'package:playly/home.dart';

void main() {
  runApp(app());
}

Widget app() {
  return MaterialApp(
    title: 'Playly',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: Home(),
  );
}
