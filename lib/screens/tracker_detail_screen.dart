import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/tracker_provider.dart';
import '../models/tracker.dart';
import '../models/tracker_log.dart';
import '../helpers/icon_helper.dart';
import '../widgets/theme.dart';
import '../widgets/heatmap_grid.dart';
import 'add_edit_tracker_screen.dart';
import 'timer_tracking_screen.dart';

class TrackerDetailScreen extends StatefulWidget {
  final Tracker tracker;

  const TrackerDetailScreen({super.key, required this.tracker});

  @override
  State<TrackerDetailScreen> createState() => _TrackerDetailScreenState();
}

class _TrackerDetailScreenState extends State<TrackerDetailScreen> {
  String _timeRange = '7D'; // '7D' or '30D'

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackerProvider>(context);
    
    // Find latest tracker state from provider (in case it was edited)
    final tracker = provider.trackers.firstWhere(
      (t) => t.id == widget.tracker.id,
      orElse: () => widget.tracker,
    );

    final trackerColor = AppColors.getColorFromHex(tracker.color);
    final logs = provider.logs.where((l) => l.trackerId == tracker.id).toList();

    // Stats
    final streakStats = provider.getStreakStats(tracker);
    final currentStreak = streakStats['current'] ?? 0;
    final longestStreak = streakStats['longest'] ?? 0;
    
    // Completion rate calculations
    double completionRate = 0.0;
    if (logs.isNotEmpty) {
      final uniqueCompletedDates = <String>{};
      final target = tracker.type == TrackerType.habit ? 1.0 : tracker.targetValue;
      
      final valueMap = <String, double>{};
      for (var log in logs) {
        valueMap[log.date] = (valueMap[log.date] ?? 0.0) + log.valueLogged;
      }
      valueMap.forEach((date, val) {
        if (val >= target) {
          uniqueCompletedDates.add(date);
        }
      });

      // Divide unique completed days by total days since creation
      final daysSinceCreation = DateTime.now().difference(tracker.createdAt).inDays + 1;
      completionRate = (uniqueCompletedDates.length / daysSinceCreation).clamp(0.0, 1.0);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEditTrackerScreen(tracker: tracker),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _confirmDeleteTracker(context, provider, tracker),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tracker Header Info
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: trackerColor.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            IconHelper.getIcon(tracker.icon),
                            color: trackerColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tracker.name,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "${tracker.type.toShortString().toUpperCase()} - ${tracker.frequency}",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: trackerColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Stats Cards Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            context,
                            "Current Streak",
                            "$currentStreak",
                            "🔥",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            "Best Streak",
                            "$longestStreak",
                            "🏆",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildStatCard(
                            context,
                            "Completion",
                            "${(completionRate * 100).toInt()}%",
                            "📈",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Heatmap Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: HeatmapGrid(
                          tracker: tracker,
                          logs: logs,
                          trackerColor: trackerColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Trend Line Chart
                    _buildTrendChartCard(context, logs, trackerColor),
                    const SizedBox(height: 16),

                    // Log History Section
                    Text(
                      "History Log",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    logs.isEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurface : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: isDark ? AppColors.darkOutline : AppColors.lightDivider),
                            ),
                            child: const Center(
                              child: Text("No logged data yet. Start tracking below!"),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: logs.length,
                            itemBuilder: (context, index) {
                              final log = logs[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  dense: true,
                                  title: Text(
                                    "${log.valueLogged.toStringAsFixed(1)} ${tracker.unit}",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    DateFormat('MMM d, y • h:mm a').format(log.timestamp) +
                                        (log.note != null && log.note!.isNotEmpty ? "\nNote: ${log.note}" : ""),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                    onPressed: () {
                                      provider.deleteLog(log.id!);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
          ),
        ),
        child: _buildBottomActionButton(context, tracker, provider, trackerColor),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, String emoji) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkOutline : AppColors.lightDivider,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 4),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChartCard(BuildContext context, List<TrackerLog> logs, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Prepare values
    final int days = _timeRange == '7D' ? 7 : 30;
    final today = DateTime.now();
    final List<FlSpot> spots = [];

    // Map logs to date
    final Map<String, double> dateValues = {};
    for (var log in logs) {
      dateValues[log.date] = (dateValues[log.date] ?? 0.0) + log.valueLogged;
    }

    // Populate chart spots
    for (int i = days - 1; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final val = dateValues[dateStr] ?? 0.0;
      spots.add(FlSpot((days - 1 - i).toDouble(), val));
    }

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
                  "Activity Chart",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: '7D', label: Text('7D')),
                    ButtonSegment(value: '30D', label: Text('30D')),
                  ],
                  selected: {_timeRange},
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      _timeRange = newSelection.first;
                    });
                  },
                  showSelectedIcon: false,
                  style: SegmentedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: spots.isEmpty
                  ? const Center(child: Text("Not enough data"))
                  : LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 22,
                              interval: _timeRange == '7D' ? 1 : 6,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                final date = today.subtract(Duration(days: days - 1 - index));
                                return Text(
                                  DateFormat(_timeRange == '7D' ? 'E' : 'd').format(date),
                                  style: TextStyle(
                                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                                    fontSize: 9,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            barWidth: 3,
                            color: color,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: color.withOpacity(0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionButton(
    BuildContext context,
    Tracker tracker,
    TrackerProvider provider,
    Color color,
  ) {
    switch (tracker.type) {
      case TrackerType.habit:
        final isCompleted = provider.isTrackerCompletedOnDate(tracker, provider.selectedDateStr);
        return ElevatedButton.icon(
          onPressed: () {
            provider.logValue(tracker.id!, 1.0, DateTime.parse(provider.selectedDateStr));
          },
          icon: Icon(isCompleted ? Icons.check : Icons.check_circle_outline),
          label: Text(isCompleted ? "Completed Today (Undo)" : "Mark Done Today"),
          style: ElevatedButton.styleFrom(
            backgroundColor: isCompleted ? Colors.grey[700] : color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );

      case TrackerType.counter:
      case TrackerType.goal:
        return ElevatedButton.icon(
          onPressed: () async {
            final valueController = TextEditingController();
            final noteController = TextEditingController();
            final result = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Log ${tracker.name}"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: valueController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: "Logged Value (${tracker.unit})",
                        border: const OutlineInputBorder(),
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        labelText: "Optional Note",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: const Text("Log"),
                    onPressed: () {
                      final val = double.tryParse(valueController.text);
                      if (val != null) {
                        Navigator.pop(context, {
                          'value': val,
                          'note': noteController.text.trim(),
                        });
                      }
                    },
                  ),
                ],
              ),
            );
            if (result != null) {
              provider.logValue(
                tracker.id!,
                result['value'] as double,
                DateTime.parse(provider.selectedDateStr),
                note: result['note'] as String,
              );
            }
          },
          icon: const Icon(Icons.add),
          label: const Text("Log Progress Entry"),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );

      case TrackerType.timer:
        return ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TimerTrackingScreen(tracker: tracker),
              ),
            );
          },
          icon: const Icon(Icons.play_arrow),
          label: const Text("Start Timer Session"),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        );
    }
  }

  void _confirmDeleteTracker(BuildContext context, TrackerProvider provider, Tracker tracker) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Tracker"),
        content: Text("Are you sure you want to delete '${tracker.name}'? This will permanently delete all logged history associated with it."),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () {
              provider.deleteTracker(tracker.id!);
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to dashboard
            },
          ),
        ],
      ),
    );
  }
}
