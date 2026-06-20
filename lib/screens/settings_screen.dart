import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/tracker_provider.dart';
import '../helpers/database_helper.dart';
import '../widgets/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final trackerProvider = Provider.of<TrackerProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Configuration",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),

            // Theme Setting
            Card(
              child: ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text("Appearance", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Selected: ${settings.themeMode.toString().split('.').last.toUpperCase()}"),
                trailing: DropdownButton<ThemeMode>(
                  value: settings.themeMode,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: ThemeMode.light, child: Text("Light")),
                    DropdownMenuItem(value: ThemeMode.dark, child: Text("Dark")),
                    DropdownMenuItem(value: ThemeMode.system, child: Text("System")),
                  ],
                  onChanged: (mode) {
                    if (mode != null) {
                      settings.setThemeMode(mode);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Default Reminder Time
            Card(
              child: ListTile(
                leading: const Icon(Icons.alarm_outlined),
                title: const Text("Default Reminder Time", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Time: ${settings.defaultReminderTime}"),
                trailing: OutlinedButton(
                  child: const Text("Change"),
                  onPressed: () async {
                    final parts = settings.defaultReminderTime.split(':');
                    final initialTime = TimeOfDay(
                      hour: int.parse(parts[0]),
                      minute: int.parse(parts[1]),
                    );
                    final time = await showTimePicker(
                      context: context,
                      initialTime: initialTime,
                    );
                    if (time != null) {
                      final timeStr = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                      settings.setDefaultReminderTime(timeStr);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Week Start Day
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_view_week_outlined),
                title: const Text("First Day of Week", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Selected: ${settings.weekStartDay}"),
                trailing: DropdownButton<String>(
                  value: settings.weekStartDay,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: "Sunday", child: Text("Sunday")),
                    DropdownMenuItem(value: "Monday", child: Text("Monday")),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      settings.setWeekStartDay(val);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Data Management Section
            Text(
              "Data Administration",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),

            // Export Backup
            Card(
              child: ListTile(
                leading: const Icon(Icons.download_outlined),
                title: const Text("Export Backup", style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Save tracker history to a local JSON file"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => _exportLocalBackup(context, trackerProvider),
              ),
            ),
            const SizedBox(height: 10),

            // Clear Database
            Card(
              child: ListTile(
                leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                title: const Text("Clear All Data", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                subtitle: const Text("Delete all trackers, logs, and food entries"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => _confirmClearData(context, trackerProvider),
              ),
            ),
            const SizedBox(height: 24),

            // About Box
            Center(
              child: Column(
                children: [
                  Text(
                    "PureTrack v1.0.0",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkHint : AppColors.lightHint,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Fully Offline & Private Habit Tracker",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> _exportLocalBackup(BuildContext context, TrackerProvider provider) async {
    try {
      final db = DatabaseHelper.instance;

      final categories = await db.getAllCategories();
      final trackers = await db.getAllTrackers(includeArchived: true);
      final logs = await db.getAllLogs();
      final nutrition = await db.getAllNutritionEntries();

      final backupData = {
        'backup_version': 1,
        'exported_at': DateTime.now().toIso8601String(),
        'categories': categories.map((c) => c.toMap()).toList(),
        'trackers': trackers.map((t) => t.toMap()).toList(),
        'logs': logs.map((l) => l.toMap()).toList(),
        'nutrition': nutrition.map((n) => n.toMap()).toList(),
      };

      final jsonString = jsonEncode(backupData);
      
      final directory = await getApplicationDocumentsDirectory();
      final backupFile = File('${directory.path}/puretrack_backup_${DateTime.now().millisecondsSinceEpoch}.json');
      
      await backupFile.writeAsString(jsonString);

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Backup Exported Successfully! 🎉"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Your tracker logs and settings have been saved locally:"),
                const SizedBox(height: 8),
                SelectableText(
                  backupFile.path,
                  style: const TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text("Done"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to export backup: $e")),
        );
      }
    }
  }

  void _confirmClearData(BuildContext context, TrackerProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Clear All Data?", style: TextStyle(color: Colors.red)),
        content: const Text("This action will permanently delete all your custom trackers, completion logs, categories, and nutrition entries. This action cannot be undone. Are you sure?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Clear All", style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await provider.clearAll();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Database cleared successfully")),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
