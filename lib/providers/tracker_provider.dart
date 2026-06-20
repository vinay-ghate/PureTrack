import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/category.dart';
import '../models/tracker.dart';
import '../models/tracker_log.dart';
import '../models/nutrition_entry.dart';
import 'package:intl/intl.dart';

class TrackerProvider with ChangeNotifier {
  List<Tracker> _trackers = [];
  List<Category> _categories = [];
  List<TrackerLog> _logs = [];
  List<NutritionEntry> _nutritionEntries = [];

  bool _isLoading = false;
  String _selectedDateStr = DateFormat('yyyy-MM-DD').format(DateTime.now());

  List<Tracker> get trackers => _trackers;
  List<Category> get categories => _categories;
  List<TrackerLog> get logs => _logs;
  List<NutritionEntry> get nutritionEntries => _nutritionEntries;
  bool get isLoading => _isLoading;

  TrackerProvider() {
    _selectedDateStr = _formatDate(DateTime.now());
    loadAllData();
  }

  String _formatDate(DateTime dt) {
    return DateFormat('yyyy-MM-dd').format(dt);
  }

  Future<void> loadAllData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await DatabaseHelper.instance.getAllCategories();
      _trackers = await DatabaseHelper.instance.getAllTrackers();
      _logs = await DatabaseHelper.instance.getAllLogs();
      _nutritionEntries = await DatabaseHelper.instance.getNutritionEntriesForDate(_selectedDateStr);
    } catch (e) {
      debugPrint("Error loading data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Set date for Dashboard / Nutrition and load nutrition data for that day
  Future<void> setSelectedDate(DateTime date) async {
    _selectedDateStr = _formatDate(date);
    _isLoading = true;
    notifyListeners();
    try {
      _nutritionEntries = await DatabaseHelper.instance.getNutritionEntriesForDate(_selectedDateStr);
    } catch (e) {
      debugPrint("Error loading nutrition for date: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String get selectedDateStr => _selectedDateStr;

  // --- Category Operations ---
  Future<void> addCategory(Category category) async {
    await DatabaseHelper.instance.insertCategory(category);
    await loadAllData();
  }

  Future<void> updateCategory(Category category) async {
    await DatabaseHelper.instance.updateCategory(category);
    await loadAllData();
  }

  Future<void> deleteCategory(int id) async {
    await DatabaseHelper.instance.deleteCategory(id);
    await loadAllData();
  }

  // --- Tracker Operations ---
  Future<void> addTracker(Tracker tracker) async {
    await DatabaseHelper.instance.insertTracker(tracker);
    await loadAllData();
  }

  Future<void> updateTracker(Tracker tracker) async {
    await DatabaseHelper.instance.updateTracker(tracker);
    await loadAllData();
  }

  Future<void> deleteTracker(int id) async {
    await DatabaseHelper.instance.deleteTracker(id);
    await loadAllData();
  }

  // --- Log Operations ---
  Future<void> logValue(int trackerId, double value, DateTime date, {String? note}) async {
    final dateStr = _formatDate(date);
    
    // Check if this is a Habit. Habits are toggled (0 or 1).
    final tracker = _trackers.firstWhere((t) => t.id == trackerId);
    if (tracker.type == TrackerType.habit) {
      // Toggle logic
      final existingLogs = _logs.where((l) => l.trackerId == trackerId && l.date == dateStr).toList();
      if (existingLogs.isNotEmpty) {
        // Toggle OFF: delete the log
        for (var log in existingLogs) {
          await DatabaseHelper.instance.deleteTrackerLog(log.id!);
        }
      } else {
        // Toggle ON: insert 1.0 log
        final log = TrackerLog(
          trackerId: trackerId,
          date: dateStr,
          valueLogged: 1.0,
          timestamp: DateTime.now(),
          note: note,
        );
        await DatabaseHelper.instance.insertTrackerLog(log);
      }
    } else {
      // Counters / Goals / Timers: insert log
      final log = TrackerLog(
        trackerId: trackerId,
        date: dateStr,
        valueLogged: value,
        timestamp: DateTime.now(),
        note: note,
      );
      await DatabaseHelper.instance.insertTrackerLog(log);
    }
    await loadAllData();
  }

  Future<void> setCounterValue(int trackerId, double targetValue, DateTime date) async {
    final dateStr = _formatDate(date);
    // Delete existing logs for today and set single log with targetValue
    final existingLogs = _logs.where((l) => l.trackerId == trackerId && l.date == dateStr).toList();
    for (var log in existingLogs) {
      await DatabaseHelper.instance.deleteTrackerLog(log.id!);
    }
    if (targetValue > 0) {
      final log = TrackerLog(
        trackerId: trackerId,
        date: dateStr,
        valueLogged: targetValue,
        timestamp: DateTime.now(),
      );
      await DatabaseHelper.instance.insertTrackerLog(log);
    }
    await loadAllData();
  }

  Future<void> deleteLog(int logId) async {
    await DatabaseHelper.instance.deleteTrackerLog(logId);
    await loadAllData();
  }

  // --- Nutrition Operations ---
  Future<void> addNutritionEntry(NutritionEntry entry) async {
    await DatabaseHelper.instance.insertNutritionEntry(entry);
    _nutritionEntries = await DatabaseHelper.instance.getNutritionEntriesForDate(_selectedDateStr);
    notifyListeners();
  }

  Future<void> deleteNutritionEntry(int id) async {
    await DatabaseHelper.instance.deleteNutritionEntry(id);
    _nutritionEntries = await DatabaseHelper.instance.getNutritionEntriesForDate(_selectedDateStr);
    notifyListeners();
  }

  // --- Clear Database ---
  Future<void> clearAll() async {
    await DatabaseHelper.instance.clearAllData();
    await loadAllData();
  }

  // --- Calculations ---

  // Get cumulative logged value for a tracker on a specific date
  double getLoggedValueForDate(int trackerId, String dateStr) {
    final trackerLogs = _logs.where((l) => l.trackerId == trackerId && l.date == dateStr);
    double total = 0;
    for (var log in trackerLogs) {
      total += log.valueLogged;
    }
    return total;
  }

  // Checks if a tracker is completed on a specific date
  bool isTrackerCompletedOnDate(Tracker tracker, String dateStr) {
    final loggedVal = getLoggedValueForDate(tracker.id!, dateStr);
    if (tracker.type == TrackerType.habit) {
      return loggedVal >= 1.0;
    } else {
      return loggedVal >= tracker.targetValue;
    }
  }

  // Streak calculations (Current Streak, Longest Streak)
  Map<String, int> getStreakStats(Tracker tracker) {
    if (tracker.id == null) return {'current': 0, 'longest': 0};

    // Extract unique dates where the tracker was completed
    final completedDates = <String>{};
    final trackerLogs = _logs.where((l) => l.trackerId == tracker.id).toList();
    
    // Group logs by date
    final valueMap = <String, double>{};
    for (var log in trackerLogs) {
      valueMap[log.date] = (valueMap[log.date] ?? 0.0) + log.valueLogged;
    }

    final target = tracker.type == TrackerType.habit ? 1.0 : tracker.targetValue;
    valueMap.forEach((date, val) {
      if (val >= target) {
        completedDates.add(date);
      }
    });

    if (completedDates.isEmpty) {
      return {'current': 0, 'longest': 0};
    }

    // Sort completed dates descending (newest first)
    final sortedDates = completedDates.map((d) => DateTime.parse(d)).toList();
    sortedDates.sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayStr = _formatDate(today);
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayStr = _formatDate(yesterday);

    // Calculate current streak
    int currentStreak = 0;
    bool isStreakActive = completedDates.contains(todayStr) || completedDates.contains(yesterdayStr);

    if (isStreakActive) {
      DateTime checkDate = completedDates.contains(todayStr) 
          ? DateTime.parse(todayStr) 
          : DateTime.parse(yesterdayStr);
      
      while (true) {
        final checkDateStr = _formatDate(checkDate);
        if (completedDates.contains(checkDateStr)) {
          currentStreak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }
    }

    // Calculate longest streak
    // Sort ascending for forward iteration
    final sortedAsc = completedDates.map((d) => DateTime.parse(d)).toList();
    sortedAsc.sort((a, b) => a.compareTo(b));

    int longestStreak = 0;
    int tempStreak = 0;
    DateTime? prevDate;

    for (var date in sortedAsc) {
      if (prevDate == null) {
        tempStreak = 1;
      } else {
        final difference = date.difference(prevDate).inDays;
        if (difference == 1) {
          tempStreak++;
        } else if (difference > 1) {
          if (tempStreak > longestStreak) {
            longestStreak = tempStreak;
          }
          tempStreak = 1;
        }
      }
      prevDate = date;
    }

    if (tempStreak > longestStreak) {
      longestStreak = tempStreak;
    }

    return {
      'current': currentStreak,
      'longest': longestStreak,
    };
  }

  // Get total statistics for Dashboard
  Map<String, dynamic> getDashboardStats(String dateStr) {
    // Keep track of active trackers today (filtered by frequency if necessary, for simplicity we list all unarchived)
    final active = _trackers.where((t) => !t.isArchived).toList();
    if (active.isEmpty) return {'completed': 0, 'total': 0, 'percent': 0.0};

    int completedCount = 0;
    for (var tracker in active) {
      if (isTrackerCompletedOnDate(tracker, dateStr)) {
        completedCount++;
      }
    }

    return {
      'completed': completedCount,
      'total': active.length,
      'percent': completedCount / active.length,
    };
  }
}
