import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/focus_provider.dart';

class FocusTracker extends StatelessWidget {
  const FocusTracker({super.key});

  @override
  Widget build(BuildContext context) {
    final focusProvider = context.watch<FocusProvider>();
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Focus Session',
                      style: theme.textTheme.titleLarge,
                    ),
                    if (!focusProvider.isTracking)
                      Text(
                        'Start focusing to track your progress',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
                if (focusProvider.isTracking)
                  _buildTimer(focusProvider.currentSessionStart!),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: focusProvider.isTracking ? 160 : 200,
                height: 48,
                child: FilledButton.icon(
                  onPressed: () {
                    if (focusProvider.isTracking) {
                      focusProvider.stopTracking();
                    } else {
                      focusProvider.startTracking();
                    }
                  },
                  icon: Icon(
                    focusProvider.isTracking ? Icons.stop : Icons.play_arrow,
                  ),
                  label: Text(
                    focusProvider.isTracking ? 'End Session' : 'Start Focusing',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimer(DateTime startTime) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final duration = DateTime.now().difference(startTime);
        return Text(
          '${duration.inHours.toString().padLeft(2, '0')}:'
          '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:'
          '${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        );
      },
    );
  }
}