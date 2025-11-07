import 'package:flutter/material.dart';
import 'package:funzi/helpers/sound_handles.dart';
import 'package:funzi/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppAudio.preload();
  runApp(app());
}

Widget app() {
  return MaterialApp(
    title: 'Funzi',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: Home(),
  );
}
