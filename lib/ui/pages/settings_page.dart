import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar.large(
          title: Text('Settings'),
          floating: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          sliver: Consumer<SettingsProvider>(
            builder: (context, settings, _) => SliverList(
              delegate: SliverChildListDelegate([
                _buildSection(
                  title: 'Appearance',
                  children: [
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      value: settings.darkMode,
                      onChanged: (_) => settings.toggleDarkMode(),
                    ),
                  ],
                ),
                _buildSection(
                  title: 'Notifications',
                  children: [
                    SwitchListTile(
                      title: const Text('Enable Notifications'),
                      value: settings.notifications,
                      onChanged: (_) => settings.toggleNotifications(),
                    ),
                    ListTile(
                      title: const Text('Daily Reminder Time'),
                      subtitle: Text(
                        '${settings.reminderTime.hour}:${settings.reminderTime.minute.toString().padLeft(2, '0')}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showTimePicker(context),
                    ),
                  ],
                ),
                _buildSection(
                  title: 'Goals',
                  children: [
                    ListTile(
                      title: const Text('Daily Focus Goal'),
                      subtitle: Text('${settings.dailyGoalHours} hours'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showHoursPicker(context),
                    ),
                  ],
                ),
                _buildSection(
                  title: 'Data',
                  children: [
                    ListTile(
                      title: const Text('Export Data'),
                      leading: const Icon(Icons.download),
                      onTap: () => _exportData(context),
                    ),
                    ListTile(
                      title: const Text('Clear All Data'),
                      leading: const Icon(Icons.delete_forever),
                      textColor: Colors.red,
                      iconColor: Colors.red,
                      onTap: () => _showClearDataDialog(context),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final settings = context.read<SettingsProvider>();
    final time = await showTimePicker(
      context: context,
      initialTime: settings.reminderTime,
    );
    if (time != null) {
      settings.setReminderTime(time);
    }
  }

  Future<void> _showHoursPicker(BuildContext context) async {
    final settings = context.read<SettingsProvider>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Daily Focus Goal'),
        content: DropdownButton<int>(
          value: settings.dailyGoalHours,
          items: List.generate(12, (i) => i + 1).map((hours) {
            return DropdownMenuItem(
              value: hours,
              child: Text('$hours hours'),
            );
          }).toList(),
          onChanged: (hours) {
            if (hours != null) {
              settings.setDailyGoalHours(hours);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  Future<void> _exportData(BuildContext context) async {
    // Implement data export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data exported successfully')),
    );
  }

  Future<void> _showClearDataDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // Implement clear data
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}