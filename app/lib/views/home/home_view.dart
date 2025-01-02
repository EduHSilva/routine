import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';


import '../../config/helper.dart';
import '../../models/health/diet_model.dart';
import '../../view_models/diet_viewmodel.dart';
import '../../view_models/home_viewmodel.dart';
import '../../view_models/tasks_viewmodel.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_modal_delete.dart';
import '../../widgets/meal_card.dart';
import '../../widgets/task_card.dart';
import '../health/meal_details.dart';
import '../health/new_meal_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    _homeViewModel.getDailyData();
  }

  final TextEditingController _searchController = TextEditingController();
  final HomeViewModel _homeViewModel = HomeViewModel();
  final TasksViewModel _tasksViewModel = TasksViewModel();
  final DietViewModel _dietViewModel = DietViewModel();

  void _search() {
    final query = _searchController.text;
    if (query.trim().isNotEmpty) _homeViewModel.searchGPT(query);
    _searchController.text = '';
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _homeViewModel.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ValueListenableBuilder<String>(
          valueListenable: _homeViewModel.searchValue,
          builder: (context, weekTasks, child) {
            return Scaffold(
              appBar: const CustomAppBar(title: 'home'),
              drawer: const CustomDrawer(currentRoute: '/home'),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _searchController,
                            maxLines: 3,
                            minLines: 1,
                            decoration: InputDecoration(
                              labelText: 'enterText'.tr(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _search,
                            icon: const Icon(Icons.search),
                            label: Text('search'.tr()),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      flex: 3,
                      child: ValueListenableBuilder<String>(
                        valueListenable: _homeViewModel.searchValue,
                        builder: (context, result, _) {
                          return Markdown(data: result);
                        },
                      ),
                    ),
                    const Divider(thickness: 2),
                    Text(
                      'pendingTasks'.tr(),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      flex: 3,
                      child: ValueListenableBuilder(
                        valueListenable: _homeViewModel.tasks,
                        builder: (context, tasks, child) {
                          if (tasks.isEmpty) {
                            return Text(
                              'noTasksPending'.tr(),
                              style: TextStyle(fontSize: 16),
                            );
                          }
                          return ListView.builder(
                            itemCount: tasks.length > 5 ? 5 : tasks.length,
                            itemBuilder: (context, taskIndex) {
                              var task = tasks[taskIndex];
                              return TaskCard(
                                title: task.title,
                                category: task.category.tr(),
                                startTime: task.startTime,
                                endTime: task.endTime,
                                isDone: task.done,
                                color: hexaToColor(task.color),
                                onChanged: (value) async {
                                  await _tasksViewModel.changeTaskStatus(task);
                                  await _homeViewModel.getDailyData();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const Divider(thickness: 2),
                    Text(
                      'nextMeal'.tr(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ValueListenableBuilder(
                      valueListenable: _homeViewModel.nextMeal,
                      builder: (context, nextMeal, child) {
                        if (nextMeal == null || nextMeal.name.isEmpty) {
                          return Text(
                            'noNextMeal'.tr(),
                            style: TextStyle(fontSize: 16),
                          );
                        }
                        return MealCard(
                          id: nextMeal.id,
                          name: nextMeal.name,
                          hour: nextMeal.hour,
                          onTap: () => _showDetails(nextMeal.id),
                          onEdit: () => _editMeal(nextMeal.id),
                          onRemove: () => _deleteMealDialog(nextMeal),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
