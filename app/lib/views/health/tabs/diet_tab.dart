import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import '../../../config/helper.dart';
import '../../../config/pdf.dart';
import '../../../models/health/diet_model.dart';
import '../../../view_models/diet_viewmodel.dart';
import '../../../widgets/custom_modal_delete.dart';
import '../../../widgets/meal_card.dart';
import '../meal_details.dart';
import '../new_meal_view.dart';

class DietTab extends StatefulWidget {
  const DietTab({super.key});

  @override
  DietTabState createState() => DietTabState();
}

class DietTabState extends State<DietTab> {
  final DietViewModel _dietViewModel = DietViewModel();

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

  _showDetails(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealDetailView(id: id),
      ),
    );
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
                    icon: const Icon(Icons.share),
                    onPressed: () async {
                      await generateAndShareDietPDF(
                          _dietViewModel.meals.value);
                    },
                  ),
                ],
              ),
              body: meals.isEmpty
                  ? Center(child: Text('noData'.tr()))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListView.builder(
                        itemCount: meals.length,
                        itemBuilder: (context, index) {
                          Meal meal = meals[index];

                          return MealCard(
                            id: meal.id,
                            name: meal.name,
                            hour: meal.hour,
                            onTap: () => _showDetails(meal.id),
                            onEdit: () => _editMeal(meal.id),
                            onRemove: () => _deleteMealDialog(meal),
                          );
                        },
                      ),
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewMealView(),
                    ),
                  );
                },
                child: Icon(Icons.add),
              ),
            );
          },
        );
      },
    );
  }
}
