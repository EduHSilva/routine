import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:routine/view_models/diet_viewmodel.dart';
import 'package:routine/views/health/new_meal_view.dart';

import '../../../config/design_system.dart';
import '../../../config/helper.dart';
import '../../../models/health/diet_model.dart';
import '../../../widgets/custom_modal_delete.dart';

class DietTab extends StatefulWidget {
  const DietTab({super.key});

  @override
  DietTabState createState() => DietTabState();
}

class DietTabState extends State<DietTab> {
  final DietViewModel _dietViewModel = DietViewModel();
  final Map<int, bool> _expandedMeal = {};

  @override
  initState() {
    super.initState();
    _getMeals();
  }

  _getMeals() async {
    await _dietViewModel.fetchMeals();
  }

  _deleteMeal(int id) async {
    MealResponse? response = await _dietViewModel.deleteMeal(id);
    _handlerResponse(response);
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
      _getMeals();
    } else {
      if (!mounted) return;
      showErrorBar(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _dietViewModel.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ValueListenableBuilder<List<Meal>>(
          valueListenable: _dietViewModel.meals,
          builder: (context, meals, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('meals'.tr()),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewMealView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              body: meals.isEmpty
                  ? Center(child: Text('noData'.tr()))
                  : ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  Meal meal = meals[index];
                  List<Food> foods = meal.foods;

                  // Controla o estado expandido de cada refeição
                  _expandedMeal.putIfAbsent(meal.id, () => false);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _expandedMeal[meal.id] =
                              !_expandedMeal[meal.id]!;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                // Nome da refeição
                                Expanded(
                                  child: Text(
                                    meal.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                // Ícone de edição
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NewMealView(id: meal.id),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(width: 8),

                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: AppColors.error,
                                    size: 24,
                                  ),
                                  onPressed: () {
                                    _deleteMealDialog(meal);
                                  },
                                ),

                                const SizedBox(width: 8),
                                Icon(
                                  _expandedMeal[meal.id]!
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  size: 28,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_expandedMeal[meal.id]!)
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: foods.length,
                            itemBuilder: (context, foodIndex) {
                              var food = foods[foodIndex];

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        food.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            '${food.quantity} g',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          if (food.observation != null &&
                                              food.observation!.isNotEmpty)
                                            Text(
                                              food.observation!,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontStyle:
                                                FontStyle.italic,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
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
