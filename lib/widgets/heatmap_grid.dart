import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tracker.dart';
import '../models/tracker_log.dart';

class HeatmapGrid extends StatelessWidget {
  final Tracker tracker;
  final List<TrackerLog> logs;
  final Color trackerColor;

  const HeatmapGrid({
    super.key,
    required this.tracker,
    required this.logs,
    required this.trackerColor,
  });

  @override
  Widget build(BuildContext context) {
    // Generate dates for the last 90 days, ending today
    final today = DateTime.now();
    final List<DateTime> dates = [];
    for (int i = 89; i >= 0; i--) {
      dates.add(DateTime(today.year, today.month, today.day).subtract(Duration(days: i)));
    }

    // Group logs by date string
    final Map<String, double> dateValues = {};
    for (var log in logs) {
      final dateKey = DateFormat('yyyy-MM-dd').format(log.timestamp);
      dateValues[dateKey] = (dateValues[dateKey] ?? 0) + log.valueLogged;
    }

    // Determine completion values for each day
    final target = tracker.type == TrackerType.habit ? 1.0 : tracker.targetValue;

    // We want a Grid of 13 columns (weeks) and 7 rows (days)
    // Find the weekday of the oldest date to align cells correctly.
    // To keep it simple and clean, we render a wrap or a horizontal list of 13 weeks.
    // Each week is a Column of 7 days.
    
    // Group dates into lists of 7 days (weeks)
    final List<List<DateTime?>> weeks = [];
    List<DateTime?> currentWeek = List.filled(7, null);
    
    // First, align the first date to its weekday
    // Sunday = 7, Monday = 1, etc.
    final firstDate = dates.first;
    int dayOffset = firstDate.weekday - 1; // 0-indexed (Monday = 0)
    
    int dateIndex = 0;
    
    // Create weeks
    while (dateIndex < dates.length) {
      currentWeek = List.filled(7, null);
      for (int i = 0; i < 7; i++) {
        if (weeks.isEmpty && i < dayOffset) {
          // Empty slot before our first date
          currentWeek[i] = null;
        } else if (dateIndex < dates.length) {
          currentWeek[i] = dates[dateIndex];
          dateIndex++;
        }
      }
      weeks.add(currentWeek);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emptyColor = isDark ? Colors.grey[900]! : Colors.grey[200]!;
    final borderColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "90-Day Heatmap",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: weeks.map((week) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Column(
                  children: week.map((date) {
                    if (date == null) {
                      return const SizedBox(width: 14, height: 14);
                    }

                    final dateStr = DateFormat('yyyy-MM-dd').format(date);
                    final loggedVal = dateValues[dateStr] ?? 0.0;
                    
                    Color cellColor = emptyColor;
                    double percent = 0.0;

                    if (loggedVal > 0) {
                      percent = (loggedVal / target).clamp(0.0, 1.0);
                      if (percent > 0) {
                        cellColor = trackerColor.withOpacity(0.2 + (0.8 * percent));
                      }
                    }

                    return Tooltip(
                      message: "${DateFormat('MMM d, y').format(date)}: ${loggedVal.toStringAsFixed(1)} / ${target.toStringAsFixed(1)} ${tracker.unit}",
                      child: Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.symmetric(vertical: 2.0),
                        decoration: BoxDecoration(
                          color: cellColor,
                          borderRadius: BorderRadius.circular(2),
                          border: Border.all(
                            color: loggedVal > 0 ? Colors.transparent : borderColor,
                            width: 0.5,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Less", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
            const SizedBox(width: 4),
            _buildLegendBox(emptyColor, borderColor),
            const SizedBox(width: 2),
            _buildLegendBox(trackerColor.withOpacity(0.3), Colors.transparent),
            const SizedBox(width: 2),
            _buildLegendBox(trackerColor.withOpacity(0.6), Colors.transparent),
            const SizedBox(width: 2),
            _buildLegendBox(trackerColor, Colors.transparent),
            const SizedBox(width: 4),
            Text("More", style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10)),
          ],
        )
      ],
    );
  }

  Widget _buildLegendBox(Color color, Color border) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: border, width: 0.5),
      ),
    );
  }
}
