import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/goal.dart';
import '../../core/providers/goal_provider.dart';

class GoalDetailsSheet extends StatelessWidget {
  final Goal goal;

  const GoalDetailsSheet({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildProgressSection(context),
                    const SizedBox(height: 24),
                    _buildTasksList(context),
                    const SizedBox(height: 24),
                    _buildAnalytics(context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editGoal(context),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteGoal(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            goal.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    final completedTasks = goal.tasks.where((t) => t.completed).length;
    final progress = goal.tasks.isEmpty ? 0.0 : completedTasks / goal.tasks.length;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  strokeWidth: 8,
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            ),
            const SizedBox(height: 8),
            Text(
              '$completedTasks/${goal.tasks.length} tasks completed',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tasks',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addTask(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...goal.tasks.map((task) => _TaskTile(
              task: task,
              onToggle: (completed) => _toggleTask(context, task.id, completed),
              onDelete: () => _deleteTask(context, task.id),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalytics(BuildContext context) {
    final theme = Theme.of(context);
    final timeLeft = goal.deadline.difference(DateTime.now());
    final daysLeft = timeLeft.inDays;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _AnalyticTile(
              icon: Icons.timer,
              title: 'Time Left',
              value: '$daysLeft days',
              color: theme.colorScheme.primary,
            ),
            _AnalyticTile(
              icon: Icons.speed,
              title: 'Current Pace',
              value: _calculatePace(),
              color: theme.colorScheme.secondary,
            ),
            _AnalyticTile(
              icon: Icons.trending_up,
              title: 'Completion Trend',
              value: _calculateTrend(),
              color: theme.colorScheme.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  String _calculatePace() {
    final totalDays = goal.deadline.difference(DateTime.now()).inDays;
    if (totalDays <= 0) return 'Past deadline';
    
    final completedTasks = goal.tasks.where((t) => t.completed).length;
    final remainingTasks = goal.tasks.length - completedTasks;
    
    final tasksPerDay = remainingTasks / totalDays;
    return '${tasksPerDay.toStringAsFixed(1)} tasks/day';
  }

  String _calculateTrend() {
    final completedTasks = goal.tasks.where((t) => t.completed).length;
    final progress = goal.tasks.isEmpty ? 0 : completedTasks / goal.tasks.length;
    
    if (progress < 0.25) return 'Behind schedule';
    if (progress < 0.5) return 'On track';
    if (progress < 0.75) return 'Good progress';
    return 'Excellent progress';
  }

  void _editGoal(BuildContext context) {
    // TODO: Implement goal editing
  }

  void _deleteGoal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Goal'),
        content: const Text('Are you sure you want to delete this goal?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<GoalProvider>().deleteGoal(goal.id);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close details sheet
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _addTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: _AddTaskForm(goalId: goal.id),
      ),
    );
  }

  void _toggleTask(BuildContext context, String taskId, bool completed) {
    context.read<GoalProvider>().updateTaskStatus(goal.id, taskId, completed);
  }

  void _deleteTask(BuildContext context, String taskId) {
    context.read<GoalProvider>().deleteTask(goal.id, taskId);
  }
}

class _TaskTile extends StatelessWidget {
  final Task task;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  const _TaskTile({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.completed,
        onChanged: (value) => onToggle(value ?? false),
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.completed ? TextDecoration.lineThrough : null,
          color: task.completed
              ? Theme.of(context).colorScheme.onSurfaceVariant
              : null,
        ),
      ),
      subtitle: Text(
        'Estimated: ${task.estimatedTime.inHours}h',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: onDelete,
      ),
    );
  }
}

class _AnalyticTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _AnalyticTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: color,
        ),
      ),
    );
  }
}

class _AddTaskForm extends StatefulWidget {
  final String goalId;

  const _AddTaskForm({required this.goalId});

  @override
  State<_AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<_AddTaskForm> {
  final _titleController = TextEditingController();
  var _estimatedHours = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Task Title',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          value: _estimatedHours,
          decoration: const InputDecoration(
            labelText: 'Estimated Time',
            border: OutlineInputBorder(),
          ),
          items: List.generate(8, (i) => i + 1).map((hours) {
            return DropdownMenuItem(
              value: hours,
              child: Text('$hours hours'),
            );
          }).toList(),
          onChanged: (value) => setState(() => _estimatedHours = value!),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  context.read<GoalProvider>().addTask(
                    widget.goalId,
                    Task(
                      id: DateTime.now().toString(),
                      title: _titleController.text,
                      estimatedTime: Duration(hours: _estimatedHours),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}