import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import '../../../config/helper.dart';
import '../../../models/tasks/task_model.dart';
import '../../../view_models/tasks_viewmodel.dart';

class AllTasksTab extends StatefulWidget {
  const AllTasksTab({super.key});

  @override
  AllTasksTabState createState() => AllTasksTabState();
}

class AllTasksTabState extends State<AllTasksTab> {
  final TasksViewModel _tasksViewModel = TasksViewModel();

  final Map<String, bool> _expandedTasks = {};

  @override
  void initState() {
    super.initState();
    _tasksViewModel.fetchWeekTasks();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _tasksViewModel.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ValueListenableBuilder<Map<String, List<Task>>>(
          valueListenable: _tasksViewModel.weekTasks,
          builder: (context, weekTasks, child) {
            return Scaffold(
              body: weekTasks.isEmpty
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

                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            bottom: 0,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                bottomLeft: Radius.circular(12),
                                              ),
                                              child: Container(
                                                width: 10,
                                                color: hexaToColor(task.color),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Row(
                                              children: [
                                                Checkbox(
                                                  value: task.done,
                                                  onChanged: (value) {
                                                    _tasksViewModel.changeTaskStatus(task);
                                                  },
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        title: Text(
                                                          task.title,
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16),
                                                        ),
                                                        subtitle: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(task
                                                                      .category
                                                                      .tr()),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Text(
                                                                      '${task.startTime} - ${task.endTime}'),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    ),
            );
          },
        );
      },
    );
  }
}
