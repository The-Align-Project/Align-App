import 'package:flutter/material.dart';

class TodayGoals extends StatelessWidget {
  const TodayGoals({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Goals',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to goals page
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return const GoalListTile();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GoalListTile extends StatelessWidget {
  const GoalListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        child: const Icon(Icons.task_alt),
      ),
      title: const Text('Complete Project Proposal'),
      subtitle: const Text('2/5 tasks completed'),
      trailing: const Text('2h remaining'),
    );
  }
}