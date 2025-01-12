import 'package:flutter/foundation.dart';
import '../models/goal.dart';

class GoalProvider with ChangeNotifier {
  final List<Goal> _goals = [];
  
  List<Goal> get goals => _goals;

  void addGoal(Goal goal) {
    _goals.add(goal);
    notifyListeners();
  }

  void updateTaskStatus(String goalId, String taskId, bool completed) {
    final goalIndex = _goals.indexWhere((g) => g.id == goalId);
    if (goalIndex != -1) {
      final taskIndex = _goals[goalIndex].tasks.indexWhere((t) => t.id == taskId);
      if (taskIndex != -1) {
        _goals[goalIndex].tasks[taskIndex].completed = completed;
        notifyListeners();
      }
    }
  }
}