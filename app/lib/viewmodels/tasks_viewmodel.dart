import 'package:flutter/cupertino.dart';
import 'package:routine/models/tasks/task_model.dart';
import 'package:routine/services/tasks_service.dart';

import '../config/app_config.dart';

class TasksViewModel {
  final TasksService _tasksService = TasksService();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String?> errorMessage = ValueNotifier(null);
  ValueNotifier<List<Task>> tasks = ValueNotifier([]);
  ValueNotifier<Map<String, List<Task>>> weekTasks =
      ValueNotifier(<String, List<Task>>{});

  Future<void> fetchWeekTasks() async {
    try {
      weekTasks.value = <String, List<Task>>{};
      isLoading.value = true;
      Map<String, List<Task>> response = await _tasksService.fetchWeekTasks();
      weekTasks.value = response;
    } catch (e) {
      errorMessage.value = "Error fetching tasks of week";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<TaskResponse?> deleteRule(int id) async {
    try {
      isLoading.value = true;
      TaskResponse? response = await _tasksService.deleteTask(id);
      if (response?.task != null) {
        await fetchTasksRules();
      } else {
        errorMessage.value = response?.message;
      }
      return response;
    } catch (e) {
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> fetchTasksRules() async {
    tasks.value = [];
    try {
      isLoading.value = true;
      List<Task> response = await _tasksService.fetchTasksRules();
      tasks.value = response;
    } catch (e) {
      errorMessage.value = "Error fetching tasks rules";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<TaskResponse?>? addRule(CreateTaskRequest task) async {
    try {
      isLoading.value = true;
      TaskResponse? response = await _tasksService.addRule(task);

      if (response?.task != null) {
        await fetchTasksRules();
      } else {
        errorMessage.value = response?.message;
      }
    } catch (e) {
      errorMessage.value = "Error on add task rule";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<TaskResponse?> getTask(int id) async {
    try {
      isLoading.value = true;

      TaskResponse? response = await _tasksService.getTask(id);

      if (response.task == null) {
        errorMessage.value = response.message;
      }

      return response;
    } catch (e) {
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<TaskResponse?> editTaskRule(int id, UpdateTaskRequest request) async {
    try {
      isLoading.value = true;
      TaskResponse? response = await _tasksService.editTaskRule(id, request);
      if (response?.task != null) {
        await fetchTasksRules();
      } else {
        errorMessage.value = errorMessage.value = response?.message;
      }
      return response;
    } catch (e) {
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<TaskResponse?> changeTaskStatus(Task task) async {
    try {
      isLoading.value = true;
      TaskResponse? response = await _tasksService.changeTaskStatus(task.id);
      if (response?.task != null) {
        await fetchWeekTasks();
      } else {
        errorMessage.value = errorMessage.value = response?.message;
      }
      return response;
    } catch (e) {
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }
}
