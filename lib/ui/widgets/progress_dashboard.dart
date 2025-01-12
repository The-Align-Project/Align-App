import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/focus_provider.dart';

class ProgressDashboard extends StatelessWidget {
  const ProgressDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final focusProvider = Provider.of<FocusProvider>(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Progress Dashboard',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            // Add charts and metrics here
          ],
        ),
      ),
    );
  }
}