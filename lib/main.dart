import 'package:flutter/material.dart';
import 'package:voice_reocrder/views/Welcome.dart';
import 'package:voice_reocrder/views/instruction.dart';
import 'package:voice_reocrder/views/recorder_home_view.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Meeting app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: InstructionPage(),
    );
  }
}

