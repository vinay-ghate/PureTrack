import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/tracker_provider.dart';
import '../models/tracker.dart';
import '../helpers/icon_helper.dart';
import '../widgets/theme.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _timeFilter = 'This Week'; // 'This Week' or 'This Month'

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackerProvider>(context);
    final trackers = provider.trackers.where((t) => !t.isArchived).toList();
    final categories = provider.categories;

    // 1. Calculate Active Trackers
    final activeCount = trackers.length;

    // 2. Calculate Best Streak Overall
    int bestStreakOverall = 0;
    for (var tracker in trackers) {
      final stats = provider.getStreakStats(tracker);
      if (stats['longest']! > bestStreakOverall) {
        bestStreakOverall = stats['longest']!;
      }
    }

    // 3. Calculate Weekly / Monthly Completion Rate
    final int filterDays = _timeFilter == 'This Week' ? 7 : 30;
    double completionRate = 0.0;
    
    if (trackers.isNotEmpty) {
      int totalCompletionsPossible = trackers.length * filterDays;
      int actualCompletions = 0;
      final today = DateTime.now();

      for (int i = 0; i < filterDays; i++) {
        final date = today.subtract(Duration(days: i));
        final dateStr = provider.selectedDateStr; // Or calculate date specific
        // Let's compute date keys correctly
        final checkDateStr = provider.selectedDateStr; // fallback
        final String dayKey = DateTime(date.year, date.month, date.day).toIso8601String().substring(0, 10);
        for (var t in trackers) {
          if (provider.isTrackerCompletedOnDate(t, dayKey)) {
            actualCompletions++;
          }
        }
      }
      completionRate = totalCompletionsPossible > 0 
          ? (actualCompletions / totalCompletionsPossible).clamp(0.0, 1.0) 
          : 0.0;
    }

    // 4. Calculate Tracker Performances for Best/Worst List
    final List<Map<String, dynamic>> performanceList = [];
    final today = DateTime.now();
    for (var t in trackers) {
      int completions = 0;
      // Calculate completion count over the last 30 days
      for (int i = 0; i < 30; i++) {
        final checkDate = today.subtract(Duration(days: i));
        final checkDateStr = DateTime(checkDate.year, checkDate.month, checkDate.day).toIso8601String().substring(0, 10);
        if (provider.isTrackerCompletedOnDate(t, checkDateStr)) {
          completions++;
        }
      }
      // calculate rate
      double rate = completions / 30.0;
      performanceList.add({
        'tracker': t,
        'rate': rate,
      });
    }

    // Sort performance lists
    performanceList.sort((a, b) => (b['rate'] as double).compareTo(a['rate'] as double));
    final bestPerformers = performanceList.take(3).toList();
    final worstPerformers = performanceList.reversed.take(3).toList().where((p) => p['rate'] < 1.0).toList();

    // 5. Category Breakdown Chart Data
    final Map<int, int> categoryTrackerCounts = {};
    for (var t in trackers) {
      if (t.categoryId != null) {
        categoryTrackerCounts[t.categoryId!] = (categoryTrackerCounts[t.categoryId!] ?? 0) + 1;
      }
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: DropdownButton<String>(
              value: _timeFilter,
              underline: const SizedBox(),
              items: ['This Week', 'This Month'].map((val) {
                return DropdownMenuItem(value: val, child: Text(val));
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _timeFilter = val;
                  });
                }
              },
            ),
          )
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Overview Insights",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),

                  // Insight Summary Cards Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildInsightCard(
                          context,
                          "Active Trackers",
                          "$activeCount",
                          Icons.insights_outlined,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInsightCard(
                          context,
                          "Best Streak",
                          "$bestStreakOverall Days",
                          Icons.local_fire_department_outlined,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildInsightCard(
                          context,
                          "Completion Rate",
                          "${(completionRate * 100).toInt()}%",
                          Icons.done_all_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Category Breakdown Chart
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Trackers per Category",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 160,
                            child: categoryTrackerCounts.isEmpty
                                ? const Center(child: Text("Assign trackers to categories to see breakdown"))
                                : BarChart(
                                    BarChartData(
                                      gridData: const FlGridData(show: false),
                                      titlesData: FlTitlesData(
                                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        leftTitles: const AxisTitles(
                                          sideTitles: SideTitles(showTitles: true, reservedSize: 22),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              final index = value.toInt();
                                              if (index >= 0 && index < categories.length) {
                                                return Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text(
                                                    categories[index].name.substring(0, 3),
                                                    style: const TextStyle(fontSize: 10),
                                                  ),
                                                );
                                              }
                                              return const Text('');
                                            },
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      barGroups: List.generate(categories.length, (index) {
                                        final cat = categories[index];
                                        final count = categoryTrackerCounts[cat.id] ?? 0;
                                        final catColor = AppColors.getColorFromHex(cat.color);
                                        return BarChartGroupData(
                                          x: index,
                                          barRods: [
                                            BarChartRodData(
                                              toY: count.toDouble(),
                                              color: catColor,
                                              width: 16,
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                                            )
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Best Performers List
                  Text(
                    "Top Performers (30 Days)",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (bestPerformers.isEmpty)
                    const Text("No active trackers recorded.")
                  else
                    ...bestPerformers.map((perf) {
                      final tracker = perf['tracker'] as Tracker;
                      final rate = perf['rate'] as double;
                      final color = AppColors.getColorFromHex(tracker.color);
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          dense: true,
                          leading: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(IconHelper.getIcon(tracker.icon), color: color, size: 18),
                          ),
                          title: Text(tracker.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Type: ${tracker.type.toShortString().toUpperCase()}"),
                          trailing: Text(
                            "${(rate * 100).toInt()}% Completion",
                            style: TextStyle(color: color, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 16),

                  // Worst Performers List
                  if (worstPerformers.isNotEmpty) ...[
                    Text(
                      "Needs Attention (30 Days)",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...worstPerformers.map((perf) {
                      final tracker = perf['tracker'] as Tracker;
                      final rate = perf['rate'] as double;
                      final color = AppColors.getColorFromHex(tracker.color);
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          dense: true,
                          leading: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(IconHelper.getIcon(tracker.icon), color: Colors.white, size: 18),
                          ),
                          title: Text(tracker.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("Type: ${tracker.type.toShortString().toUpperCase()}"),
                          trailing: Text(
                            "${(rate * 100).toInt()}% Completion",
                            style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }),
                  ]
                ],
              ),
            ),
    );
  }

  Widget _buildInsightCard(BuildContext context, String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkOutline : AppColors.lightDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
