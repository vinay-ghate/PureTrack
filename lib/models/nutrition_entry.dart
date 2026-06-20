class NutritionEntry {
  final int? id;
  final String date; // YYYY-MM-DD
  final String mealType; // Breakfast, Lunch, Dinner, Snack
  final String foodName;
  final double calories;
  final double protein; // grams
  final double carbs; // grams
  final double fat; // grams

  NutritionEntry({
    this.id,
    required this.date,
    required this.mealType,
    required this.foodName,
    required this.calories,
    this.protein = 0.0,
    this.carbs = 0.0,
    this.fat = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'date': date,
      'meal_type': mealType,
      'food_name': foodName,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
    };
  }

  factory NutritionEntry.fromMap(Map<String, dynamic> map) {
    return NutritionEntry(
      id: map['id'] as int?,
      date: map['date'] as String,
      mealType: map['meal_type'] as String,
      foodName: map['food_name'] as String,
      calories: (map['calories'] as num).toDouble(),
      protein: (map['protein'] as num).toDouble(),
      carbs: (map['carbs'] as num).toDouble(),
      fat: (map['fat'] as num).toDouble(),
    );
  }
}
