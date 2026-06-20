import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../models/tracker.dart';
import '../models/tracker_log.dart';
import '../models/nutrition_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static bool _isWebMode = kIsWeb;

  // Web mode local lists
  List<Category> _webCategories = [];
  List<Tracker> _webTrackers = [];
  List<TrackerLog> _webLogs = [];
  List<NutritionEntry> _webNutritionEntries = [];
  bool _webInitialized = false;

  DatabaseHelper._init();

  Future<Database?> get database async {
    if (_isWebMode) return null;
    if (_database != null) return _database!;
    try {
      _database = await _initDB('pure_track.db');
      return _database!;
    } catch (e) {
      debugPrint("Sqflite database failed to open. Switching to Web/Desktop storage mode. Error: $e");
      _isWebMode = true;
      return null;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    // Categories table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        color TEXT NOT NULL
      )
    ''');

    // Trackers table
    await db.execute('''
      CREATE TABLE trackers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT NOT NULL,
        color TEXT NOT NULL,
        category_id INTEGER,
        type TEXT NOT NULL,
        target_value REAL NOT NULL,
        unit TEXT NOT NULL,
        frequency TEXT NOT NULL,
        reminder_time TEXT,
        created_at TEXT NOT NULL,
        is_archived INTEGER NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE SET NULL
      )
    ''');

    // Tracker logs table
    await db.execute('''
      CREATE TABLE tracker_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tracker_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        value_logged REAL NOT NULL,
        timestamp TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (tracker_id) REFERENCES trackers (id) ON DELETE CASCADE
      )
    ''');

    // Nutrition entries table
    await db.execute('''
      CREATE TABLE nutrition_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        meal_type TEXT NOT NULL,
        food_name TEXT NOT NULL,
        calories REAL NOT NULL,
        protein REAL NOT NULL,
        carbs REAL NOT NULL,
        fat REAL NOT NULL
      )
    ''');

    // Seed default categories
    await _seedDefaultCategories(db);
  }

  Future _seedDefaultCategories(Database db) async {
    final defaultCategories = [
      Category(name: 'Health', icon: 'healing', color: '#0F766E'),
      Category(name: 'Productivity', icon: 'work_outline', color: '#57534E'),
      Category(name: 'Mindfulness', icon: 'spa', color: '#8B5CF6'),
      Category(name: 'Fitness', icon: 'directions_run', color: '#F97316'),
      Category(name: 'Nutrition', icon: 'local_dining', color: '#16A34A'),
    ];

    for (var cat in defaultCategories) {
      await db.insert('categories', cat.toMap());
    }
  }

  // --- Web Mode Initializer ---
  Future<void> _initWebStorage() async {
    if (_webInitialized) return;
    final prefs = await SharedPreferences.getInstance();

    // Load categories
    final catsJson = prefs.getString('db_categories');
    if (catsJson != null) {
      final List decoded = jsonDecode(catsJson);
      _webCategories = decoded.map((c) => Category.fromMap(c)).toList();
    } else {
      // Seed default categories
      _webCategories = [
        Category(id: 1, name: 'Health', icon: 'healing', color: '#0F766E'),
        Category(id: 2, name: 'Productivity', icon: 'work_outline', color: '#57534E'),
        Category(id: 3, name: 'Mindfulness', icon: 'spa', color: '#8B5CF6'),
        Category(id: 4, name: 'Fitness', icon: 'directions_run', color: '#F97316'),
        Category(id: 5, name: 'Nutrition', icon: 'local_dining', color: '#16A34A'),
      ];
      await _saveWebCategories();
    }

    // Load trackers
    final trackersJson = prefs.getString('db_trackers');
    if (trackersJson != null) {
      final List decoded = jsonDecode(trackersJson);
      _webTrackers = decoded.map((t) => Tracker.fromMap(t)).toList();
    }

    // Load logs
    final logsJson = prefs.getString('db_logs');
    if (logsJson != null) {
      final List decoded = jsonDecode(logsJson);
      _webLogs = decoded.map((l) => TrackerLog.fromMap(l)).toList();
    }

    // Load nutrition entries
    final nutritionJson = prefs.getString('db_nutrition');
    if (nutritionJson != null) {
      final List decoded = jsonDecode(nutritionJson);
      _webNutritionEntries = decoded.map((n) => NutritionEntry.fromMap(n)).toList();
    }

    _webInitialized = true;
  }

  Future<void> _saveWebCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('db_categories', jsonEncode(_webCategories.map((c) => c.toMap()).toList()));
  }

  Future<void> _saveWebTrackers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('db_trackers', jsonEncode(_webTrackers.map((t) => t.toMap()).toList()));
  }

  Future<void> _saveWebLogs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('db_logs', jsonEncode(_webLogs.map((l) => l.toMap()).toList()));
  }

  Future<void> _saveWebNutrition() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('db_nutrition', jsonEncode(_webNutritionEntries.map((n) => n.toMap()).toList()));
  }

  // --- Category CRUD ---
  Future<int> insertCategory(Category category) async {
    if (_isWebMode) {
      await _initWebStorage();
      final newId = _webCategories.isEmpty ? 1 : (_webCategories.map((c) => c.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      final newCat = Category(
        id: newId,
        name: category.name,
        icon: category.icon,
        color: category.color,
      );
      _webCategories.add(newCat);
      await _saveWebCategories();
      return newId;
    }

    final db = await database;
    return await db!.insert('categories', category.toMap());
  }

  Future<List<Category>> getAllCategories() async {
    if (_isWebMode) {
      await _initWebStorage();
      return List.from(_webCategories);
    }

    final db = await database;
    final result = await db!.query('categories');
    return result.map((json) => Category.fromMap(json)).toList();
  }

  Future<int> updateCategory(Category category) async {
    if (_isWebMode) {
      await _initWebStorage();
      final index = _webCategories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        _webCategories[index] = category;
        await _saveWebCategories();
        return 1;
      }
      return 0;
    }

    final db = await database;
    return await db!.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> deleteCategory(int id) async {
    if (_isWebMode) {
      await _initWebStorage();
      _webCategories.removeWhere((c) => c.id == id);
      // Null out category references in trackers
      for (int i = 0; i < _webTrackers.length; i++) {
        if (_webTrackers[i].categoryId == id) {
          final t = _webTrackers[i];
          _webTrackers[i] = Tracker(
            id: t.id,
            name: t.name,
            icon: t.icon,
            color: t.color,
            categoryId: null,
            type: t.type,
            targetValue: t.targetValue,
            unit: t.unit,
            frequency: t.frequency,
            reminderTime: t.reminderTime,
            createdAt: t.createdAt,
            isArchived: t.isArchived,
          );
        }
      }
      await _saveWebCategories();
      await _saveWebTrackers();
      return 1;
    }

    final db = await database;
    return await db!.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Tracker CRUD ---
  Future<int> insertTracker(Tracker tracker) async {
    if (_isWebMode) {
      await _initWebStorage();
      final newId = _webTrackers.isEmpty ? 1 : (_webTrackers.map((t) => t.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      final newTracker = Tracker(
        id: newId,
        name: tracker.name,
        icon: tracker.icon,
        color: tracker.color,
        categoryId: tracker.categoryId,
        type: tracker.type,
        targetValue: tracker.targetValue,
        unit: tracker.unit,
        frequency: tracker.frequency,
        reminderTime: tracker.reminderTime,
        createdAt: tracker.createdAt,
        isArchived: tracker.isArchived,
      );
      _webTrackers.add(newTracker);
      await _saveWebTrackers();
      return newId;
    }

    final db = await database;
    return await db!.insert('trackers', tracker.toMap());
  }

  Future<List<Tracker>> getAllTrackers({bool includeArchived = false}) async {
    if (_isWebMode) {
      await _initWebStorage();
      if (includeArchived) return List.from(_webTrackers);
      return _webTrackers.where((t) => !t.isArchived).toList();
    }

    final db = await database;
    final whereClause = includeArchived ? null : 'is_archived = 0';
    final result = await db!.query('trackers', where: whereClause);
    return result.map((json) => Tracker.fromMap(json)).toList();
  }

  Future<Tracker?> getTrackerById(int id) async {
    if (_isWebMode) {
      await _initWebStorage();
      final list = _webTrackers.where((t) => t.id == id).toList();
      return list.isNotEmpty ? list.first : null;
    }

    final db = await database;
    final result = await db!.query(
      'trackers',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Tracker.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateTracker(Tracker tracker) async {
    if (_isWebMode) {
      await _initWebStorage();
      final index = _webTrackers.indexWhere((t) => t.id == tracker.id);
      if (index != -1) {
        _webTrackers[index] = tracker;
        await _saveWebTrackers();
        return 1;
      }
      return 0;
    }

    final db = await database;
    return await db!.update(
      'trackers',
      tracker.toMap(),
      where: 'id = ?',
      whereArgs: [tracker.id],
    );
  }

  Future<int> deleteTracker(int id) async {
    if (_isWebMode) {
      await _initWebStorage();
      _webTrackers.removeWhere((t) => t.id == id);
      _webLogs.removeWhere((l) => l.trackerId == id);
      await _saveWebTrackers();
      await _saveWebLogs();
      return 1;
    }

    final db = await database;
    return await db!.delete(
      'trackers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- TrackerLog CRUD ---
  Future<int> insertTrackerLog(TrackerLog log) async {
    if (_isWebMode) {
      await _initWebStorage();
      final newId = _webLogs.isEmpty ? 1 : (_webLogs.map((l) => l.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      final newLog = TrackerLog(
        id: newId,
        trackerId: log.trackerId,
        date: log.date,
        valueLogged: log.valueLogged,
        timestamp: log.timestamp,
        note: log.note,
      );
      _webLogs.add(newLog);
      await _saveWebLogs();
      return newId;
    }

    final db = await database;
    return await db!.insert('tracker_logs', log.toMap());
  }

  Future<List<TrackerLog>> getLogsForTracker(int trackerId) async {
    if (_isWebMode) {
      await _initWebStorage();
      final list = _webLogs.where((l) => l.trackerId == trackerId).toList();
      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    }

    final db = await database;
    final result = await db!.query(
      'tracker_logs',
      where: 'tracker_id = ?',
      orderBy: 'timestamp DESC',
      whereArgs: [trackerId],
    );
    return result.map((json) => TrackerLog.fromMap(json)).toList();
  }

  Future<List<TrackerLog>> getLogsForDate(String date) async {
    if (_isWebMode) {
      await _initWebStorage();
      return _webLogs.where((l) => l.date == date).toList();
    }

    final db = await database;
    final result = await db!.query(
      'tracker_logs',
      where: 'date = ?',
      whereArgs: [date],
    );
    return result.map((json) => TrackerLog.fromMap(json)).toList();
  }

  Future<List<TrackerLog>> getAllLogs() async {
    if (_isWebMode) {
      await _initWebStorage();
      final list = List<TrackerLog>.from(_webLogs);
      list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return list;
    }

    final db = await database;
    final result = await db!.query('tracker_logs', orderBy: 'timestamp DESC');
    return result.map((json) => TrackerLog.fromMap(json)).toList();
  }

  Future<int> deleteTrackerLog(int id) async {
    if (_isWebMode) {
      await _initWebStorage();
      _webLogs.removeWhere((l) => l.id == id);
      await _saveWebLogs();
      return 1;
    }

    final db = await database;
    return await db!.delete(
      'tracker_logs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteLogsForTrackerAndDate(int trackerId, String date) async {
    if (_isWebMode) {
      await _initWebStorage();
      _webLogs.removeWhere((l) => l.trackerId == trackerId && l.date == date);
      await _saveWebLogs();
      return 1;
    }

    final db = await database;
    return await db!.delete(
      'tracker_logs',
      where: 'tracker_id = ? AND date = ?',
      whereArgs: [trackerId, date],
    );
  }

  // --- NutritionEntry CRUD ---
  Future<int> insertNutritionEntry(NutritionEntry entry) async {
    if (_isWebMode) {
      await _initWebStorage();
      final newId = _webNutritionEntries.isEmpty ? 1 : (_webNutritionEntries.map((n) => n.id ?? 0).reduce((a, b) => a > b ? a : b) + 1);
      final newEntry = NutritionEntry(
        id: newId,
        date: entry.date,
        mealType: entry.mealType,
        foodName: entry.foodName,
        calories: entry.calories,
        protein: entry.protein,
        carbs: entry.carbs,
        fat: entry.fat,
      );
      _webNutritionEntries.add(newEntry);
      await _saveWebNutrition();
      return newId;
    }

    final db = await database;
    return await db!.insert('nutrition_entries', entry.toMap());
  }

  Future<List<NutritionEntry>> getNutritionEntriesForDate(String date) async {
    if (_isWebMode) {
      await _initWebStorage();
      return _webNutritionEntries.where((n) => n.date == date).toList();
    }

    final db = await database;
    final result = await db!.query(
      'nutrition_entries',
      where: 'date = ?',
      whereArgs: [date],
    );
    return result.map((json) => NutritionEntry.fromMap(json)).toList();
  }

  Future<List<NutritionEntry>> getAllNutritionEntries() async {
    if (_isWebMode) {
      await _initWebStorage();
      final list = List<NutritionEntry>.from(_webNutritionEntries);
      list.sort((a, b) => b.date.compareTo(a.date));
      return list;
    }

    final db = await database;
    final result = await db!.query('nutrition_entries', orderBy: 'date DESC');
    return result.map((json) => NutritionEntry.fromMap(json)).toList();
  }

  Future<int> deleteNutritionEntry(int id) async {
    if (_isWebMode) {
      await _initWebStorage();
      _webNutritionEntries.removeWhere((n) => n.id == id);
      await _saveWebNutrition();
      return 1;
    }

    final db = await database;
    return await db!.delete(
      'nutrition_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // --- Global Administration ---
  Future<void> clearAllData() async {
    if (_isWebMode) {
      await _initWebStorage();
      _webTrackers.clear();
      _webLogs.clear();
      _webNutritionEntries.clear();
      _webCategories = [
        Category(id: 1, name: 'Health', icon: 'healing', color: '#0F766E'),
        Category(id: 2, name: 'Productivity', icon: 'work_outline', color: '#57534E'),
        Category(id: 3, name: 'Mindfulness', icon: 'spa', color: '#8B5CF6'),
        Category(id: 4, name: 'Fitness', icon: 'directions_run', color: '#F97316'),
        Category(id: 5, name: 'Nutrition', icon: 'local_dining', color: '#16A34A'),
      ];
      await _saveWebCategories();
      await _saveWebTrackers();
      await _saveWebLogs();
      await _saveWebNutrition();
      return;
    }

    final db = await database;
    await db!.transaction((txn) async {
      await txn.delete('tracker_logs');
      await txn.delete('trackers');
      await txn.delete('nutrition_entries');
      await txn.delete('categories');
      // Re-seed default categories
      final defaultCategories = [
        Category(name: 'Health', icon: 'healing', color: '#0F766E'),
        Category(name: 'Productivity', icon: 'work_outline', color: '#57534E'),
        Category(name: 'Mindfulness', icon: 'spa', color: '#8B5CF6'),
        Category(name: 'Fitness', icon: 'directions_run', color: '#F97316'),
        Category(name: 'Nutrition', icon: 'local_dining', color: '#16A34A'),
      ];
      for (var cat in defaultCategories) {
        await txn.insert('categories', cat.toMap());
      }
    });
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
