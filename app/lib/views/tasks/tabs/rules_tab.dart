import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:routine/config/helper.dart';
import 'package:routine/models/tasks/task_model.dart';
import 'package:routine/views/tasks/new_task_view.dart';

import '../../../config/design_system.dart';
import '../../../viewmodels/tasks_viewmodel.dart';
import '../../../widgets/custom_modal_delete.dart';

class RulesTab extends StatefulWidget {
  const RulesTab({super.key});

  @override
  RulesTabState createState() => RulesTabState();
}

class RulesTabState extends State<RulesTab> {
  final TasksViewModel _tasksViewModel = TasksViewModel();

  @override
  initState() {
    super.initState();
    _tasksViewModel.fetchTasksRules();
  }

  _getRules() async {
    await _tasksViewModel.fetchTasksRules();
  }

  _deleteRule(int id) async {
    TaskResponse? response = await _tasksViewModel.deleteRule(id);
    _handlerResponse(response);
  }

  _deleteRuleDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomModalDelete(
          title: "confirmDelete",
          onConfirm: () {
            _deleteRule(task.id);
          },
        );
      },
    );
  }

  _handlerResponse(TaskResponse? response) {
    if (response?.task != null) {
      _getRules();
    } else {
      if (!mounted) return;
      showErrorBar(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _tasksViewModel.isLoading,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ValueListenableBuilder<List<Task>>(
              valueListenable: _tasksViewModel.tasks,
              builder: (context, tasks, child) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('rules'.tr()),
                    automaticallyImplyLeading: false,
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewTaskView(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  body: tasks.isEmpty
                      ? Center(child: Text('noData'.tr()))
                      : ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
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
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            task.title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      task.category.tr(),
                                                    ),
                                                    Text(formatDate(
                                                        task.dateStart)),
                                                    Text(
                                                        '${task.startTime} - ${task.endTime}'),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      task.priority.tr(),
                                                    ),
                                                    Text(formatDate(
                                                        task.dateEnd)),
                                                    Text(task.frequency!.tr()),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Divider(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () {
                                                  _deleteRuleDialog(task);
                                                },
                                                child: Text(
                                                  'delete'.tr(),
                                                  style: const TextStyle(
                                                      color: AppColors.error),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewTaskView(
                                                              id: task.id),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  'edit'.tr(),
                                                  style: const TextStyle(
                                                      color: AppColors.primary),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                );
              });
        });
  }
}
