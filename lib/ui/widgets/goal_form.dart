import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/goal_provider.dart';
import '../../core/models/goal.dart';

class GoalForm extends StatefulWidget {
  const GoalForm({super.key});

  @override
  State<GoalForm> createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));
  final List<Task> _tasks = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Goal Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter a title';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _buildDeadlinePicker(context),
            const SizedBox(height: 16),
            _buildTasksList(),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _saveGoal,
              icon: const Icon(Icons.save),
              label: const Text('Save Goal'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeadlinePicker(BuildContext context) {
    return ListTile(
      title: const Text('Deadline'),
      subtitle: Text(
        '${_deadline.year}-${_deadline.month}-${_deadline.day}',
      ),
      trailing: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: _deadline,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
          );
          if (date != null) {
            setState(() => _deadline = date);
          }
        },
      ),
    );
  }

  Widget _buildTasksList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tasks'),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addTask,
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_tasks[index].title),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() => _tasks.removeAt(index));
                },
              ),
            );
          },
        ),
      ],
    );
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Task Title',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _tasks.add(Task(
                  id: DateTime.now().toString(),
                  title: value,
                  estimatedTime: const Duration(hours: 1),
                ));
              });
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  void _saveGoal() {
    if (_formKey.currentState?.validate() ?? false) {
      final goal = Goal(
        id: DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        deadline: _deadline,
        tasks: _tasks,
      );
      
      context.read<GoalProvider>().addGoal(goal);
      Navigator.pop(context);
    }
  }
}