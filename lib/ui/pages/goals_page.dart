import 'package:flutter/material.dart';
import '../widgets/goal_form.dart';
import '../../core/providers/goal_provider.dart';
import 'package:provider/provider.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: const Text('Goals'),
          floating: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => DraggableScrollableSheet(
                    initialChildSize: 0.9,
                    minChildSize: 0.5,
                    maxChildSize: 0.9,
                    builder: (context, scrollController) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: const GoalForm(),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: Consumer<GoalProvider>(
            builder: (context, provider, child) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final goal = provider.goals[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(goal.title),
                        subtitle: Text(
                          '${goal.tasks.where((t) => t.completed).length}/'
                          '${goal.tasks.length} tasks completed',
                        ),
                        trailing: CircularProgressIndicator(
                          value: goal.progress,
                          backgroundColor: Colors.grey[200],
                        ),
                      ),
                    );
                  },
                  childCount: provider.goals.length,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}