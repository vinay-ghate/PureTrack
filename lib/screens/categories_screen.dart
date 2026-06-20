import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tracker_provider.dart';
import '../models/category.dart';
import '../helpers/icon_helper.dart';
import '../widgets/theme.dart';
import '../models/tracker.dart';
import 'tracker_detail_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TrackerProvider>(context);
    final categories = provider.categories;
    final trackers = provider.trackers;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showAddEditCategoryDialog(context, provider),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : categories.isEmpty
              ? _buildEmptyState(context, provider)
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Manage Categories",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GridView.builder(
                          itemCount: categories.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.3,
                          ),
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            final catTrackers = trackers.where((t) => t.categoryId == cat.id).toList();
                            final catColor = AppColors.getColorFromHex(cat.color);

                            return InkWell(
                              onTap: () => _showCategoryTrackersSheet(context, cat, catTrackers, provider),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurface : Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark ? AppColors.darkOutline : AppColors.lightDivider,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: catColor.withOpacity(0.15),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            IconHelper.getIcon(cat.icon),
                                            color: catColor,
                                            size: 20,
                                          ),
                                        ),
                                        PopupMenuButton<String>(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(Icons.more_vert, size: 18),
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              _showAddEditCategoryDialog(context, provider, category: cat);
                                            } else if (value == 'delete') {
                                              _confirmDeleteCategory(context, provider, cat);
                                            }
                                          },
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: 'edit',
                                              child: Text('Edit'),
                                            ),
                                            const PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cat.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          "${catTrackers.length} active trackers",
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                fontSize: 12,
                                              ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  void _showCategoryTrackersSheet(
    BuildContext context,
    Category category,
    List<Tracker> trackers,
    TrackerProvider provider,
  ) {
    final catColor = AppColors.getColorFromHex(category.color);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bottom sheet handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: catColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      IconHelper.getIcon(category.icon),
                      color: catColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Trackers under ${category.name}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: trackers.isEmpty
                    ? Center(
                        child: Text(
                          "No trackers in this category.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: trackers.length,
                        itemBuilder: (context, index) {
                          final tracker = trackers[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              leading: Icon(
                                IconHelper.getIcon(tracker.icon),
                                color: catColor,
                              ),
                              title: Text(
                                tracker.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${tracker.type.toShortString().toUpperCase()} - ${tracker.frequency}",
                                style: const TextStyle(fontSize: 11),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                              onTap: () {
                                Navigator.pop(context); // Close sheet
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TrackerDetailScreen(tracker: tracker),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddEditCategoryDialog(
    BuildContext context,
    TrackerProvider provider, {
    Category? category,
  }) {
    final nameController = TextEditingController(text: category?.name ?? '');
    String selectedIcon = category?.icon ?? 'healing';
    String selectedColor = category?.color ?? '#0F766E';

    final presetColors = [
      '#0F766E', // Teal
      '#57534E', // Stone
      '#8B5CF6', // Purple
      '#F97316', // Orange
      '#16A34A', // Green
      '#EF4444', // Red
      '#3B82F6', // Blue
      '#EC4899', // Pink
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(category == null ? "Add Category" : "Edit Category"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: "Category Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Select Icon", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: IconHelper.getAvailableIcons().length,
                    itemBuilder: (context, index) {
                      final iconName = IconHelper.getAvailableIcons()[index];
                      final isSelected = selectedIcon == iconName;
                      return Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIcon = iconName;
                            });
                          },
                          child: Container(
                            width: 40,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.grey[200] : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? Colors.teal : Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              IconHelper.getIcon(iconName),
                              color: isSelected ? Colors.teal : Colors.grey[600],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Select Color", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: presetColors.map((colorHex) {
                    final color = AppColors.getColorFromHex(colorHex);
                    final isSelected = selectedColor == colorHex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = colorHex;
                        });
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                    );
                  }).toList(),
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
              child: const Text("Save"),
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;

                final newCat = Category(
                  id: category?.id,
                  name: nameController.text.trim(),
                  icon: selectedIcon,
                  color: selectedColor,
                );

                if (category == null) {
                  provider.addCategory(newCat);
                } else {
                  provider.updateCategory(newCat);
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteCategory(BuildContext context, TrackerProvider provider, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Category"),
        content: Text("Are you sure you want to delete '${category.name}'? Trackers under this category will remain, but their category will be set to None."),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () {
              provider.deleteCategory(category.id!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, TrackerProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.category_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              "No Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Create categories to organize your habits, routines, and goals.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showAddEditCategoryDialog(context, provider),
              icon: const Icon(Icons.add),
              label: const Text("Add Category"),
            ),
          ],
        ),
      ),
    );
  }
}
