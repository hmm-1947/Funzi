import 'package:flutter/material.dart';
import 'package:naif/helpers/sound_handles.dart';
import 'package:naif/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppAudio.preload();
  runApp(app());
}

Widget app() {
  return MaterialApp(
    title: 'Naif',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: SplashScreen(),
  );
}
