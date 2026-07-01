import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../config/design_system.dart';
import '../../config/helper.dart';
import '../../models/health/diet_model.dart';
import '../../models/tasks/task_model.dart';
import '../../view_models/diet_viewmodel.dart';
import '../../view_models/home_viewmodel.dart';
import '../../view_models/tasks_viewmodel.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_modal_delete.dart';
import '../../widgets/meal_card.dart';
import '../../widgets/task_card.dart';
import 'home_ai_chat_view.dart';
import '../health/meal_details.dart';
import '../health/new_meal_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final HomeViewModel _homeViewModel = HomeViewModel();
  final TasksViewModel _tasksViewModel = TasksViewModel();
  final DietViewModel _dietViewModel = DietViewModel();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateUtils.dateOnly(DateTime.now());
    _homeViewModel.getDailyData();
  }

  List<DateTime> get _weekDays {
    final today = DateUtils.dateOnly(DateTime.now());
    final monday = today.subtract(Duration(days: today.weekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  _showDetails(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailView(id: id),
      ),
    );
  }

  _deleteMeal(int id) async {
    MealResponse? response = await _dietViewModel.deleteMeal(id);
    _handlerResponse(response);
  }

  _editMeal(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewMealView(id: id),
      ),
    );
  }

  _deleteMealDialog(Meal meal) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomModalDelete(
          title: "confirmDelete",
          onConfirm: () {
            _deleteMeal(meal.id);
          },
        );
      },
    );
  }

  _handlerResponse(MealResponse? response) {
    if (response?.meal != null) {
      _homeViewModel.getDailyData();
    } else {
      if (!mounted) return;
      showErrorBar(context, response);
    }
  }

  List<Task> _tasksForSelectedDay(List<Task> tasks) {
    final today = DateUtils.dateOnly(DateTime.now());
    if (DateUtils.isSameDay(_selectedDate, today)) return tasks;

    return tasks.where((task) {
      if (task.dateStart == null || task.dateStart!.isEmpty) return false;
      final taskDate = DateTime.tryParse(task.dateStart!);
      return taskDate != null && DateUtils.isSameDay(taskDate, _selectedDate);
    }).toList();
  }

  bool get _isToday => DateUtils.isSameDay(_selectedDate, DateTime.now());

  void _openAssistant() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeAiChatView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _homeViewModel.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: const CustomAppBar(title: 'home'),
          drawer: const CustomDrawer(currentRoute: '/home'),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _openAssistant,
            icon: const Icon(Icons.auto_awesome_outlined),
            label: Text('assistant'.tr()),
          ),
          body: RefreshIndicator(
            onRefresh: _homeViewModel.getDailyData,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _HeaderCard(selectedDate: _selectedDate),
                const SizedBox(height: 16),
                _WeekSelector(
                  days: _weekDays,
                  selectedDate: _selectedDate,
                  onSelected: (date) {
                    setState(() {
                      _selectedDate = DateUtils.dateOnly(date);
                    });
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<List<Task>>(
                  valueListenable: _homeViewModel.tasks,
                  builder: (context, tasks, child) {
                    final filteredTasks = _tasksForSelectedDay(tasks);
                    final completed =
                        filteredTasks.where((task) => task.done).length;
                    return _TaskSection(
                      tasks: filteredTasks,
                      completedTasks: completed,
                      onChanged: (task) async {
                        await _tasksViewModel.changeTaskStatus(task);
                        await _homeViewModel.getDailyData();
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<Meal?>(
                  valueListenable: _homeViewModel.nextMeal,
                  builder: (context, nextMeal, child) {
                    return _MealSection(
                      meal: _isToday ? nextMeal : null,
                      onTap: nextMeal == null
                          ? null
                          : () => _showDetails(nextMeal.id),
                      onEdit: nextMeal == null
                          ? null
                          : () => _editMeal(nextMeal.id),
                      onRemove: nextMeal == null
                          ? null
                          : () => _deleteMealDialog(nextMeal),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final DateTime selectedDate;

  const _HeaderCard({required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat("EEEE, d 'de' MMMM", context.locale.toString())
            .format(selectedDate);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.onBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'dailyPlan'.tr(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.primaryVariant,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            formattedDate,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'dailyPlanSubtitle'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }
}

class _WeekSelector extends StatelessWidget {
  final List<DateTime> days;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelected;

  const _WeekSelector({
    required this.days,
    required this.selectedDate,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = DateUtils.isSameDay(day, selectedDate);
          final isToday = DateUtils.isSameDay(day, DateTime.now());
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onSelected(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 58,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isToday ? AppColors.accent : AppColors.border,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.E(context.locale.toString())
                        .format(day)
                        .substring(0, 3)
                        .toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? AppColors.onPrimary : AppColors.muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.onPrimary
                          : AppColors.onBackground,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TaskSection extends StatelessWidget {
  final List<Task> tasks;
  final int completedTasks;
  final ValueChanged<Task> onChanged;

  const _TaskSection({
    required this.tasks,
    required this.completedTasks,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'pendingTasks'.tr(),
      trailing: tasks.isEmpty ? null : '$completedTasks/${tasks.length}',
      child: tasks.isEmpty
          ? _EmptyState(
              icon: Icons.task_alt_outlined,
              message: 'noTasksPending'.tr(),
            )
          : Column(
              children: tasks.map((task) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TaskCard(
                    title: task.title,
                    category: task.category.tr(),
                    startTime: task.startTime,
                    endTime: task.endTime,
                    isDone: task.done,
                    color: hexaToColor(task.color),
                    onChanged: (_) => onChanged(task),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class _MealSection extends StatelessWidget {
  final Meal? meal;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const _MealSection({
    required this.meal,
    required this.onTap,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'nextMeal'.tr(),
      child: meal == null || meal!.name.isEmpty
          ? _EmptyState(
              icon: Icons.restaurant_menu_outlined,
              message: 'noNextMeal'.tr(),
            )
          : MealCard(
              id: meal!.id,
              name: meal!.name,
              hour: meal!.hour,
              onTap: onTap!,
              onEdit: onEdit!,
              onRemove: onRemove!,
            ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String? trailing;
  final Widget child;

  const _Section({
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              if (trailing != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    trailing!,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.muted),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
