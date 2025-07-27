import 'package:flutter/material.dart';
import 'package:questify_task_mobile/models/task.dart';
import 'package:questify_task_mobile/services/coin_persistence_service.dart';
import 'package:questify_task_mobile/services/list_manager_service.dart';
import 'package:questify_task_mobile/services/task_persistence.service.dart';
import 'package:questify_task_mobile/widgets/coin_banner.dart';
import 'package:questify_task_mobile/widgets/list_manager.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final CoinPersistenceService _coinService = CoinPersistenceService();
  int _currentCoins = 0;
  List<Task> tasks = [];
  late final ListManagerService _listManagerService;
  final _taskPersistenceService = TaskPersistenceService(context: 'rewards');

  @override
  void initState() {
    super.initState();
    _loadCoins();
    _loadTasks();
    _listManagerService = ListManagerService(
      context: context,
      onAdd: (String title, int cost) async {
        await _taskPersistenceService.addTask(
          Task(id: DateTime.now().toString(), title: title, coins: cost),
        );
        _loadTasks();
      },
      onComplete: (Task task) async {
        if (task.coins > _currentCoins) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Not enough coins'),
              content: Text(
                'You need ${task.coins} coins to complete this task.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          await _coinService.addCoins(-task.coins);
          _loadCoins();
        }
      },
      onDelete: (String id) async {
        await _taskPersistenceService.removeTask(id);
        _loadTasks();
      },
      onEdit: (Task task) async {
        await _taskPersistenceService.updateTask(task);
        _loadTasks();
      },
    );
  }

  Future<void> _loadCoins() async {
    final coins = await _coinService.getCoins();
    setState(() {
      _currentCoins = coins;
    });
  }

  Future<void> _loadTasks() async {
    final loadedTasks = await _taskPersistenceService.getTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: CoinBanner(coins: _currentCoins),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  children: tasks
                      .map(
                        (task) => ListManager(
                          task: task,
                          service: _listManagerService,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          right: 12,
          bottom: 12,
          child: FloatingActionButton(
            mini: true,
            onPressed: _listManagerService.addTask,
            backgroundColor: Colors.blue,
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
