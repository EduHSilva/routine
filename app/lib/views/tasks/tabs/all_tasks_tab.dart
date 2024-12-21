import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../config/helper.dart';
import '../../../models/tasks/task_model.dart';
import '../../../view_models/tasks_viewmodel.dart';
import '../../../widgets/task_card.dart';

class AllTasksTab extends StatefulWidget {
  const AllTasksTab({super.key});

  @override
  AllTasksTabState createState() => AllTasksTabState();
}

class AllTasksTabState extends State<AllTasksTab> {
  final TasksViewModel _tasksViewModel = TasksViewModel();
  final Map<String, bool> _expandedTasks = {};
  final ValueNotifier<bool> _isDailyView = ValueNotifier<bool>(true);
  DateTime? _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() {
    _tasksViewModel.fetchWeekTasks(_selectedDate);
  }

  void _toggleView() {
    _isDailyView.value = !_isDailyView.value;
    _fetchTasks();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      _fetchTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toggle Button and Date Filter
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: _isDailyView,
                builder: (context, isDaily, child) {
                  return ToggleButtons(
                    borderRadius: BorderRadius.circular(8),
                    selectedColor: Colors.white,
                    fillColor: Theme.of(context).primaryColor,
                    color: Colors.grey,
                    isSelected: [isDaily, !isDaily],
                    onPressed: (index) {
                      if ((index == 0 && !isDaily) || (index == 1 && isDaily)) {
                        _toggleView();
                      }
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Daily'.tr()),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Weekly'.tr()),
                      ),
                    ],
                  );
                },
              ),
              ElevatedButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today_outlined, size: 18),
                label: Text(
                  _selectedDate != null
                      ? DateFormat.yMd().format(_selectedDate!)
                      : 'Pick Date'.tr(),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Task Views
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: _isDailyView,
            builder: (context, isDaily, child) {
              return isDaily ? _buildDailyTasksView() : _buildWeeklyTasksView();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyTasksView() {
    return ValueListenableBuilder(
      valueListenable: _tasksViewModel.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ValueListenableBuilder<List<Task>>(
          valueListenable: _tasksViewModel.dailyTasks,
          builder: (context, dailyTasks, child) {
            return dailyTasks.isEmpty
                ? Center(child: Text('noData'.tr()))
                : ListView.builder(
                    itemCount: dailyTasks.length,
                    itemBuilder: (context, index) {
                      var task = dailyTasks[index];
                      return Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: TaskCard(
                            title: task.title,
                            category: task.category.tr(),
                            startTime: task.startTime,
                            endTime: task.endTime,
                            isDone: task.done,
                            color: hexaToColor(task.color),
                            onChanged: (value) {
                              _tasksViewModel.changeTaskStatus(task);
                            },
                          ));
                    },
                  );
          },
        );
      },
    );
  }

  Widget _buildWeeklyTasksView() {
    return ValueListenableBuilder(
      valueListenable: _tasksViewModel.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ValueListenableBuilder<Map<String, List<Task>>>(
          valueListenable: _tasksViewModel.weekTasks,
          builder: (context, weekTasks, child) {
            return weekTasks.isEmpty
                ? Center(child: Text('noData'.tr()))
                : ListView.builder(
                    itemCount: weekTasks.length,
                    itemBuilder: (context, index) {
                      String title = weekTasks.keys.elementAt(index);
                      List<Task> tasks = weekTasks[title]!;

                      if (index == 0) {
                        _expandedTasks.putIfAbsent(title, () => true);
                      } else {
                        _expandedTasks.putIfAbsent(title, () => false);
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _expandedTasks[title] =
                                      !_expandedTasks[title]!;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${formatDate(title)} - ${getDayOfWeek(title).tr()}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      _expandedTasks[title]!
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (_expandedTasks[title]!)
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: tasks.length,
                                itemBuilder: (context, taskIndex) {
                                  var task = tasks[taskIndex];

                                  return TaskCard(
                                    title: task.title,
                                    category: task.category.tr(),
                                    startTime: task.startTime,
                                    endTime: task.endTime,
                                    isDone: task.done,
                                    color: hexaToColor(task.color),
                                    onChanged: (value) {
                                      _tasksViewModel.changeTaskStatus(task);
                                    },
                                  );
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  );
          },
        );
      },
    );
  }
}
