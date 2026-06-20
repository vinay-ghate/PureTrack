import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/tracker_provider.dart';
import '../models/tracker.dart';
import '../models/category.dart';
import '../helpers/icon_helper.dart';
import '../widgets/theme.dart';
import 'add_edit_tracker_screen.dart';
import 'tracker_detail_screen.dart';
import 'timer_tracking_screen.dart';
import 'nutrition_screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int? _selectedCategoryId; // null means 'All'

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackerProvider>(context);
    final trackers = provider.trackers.where((t) => !t.isArchived).toList();
    final categories = provider.categories;

    // Filter trackers by category
    final filteredTrackers = _selectedCategoryId == null
        ? trackers
        : trackers.where((t) => t.categoryId == _selectedCategoryId).toList();

    // Calculate maximum streak overall
    int maxStreak = 0;
    for (var tracker in trackers) {
      final stats = provider.getStreakStats(tracker);
      if (stats['current']! > maxStreak) {
        maxStreak = stats['current']!;
      }
    }

    final stats = provider.getDashboardStats(provider.selectedDateStr);
    final completedCount = stats['completed'] as int;
    final totalCount = stats['total'] as int;
    final completionPercent = stats['percent'] as double;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.lens_blur_outlined, size: 24),
            const SizedBox(width: 8),
            Text(
              "PureTrack",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant_outlined),
            tooltip: "Nutrition Tracker",
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const NutritionScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.today_outlined),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 7)),
              );
              if (date != null) {
                provider.setSelectedDate(date);
              }
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.loadAllData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('EEEE, MMMM d').format(
                                  provider.selectedDateStr == DateFormat('yyyy-MM-dd').format(DateTime.now())
                                      ? DateTime.now()
                                      : DateTime.parse(provider.selectedDateStr),
                                ),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                provider.selectedDateStr == DateFormat('yyyy-MM-dd').format(DateTime.now())
                                    ? "Today"
                                    : DateFormat('MMM d, y').format(DateTime.parse(provider.selectedDateStr)),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ],
                          ),
                          if (maxStreak > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF5EEAD4).withOpacity(0.1) : const Color(0xFF0F766E).withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("🔥", style: TextStyle(fontSize: 14)),
                                  const SizedBox(width: 4),
                                  Text(
                                    "$maxStreak day streak",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Progress Ring / Card Summary
                      _buildSummaryCard(context, completedCount, totalCount, completionPercent),
                      const SizedBox(height: 24),

                      // Category filters
                      _buildCategoryFilters(context, categories),
                      const SizedBox(height: 16),

                      // Trackers list
                      filteredTrackers.isEmpty
                          ? _buildEmptyState(context, trackers.isEmpty)
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredTrackers.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final tracker = filteredTrackers[index];
                                return _buildTrackerCard(context, tracker, provider);
                              },
                            ),
                      const SizedBox(height: 80), // bottom spacing for FAB
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_tracker_fab',
        child: const Icon(Icons.add, size: 28),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditTrackerScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, int completed, int total, double percent) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkOutline : AppColors.lightDivider, width: 1),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Row(
        children: [
          // Circular Progress Indicator
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: total > 0 ? percent : 0.0,
                  strokeWidth: 8,
                  backgroundColor: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                  color: primaryColor,
                  strokeCap: StrokeCap.round,
                ),
                Center(
                  child: Text(
                    total > 0 ? "${(percent * 100).toInt()}%" : "0%",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Progress",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  total > 0
                      ? "$completed of $total trackers completed"
                      : "No active trackers today",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: total > 0 ? percent : 0.0,
                    minHeight: 4,
                    backgroundColor: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                    color: primaryColor,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryFilters(BuildContext context, List<Category> categories) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // 'All' chip
          ChoiceChip(
            label: const Text("All"),
            selected: _selectedCategoryId == null,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(
              color: _selectedCategoryId == null 
                  ? Colors.transparent 
                  : (isDark ? AppColors.darkOutline : AppColors.lightOutline),
            ),
            selectedColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: _selectedCategoryId == null
                  ? (isDark ? Colors.black : Colors.white)
                  : (isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
            ),
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedCategoryId = null;
                });
              }
            },
          ),
          const SizedBox(width: 8),
          ...categories.map((cat) {
            final isSelected = _selectedCategoryId == cat.id;
            final catColor = AppColors.getColorFromHex(cat.color);
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ChoiceChip(
                label: Text(cat.name),
                selected: isSelected,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : (isDark ? AppColors.darkOutline : AppColors.lightOutline),
                ),
                selectedColor: catColor,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                ),
                onSelected: (selected) {
                  setState(() {
                    _selectedCategoryId = selected ? cat.id : null;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTrackerCard(BuildContext context, Tracker tracker, TrackerProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackerColor = AppColors.getColorFromHex(tracker.color);
    final streakStats = provider.getStreakStats(tracker);
    final currentStreak = streakStats['current'] ?? 0;
    
    final loggedValue = provider.getLoggedValueForDate(tracker.id!, provider.selectedDateStr);
    final isCompleted = provider.isTrackerCompletedOnDate(tracker, provider.selectedDateStr);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TrackerDetailScreen(tracker: tracker),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? trackerColor.withOpacity(0.6)
                : (isDark ? AppColors.darkOutline : AppColors.lightDivider),
            width: 1.5,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.01),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with Icon, Name, Streak
            Row(
              children: [
                // Circular icon holder
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: trackerColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    IconHelper.getIcon(tracker.icon),
                    color: trackerColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tracker.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                              color: isCompleted
                                  ? (isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText)
                                  : (isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText),
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tracker.type.toShortString().toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: trackerColor,
                        ),
                      )
                    ],
                  ),
                ),
                if (currentStreak > 0)
                  Row(
                    children: [
                      const Text("🔥", style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 2),
                      Text(
                        "$currentStreak",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(width: 12),

                // Right action (Depends on type)
                _buildRightAction(context, tracker, provider, loggedValue, isCompleted, trackerColor),
              ],
            ),

            // Bottom Progress bar for goals/counters
            if (tracker.type == TrackerType.counter || tracker.type == TrackerType.goal)
              Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${loggedValue.toStringAsFixed(0)} / ${tracker.targetValue.toStringAsFixed(0)} ${tracker.unit}",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                          ),
                        ),
                        Text(
                          "${((loggedValue / tracker.targetValue).clamp(0.0, 1.0) * 100).toInt()}%",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: trackerColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (loggedValue / tracker.targetValue).clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                        color: trackerColor,
                      ),
                    )
                  ],
                ),
              ),

            // If Timer log details are available
            if (tracker.type == TrackerType.timer)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Logged today: ${loggedValue.toStringAsFixed(0)} mins",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                      ),
                    ),
                    if (tracker.targetValue > 0)
                      Text(
                        "Target: ${tracker.targetValue.toStringAsFixed(0)} mins",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                        ),
                      ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildRightAction(
    BuildContext context,
    Tracker tracker,
    TrackerProvider provider,
    double loggedValue,
    bool isCompleted,
    Color trackerColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (tracker.type) {
      case TrackerType.habit:
        return GestureDetector(
          onTap: () {
            provider.logValue(tracker.id!, 1.0, DateTime.parse(provider.selectedDateStr));
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isCompleted ? trackerColor : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted ? trackerColor : (isDark ? AppColors.darkOutline : AppColors.lightOutline),
                width: 2,
              ),
            ),
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  )
                : null,
          ),
        );

      case TrackerType.counter:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 22),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: loggedValue > 0
                  ? () {
                      provider.logValue(tracker.id!, -1.0, DateTime.parse(provider.selectedDateStr));
                    }
                  : null,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.add_circle, color: trackerColor, size: 22),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                provider.logValue(tracker.id!, 1.0, DateTime.parse(provider.selectedDateStr));
              },
            ),
          ],
        );

      case TrackerType.goal:
        return IconButton(
          icon: Icon(
            isCompleted ? Icons.check_circle : Icons.add_circle_outline,
            color: isCompleted ? trackerColor : (isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
            size: 24,
          ),
          onPressed: () async {
            // Prompt input to log value towards goal
            final valueController = TextEditingController();
            final value = await showDialog<double>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Log Progress for ${tracker.name}"),
                content: TextField(
                  controller: valueController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: "Enter value in ${tracker.unit}",
                    border: const OutlineInputBorder(),
                  ),
                  autofocus: true,
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
                      Navigator.pop(context, val);
                    },
                  ),
                ],
              ),
            );
            if (value != null && value > 0) {
              provider.logValue(tracker.id!, value, DateTime.parse(provider.selectedDateStr));
            }
          },
        );

      case TrackerType.timer:
        return TextButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TimerTrackingScreen(tracker: tracker),
              ),
            );
          },
          icon: Icon(Icons.play_arrow, size: 16, color: trackerColor),
          label: Text("Start", style: TextStyle(color: trackerColor, fontWeight: FontWeight.bold, fontSize: 12)),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: trackerColor.withOpacity(0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
    }
  }

  Widget _buildEmptyState(BuildContext context, bool isDatabaseEmpty) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDatabaseEmpty ? Icons.playlist_add : Icons.filter_list_off,
              size: 64,
              color: isDark ? AppColors.darkHint : AppColors.lightHint,
            ),
            const SizedBox(height: 16),
            Text(
              isDatabaseEmpty ? "No Trackers Created Yet" : "No Trackers in Category",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              isDatabaseEmpty
                  ? "Tap the + button to create your first habit, goal, counter, or timer tracker."
                  : "Try choosing another category filter or create a new tracker in this category.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (isDatabaseEmpty) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddEditTrackerScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Create Tracker"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
