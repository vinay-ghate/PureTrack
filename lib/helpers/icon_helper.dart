import 'package:flutter/material.dart';

class IconHelper {
  static const Map<String, IconData> _iconMap = {
    'healing': Icons.healing_outlined,
    'work_outline': Icons.work_outline,
    'spa': Icons.spa_outlined,
    'directions_run': Icons.directions_run_outlined,
    'local_dining': Icons.local_dining_outlined,
    'book': Icons.book_outlined,
    'water_drop': Icons.water_drop_outlined,
    'smoke_free': Icons.smoke_free_outlined,
    'bed': Icons.bed_outlined,
    'code': Icons.code_outlined,
    'favorite': Icons.favorite_outline,
    'star': Icons.star_outline,
    'check': Icons.check_circle_outline,
    'timer': Icons.timer_outlined,
    'fitness_center': Icons.fitness_center_outlined,
    'menu_book': Icons.menu_book_outlined,
    'alarm': Icons.alarm_outlined,
    'pets': Icons.pets_outlined,
    'school': Icons.school_outlined,
    'brush': Icons.brush_outlined,
    'sunny': Icons.sunny,
    'nightlight': Icons.nightlight_round_outlined,
    'flight': Icons.flight_outlined,
    'attach_money': Icons.attach_money_outlined,
  };

  static IconData getIcon(String name) {
    return _iconMap[name] ?? Icons.help_outline;
  }

  static List<String> getAvailableIcons() {
    return _iconMap.keys.toList();
  }
}
