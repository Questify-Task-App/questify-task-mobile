import 'package:flutter/material.dart';
import 'package:questify_task_mobile/screens/home_screen.dart';
import 'package:questify_task_mobile/services/update_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuestifyTaskApp());
}

class QuestifyTaskApp extends StatelessWidget {
  const QuestifyTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return UpdateService.wrapWithUpgrader(
      child: MaterialApp(
        title: 'Questify Task',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}