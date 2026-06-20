import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/tracker_provider.dart';
import '../models/tracker.dart';
import '../models/tracker_log.dart';
import '../helpers/icon_helper.dart';
import '../widgets/theme.dart';

class TimerTrackingScreen extends StatefulWidget {
  final Tracker tracker;

  const TimerTrackingScreen({super.key, required this.tracker});

  @override
  State<TimerTrackingScreen> createState() => _TimerTrackingScreenState();
}

class _TimerTrackingScreenState extends State<TimerTrackingScreen> {
  Timer? _timer;
  int _secondsRemaining = 0;
  int _targetSeconds = 1200; // 20 mins default
  bool _isRunning = false;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _targetSeconds = (widget.tracker.targetValue * 60).toInt();
    _secondsRemaining = _targetSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;
    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          _secondsElapsed++;
        } else {
          // Completed target duration
          _timer?.cancel();
          _isRunning = false;
          _showCompletionDialog();
        }
      });
    });
  }

  void _pauseTimer() {
    if (!_isRunning) return;
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _stopAndSaveTimer(TrackerProvider provider) {
    _timer?.cancel();
    _isRunning = false;

    final elapsedMinutes = _secondsElapsed / 60.0;
    if (elapsedMinutes >= 0.1) {
      provider.logValue(
        widget.tracker.id!,
        elapsedMinutes,
        DateTime.now(),
        note: "Timer session: ${(_secondsElapsed ~/ 60)}m ${(_secondsElapsed % 60)}s",
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logged session of ${elapsedMinutes.toStringAsFixed(1)} minutes!"),
          backgroundColor: AppColors.getColorFromHex(widget.tracker.color),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Session too short to save (under 6 seconds)")),
      );
    }

    setState(() {
      _secondsRemaining = _targetSeconds;
      _secondsElapsed = 0;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Goal Achieved! 🏆"),
        content: Text("Great job! You have completed your target duration of ${widget.tracker.targetValue} minutes for ${widget.tracker.name}."),
        actions: [
          TextButton(
            child: const Text("Awesome"),
            onPressed: () {
              Navigator.pop(context);
              // Save completion log
              final provider = Provider.of<TrackerProvider>(context, listen: false);
              _stopAndSaveTimer(provider);
            },
          ),
        ],
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackerProvider>(context);
    final trackerColor = AppColors.getColorFromHex(widget.tracker.color);

    // Calculate today's total time
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayLoggedMins = provider.getLoggedValueForDate(widget.tracker.id!, todayStr);

    // Calculate weekly total
    double weeklyTotal = 0.0;
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      weeklyTotal += provider.getLoggedValueForDate(widget.tracker.id!, dateStr);
    }

    final streakStats = provider.getStreakStats(widget.tracker);
    final currentStreak = streakStats['current'] ?? 0;

    final double progressPercent = _targetSeconds > 0 
        ? (_secondsRemaining / _targetSeconds).clamp(0.0, 1.0) 
        : 0.0;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tracker.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Large circular countdown timer
            Expanded(
              child: Center(
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: progressPercent,
                        strokeWidth: 12,
                        backgroundColor: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                        color: trackerColor,
                        strokeCap: StrokeCap.round,
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _formatDuration(_secondsRemaining),
                              style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'SpaceGrotesk',
                                color: isDark ? AppColors.darkPrimaryText : AppColors.lightPrimaryText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Remaining / ${widget.tracker.targetValue.toStringAsFixed(0)}m",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Today, Weekly & Streak Stats Panel
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.darkOutline : AppColors.lightDivider),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTimerStat("TODAY", "${todayLoggedMins.toStringAsFixed(1)}m"),
                  Container(width: 1, height: 32, color: isDark ? AppColors.darkOutline : AppColors.lightDivider),
                  _buildTimerStat("THIS WEEK", "${weeklyTotal.toStringAsFixed(1)}m"),
                  Container(width: 1, height: 32, color: isDark ? AppColors.darkOutline : AppColors.lightDivider),
                  _buildTimerStat("STREAK", "$currentStreak 🔥"),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // Controls Block
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Reset / Cancel Session
                IconButton.outlined(
                  icon: const Icon(Icons.refresh, size: 28),
                  onPressed: () {
                    _timer?.cancel();
                    setState(() {
                      _isRunning = false;
                      _secondsRemaining = _targetSeconds;
                      _secondsElapsed = 0;
                    });
                  },
                ),
                const SizedBox(width: 24),
                // Play / Pause Circle Button
                GestureDetector(
                  onTap: _isRunning ? _pauseTimer : _startTimer,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: trackerColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: trackerColor.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                // Stop & Save
                IconButton.outlined(
                  icon: const Icon(Icons.stop, size: 28),
                  onPressed: _secondsElapsed > 0 ? () => _stopAndSaveTimer(provider) : null,
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
