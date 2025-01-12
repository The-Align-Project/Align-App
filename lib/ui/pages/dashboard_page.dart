import 'package:flutter/material.dart';
import '../widgets/focus_tracker.dart';
import '../widgets/focus_stats.dart';
import '../widgets/today_goals.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          title: Text('Focus Dashboard'),
          floating: true,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const FocusTracker(),
                const SizedBox(height: 16),
                const FocusStats(),
                const SizedBox(height: 16),
                const TodayGoals(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}