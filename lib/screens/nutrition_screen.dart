import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/tracker_provider.dart';
import '../models/nutrition_entry.dart';
import '../widgets/theme.dart';
import '../helpers/database_helper.dart';

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  final double _calorieGoal = 2000.0;
  final double _proteinGoal = 130.0; // grams
  final double _carbsGoal = 250.0;   // grams
  final double _fatGoal = 70.0;      // grams

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackerProvider>(context);
    final entries = provider.nutritionEntries;

    // Calculate totals
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (var entry in entries) {
      totalCalories += entry.calories;
      totalProtein += entry.protein;
      totalCarbs += entry.carbs;
      totalFat += entry.fat;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nutrition Tracker"),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calorie Ring & Macro Summary Card
                  _buildCalorieMacroHeader(context, totalCalories, totalProtein, totalCarbs, totalFat, primaryColor),
                  const SizedBox(height: 24),

                  // Meal sections
                  _buildMealSection(context, "Breakfast", entries, provider),
                  const SizedBox(height: 12),
                  _buildMealSection(context, "Lunch", entries, provider),
                  const SizedBox(height: 12),
                  _buildMealSection(context, "Dinner", entries, provider),
                  const SizedBox(height: 12),
                  _buildMealSection(context, "Snacks", entries, provider),
                  const SizedBox(height: 24),

                  // Calorie Trend Line Chart
                  _buildCalorieTrendChart(context, provider),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildCalorieMacroHeader(
    BuildContext context,
    double totalCalories,
    double totalProtein,
    double totalCarbs,
    double totalFat,
    Color accent,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = (totalCalories / _calorieGoal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.darkOutline : AppColors.lightDivider),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Circular progress ring
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                      color: accent,
                      strokeCap: StrokeCap.round,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${totalCalories.toInt()}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                          Text(
                            "/ ${_calorieGoal.toInt()}",
                            style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Calories Summary",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      totalCalories <= _calorieGoal
                          ? "${(_calorieGoal - totalCalories).toInt()} kcal remaining"
                          : "${(totalCalories - _calorieGoal).toInt()} kcal over budget",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: totalCalories <= _calorieGoal ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          // Macro breakdown rows
          _buildMacroRow(context, "Protein", totalProtein, _proteinGoal, Colors.redAccent),
          const SizedBox(height: 8),
          _buildMacroRow(context, "Carbs", totalCarbs, _carbsGoal, Colors.blueAccent),
          const SizedBox(height: 8),
          _buildMacroRow(context, "Fat", totalFat, _fatGoal, Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _buildMacroRow(BuildContext context, String label, double current, double goal, Color color) {
    final percent = (current / goal).clamp(0.0, 1.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 72,
          child: Text(
            "${current.toInt()}g / ${goal.toInt()}g",
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildMealSection(
    BuildContext context,
    String mealType,
    List<NutritionEntry> entries,
    TrackerProvider provider,
  ) {
    final mealEntries = entries.where((e) => e.mealType == mealType).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    double mealCalories = 0;
    for (var e in mealEntries) {
      mealCalories += e.calories;
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkOutline : AppColors.lightDivider),
      ),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              mealType,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Text(
              "${mealCalories.toInt()} kcal",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
        ),
        shape: const Border(),
        children: [
          if (mealEntries.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mealEntries.length,
              itemBuilder: (context, index) {
                final entry = mealEntries[index];
                return ListTile(
                  dense: true,
                  title: Text(entry.foodName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("P: ${entry.protein.toInt()}g • C: ${entry.carbs.toInt()}g • F: ${entry.fat.toInt()}g"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${entry.calories.toInt()} kcal", style: const TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                        onPressed: () => provider.deleteNutritionEntry(entry.id!),
                      )
                    ],
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0, top: 4.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text("Add Food", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _showAddFoodDialog(context, mealType, provider),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showAddFoodDialog(BuildContext context, String mealType, TrackerProvider provider) {
    final foodController = TextEditingController();
    final calController = TextEditingController();
    final proteinController = TextEditingController();
    final carbController = TextEditingController();
    final fatController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add to $mealType"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: foodController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: "Food Name", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: calController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Calories (kcal)", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: proteinController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Protein (g)", border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: carbController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Carbs (g)", border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: fatController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Fat (g)", border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Log Food"),
            onPressed: () {
              if (foodController.text.trim().isEmpty || calController.text.trim().isEmpty) return;

              final entry = NutritionEntry(
                date: provider.selectedDateStr,
                mealType: mealType,
                foodName: foodController.text.trim(),
                calories: double.parse(calController.text),
                protein: double.tryParse(proteinController.text) ?? 0.0,
                carbs: double.tryParse(carbController.text) ?? 0.0,
                fat: double.tryParse(fatController.text) ?? 0.0,
              );

              provider.addNutritionEntry(entry);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieTrendChart(BuildContext context, TrackerProvider provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = DateTime.now();
    final List<FlSpot> spots = [];

    // Calculate total calories for each of the last 7 days asynchronously or inline
    // Since provider caches all nutrition entries or logs, wait, we can do a local query if needed,
    // but for simplicity we can query all nutrition entries from DatabaseHelper
    // Let's implement trend chart spots using a FutureBuilder or a simple DB read!
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "7-Day Calorie Trend",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<NutritionEntry>>(
              future: DatabaseHelper.instance.getAllNutritionEntries(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
                }
                
                final allEntries = snapshot.data!;
                final Map<String, double> calorieMap = {};
                for (var entry in allEntries) {
                  calorieMap[entry.date] = (calorieMap[entry.date] ?? 0.0) + entry.calories;
                }

                for (int i = 6; i >= 0; i--) {
                  final date = today.subtract(Duration(days: i));
                  final dateStr = DateFormat('yyyy-MM-dd').format(date);
                  final cals = calorieMap[dateStr] ?? 0.0;
                  spots.add(FlSpot((6 - i).toDouble(), cals));
                }

                return SizedBox(
                  height: 140,
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              final date = today.subtract(Duration(days: 6 - index));
                              return Text(
                                DateFormat('E').format(date),
                                style: const TextStyle(fontSize: 9),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                          barWidth: 3,
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
