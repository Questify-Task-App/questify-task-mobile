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
    return MaterialApp(
      title: 'Questify Task',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreenWrapper(),
    );
  }
}

class HomeScreenWrapper extends StatefulWidget {
  const HomeScreenWrapper({super.key});

  @override
  State<HomeScreenWrapper> createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends State<HomeScreenWrapper> {
  @override
  void initState() {
    super.initState();
    // Verifica atualizações após o widget estar pronto
    UpdateService.initializeUpdateChecker(context);
  }

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
