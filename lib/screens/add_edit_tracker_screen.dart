import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/tracker_provider.dart';
import '../models/tracker.dart';
import '../models/category.dart';
import '../helpers/icon_helper.dart';
import '../helpers/notification_helper.dart';
import '../widgets/theme.dart';

class AddEditTrackerScreen extends StatefulWidget {
  final Tracker? tracker; // null for add mode

  const AddEditTrackerScreen({super.key, this.tracker});

  @override
  State<AddEditTrackerScreen> createState() => _AddEditTrackerScreenState();
}

class _AddEditTrackerScreenState extends State<AddEditTrackerScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late String _name;
  late TrackerType _selectedType;
  late String _selectedIcon;
  late String _selectedColor;
  int? _selectedCategoryId;
  
  // Type-specific inputs
  double _targetValue = 1.0;
  String _unit = 'done';
  String _frequency = 'Daily';
  DateTime? _deadline;
  
  // Custom weekdays for frequency
  final Map<String, bool> _weekdays = {
    'Monday': true,
    'Tuesday': true,
    'Wednesday': true,
    'Thursday': true,
    'Friday': true,
    'Saturday': true,
    'Sunday': true,
  };

  // Reminder Inputs
  bool _enableReminder = false;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);

  final List<String> _presetColors = [
    '#0F766E', // Teal
    '#57534E', // Stone
    '#8B5CF6', // Purple
    '#F97316', // Orange
    '#16A34A', // Green
    '#EF4444', // Red
    '#3B82F6', // Blue
    '#EC4899', // Pink
  ];

  @override
  void initState() {
    super.initState();
    final t = widget.tracker;
    if (t != null) {
      _name = t.name;
      _selectedType = t.type;
      _selectedIcon = t.icon;
      _selectedColor = t.color;
      _selectedCategoryId = t.categoryId;
      _targetValue = t.targetValue;
      _unit = t.unit;
      _frequency = t.frequency;
      
      // Parse weekdays if frequency contains weekdays
      if (t.frequency.startsWith('Custom:')) {
        final activeDays = t.frequency.replaceFirst('Custom:', '').split(',');
        _weekdays.updateAll((key, value) => activeDays.contains(key));
      }

      _enableReminder = t.reminderTime != null;
      if (t.reminderTime != null) {
        final parts = t.reminderTime!.split(':');
        _reminderTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } else {
      _name = '';
      _selectedType = TrackerType.habit;
      _selectedIcon = 'healing';
      _selectedColor = '#0F766E';
      _unit = 'done';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackerProvider>(context);
    final categories = provider.categories;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tracker == null ? "Create Tracker" : "Edit Tracker"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Selector for Tracker Type
              Center(
                child: SegmentedButton<TrackerType>(
                  segments: const [
                    ButtonSegment(value: TrackerType.habit, label: Text('Habit')),
                    ButtonSegment(value: TrackerType.counter, label: Text('Counter')),
                    ButtonSegment(value: TrackerType.goal, label: Text('Goal')),
                    ButtonSegment(value: TrackerType.timer, label: Text('Timer')),
                  ],
                  selected: {_selectedType},
                  showSelectedIcon: false,
                  onSelectionChanged: (newSelection) {
                    setState(() {
                      _selectedType = newSelection.first;
                      // Default units and targets based on type
                      if (_selectedType == TrackerType.habit) {
                        _unit = 'done';
                        _targetValue = 1.0;
                      } else if (_selectedType == TrackerType.counter) {
                        _unit = 'glasses';
                        _targetValue = 8.0;
                      } else if (_selectedType == TrackerType.goal) {
                        _unit = 'pages';
                        _targetValue = 30.0;
                      } else if (_selectedType == TrackerType.timer) {
                        _unit = 'mins';
                        _targetValue = 20.0;
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Name input
              TextFormField(
                initialValue: _name,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                decoration: const InputDecoration(
                  labelText: "Tracker Name",
                  hintText: "e.g. Drink water, Read a book...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? "Name cannot be empty" : null,
                onSaved: (val) => _name = val!.trim(),
              ),
              const SizedBox(height: 16),

              // Category dropdown + inline creation
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int?>(
                      value: _selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: "Category",
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text("None")),
                        ...categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _selectedCategoryId = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.add),
                    onPressed: () => _createNewCategoryDialog(context, provider),
                  )
                ],
              ),
              const SizedBox(height: 20),

              // Color picker selection
              const Text("Theme Color", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _presetColors.length,
                  itemBuilder: (context, index) {
                    final colorHex = _presetColors[index];
                    final color = AppColors.getColorFromHex(colorHex);
                    final isSelected = _selectedColor == colorHex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = colorHex;
                        });
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? (isDark ? Colors.white : Colors.black)
                                : Colors.transparent,
                            width: 2.5,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 18)
                            : null,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Icon picker selection
              const Text("Tracker Icon", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: IconHelper.getAvailableIcons().length,
                  itemBuilder: (context, index) {
                    final iconName = IconHelper.getAvailableIcons()[index];
                    final isSelected = _selectedIcon == iconName;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = iconName;
                        });
                      },
                      child: Container(
                        width: 44,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.getColorFromHex(_selectedColor).withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.getColorFromHex(_selectedColor)
                                : (isDark ? AppColors.darkOutline : AppColors.lightOutline),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          IconHelper.getIcon(iconName),
                          color: isSelected
                              ? AppColors.getColorFromHex(_selectedColor)
                              : (isDark ? AppColors.darkSecondaryText : AppColors.lightSecondaryText),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              const Divider(),
              const SizedBox(height: 12),

              // Conditional sections based on Tracker Type
              if (_selectedType == TrackerType.habit) ...[
                const Text("Frequency Configuration", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                _buildWeekdayPicker(context),
              ] else if (_selectedType == TrackerType.counter) ...[
                const Text("Counter Target Configuration", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _targetValue.toStringAsFixed(0),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Target Value",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || double.tryParse(val) == null ? "Enter valid number" : null,
                        onSaved: (val) => _targetValue = double.parse(val!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: _unit,
                        decoration: const InputDecoration(
                          labelText: "Unit (e.g., glasses, steps)",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? "Unit cannot be empty" : null,
                        onSaved: (val) => _unit = val!.trim(),
                      ),
                    ),
                  ],
                ),
              ] else if (_selectedType == TrackerType.goal) ...[
                const Text("Goal Configuration", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _targetValue.toStringAsFixed(0),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Target Value",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || double.tryParse(val) == null ? "Enter valid number" : null,
                        onSaved: (val) => _targetValue = double.parse(val!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: _unit,
                        decoration: const InputDecoration(
                          labelText: "Unit (e.g., pages, kcal)",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? "Unit cannot be empty" : null,
                        onSaved: (val) => _unit = val!.trim(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _deadline == null
                          ? "Set Deadline (Optional)"
                          : "Deadline: ${DateFormat('MMM d, y').format(_deadline!)}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    OutlinedButton(
                      child: const Text("Select Date"),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 30)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 3650)),
                        );
                        if (date != null) {
                          setState(() {
                            _deadline = date;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ] else if (_selectedType == TrackerType.timer) ...[
                const Text("Timer Target Configuration", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _targetValue.toStringAsFixed(0),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Target Duration (minutes)",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || double.tryParse(val) == null ? "Enter valid number" : null,
                        onSaved: (val) => _targetValue = double.parse(val!),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: _unit,
                        decoration: const InputDecoration(
                          labelText: "Unit",
                          border: OutlineInputBorder(),
                          enabled: false,
                        ),
                        onSaved: (val) => _unit = 'mins',
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),

              const Divider(),
              const SizedBox(height: 12),

              // Reminders section
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Daily Reminder Notification", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text("Schedule a local notification reminder daily"),
                value: _enableReminder,
                onChanged: (val) {
                  setState(() {
                    _enableReminder = val;
                  });
                },
              ),
              if (_enableReminder)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Reminder Time: ${_reminderTime.format(context)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    OutlinedButton(
                      child: const Text("Pick Time"),
                      onPressed: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _reminderTime,
                        );
                        if (time != null) {
                          setState(() {
                            _reminderTime = time;
                          });
                        }
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.getColorFromHex(_selectedColor),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    widget.tracker == null ? "Create Tracker" : "Save Changes",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => _saveTracker(provider),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeekdayPicker(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: _weekdays.keys.map((day) {
        final active = _weekdays[day]!;
        final color = AppColors.getColorFromHex(_selectedColor);
        return FilterChip(
          label: Text(day.substring(0, 3)),
          selected: active,
          onSelected: (val) {
            setState(() {
              _weekdays[day] = val;
            });
          },
          selectedColor: color.withOpacity(0.15),
          checkmarkColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        );
      }).toList(),
    );
  }

  void _createNewCategoryDialog(BuildContext context, TrackerProvider provider) {
    final catNameController = TextEditingController();
    String newCatColor = '#0F766E';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Category"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: catNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: "Category Name",
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
          ElevatedButton(
            child: const Text("Create"),
            onPressed: () {
              if (catNameController.text.trim().isEmpty) return;
              final newCat = Category(
                name: catNameController.text.trim(),
                icon: 'healing',
                color: newCatColor,
              );
              provider.addCategory(newCat);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveTracker(TrackerProvider provider) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    // Determine frequency string
    String freqStr = 'Daily';
    if (_selectedType == TrackerType.habit) {
      final selectedDays = _weekdays.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .join(',');
      if (selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select at least one active day")),
        );
        return;
      }
      if (selectedDays == _weekdays.keys.join(',')) {
        freqStr = 'Daily';
      } else {
        freqStr = 'Custom:$selectedDays';
      }
    }

    final reminderStr = _enableReminder
        ? "${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}"
        : null;

    final trackerId = widget.tracker?.id;

    final newTracker = Tracker(
      id: trackerId,
      name: _name,
      icon: _selectedIcon,
      color: _selectedColor,
      categoryId: _selectedCategoryId,
      type: _selectedType,
      targetValue: _targetValue,
      unit: _unit,
      frequency: freqStr,
      reminderTime: reminderStr,
      createdAt: widget.tracker?.createdAt ?? DateTime.now(),
      isArchived: widget.tracker?.isArchived ?? false,
    );

    // Cancel old notification if edit mode
    if (trackerId != null) {
      await NotificationHelper.instance.cancelNotification(trackerId);
      await provider.updateTracker(newTracker);
    } else {
      // For new tracker, we will add it first to get an auto-increment ID
      await provider.addTracker(newTracker);
    }

    // Schedule notification for saved tracker
    if (_enableReminder) {
      // Find the saved tracker from list to ensure we have the correct ID
      final saved = provider.trackers.firstWhere((t) => t.name == _name && t.color == _selectedColor, orElse: () => newTracker);
      if (saved.id != null) {
        await NotificationHelper.instance.scheduleDailyNotification(
          id: saved.id!,
          title: "Time for ${saved.name}!",
          body: "Don't forget to log progress towards your goal today.",
          hour: _reminderTime.hour,
          minute: _reminderTime.minute,
          payload: saved.id!.toString(),
        );
      }
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
