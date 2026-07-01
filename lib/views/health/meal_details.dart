import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../models/health/diet_model.dart';
import '../../view_models/diet_viewmodel.dart';

class MealDetailView extends StatefulWidget {
  final int id;

  const MealDetailView({super.key, required this.id});

  @override
  MealDetailViewState createState() => MealDetailViewState();
}

class MealDetailViewState extends State<MealDetailView> {
  final DietViewModel _dietViewModel = DietViewModel();
  MealResponse? _mealResponse;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadMealData(widget.id));
  }

  Future<void> _loadMealData(int id) async {
    MealResponse? response = await _dietViewModel.getMeal(id);

    if (mounted) {
      setState(() {
        _mealResponse = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('mealDetails'.tr()),
      ),
      body: _mealResponse == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_mealResponse!.meal!.name} - ${_mealResponse!.meal!.hour}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _mealResponse!.meal!.foods == null ||
                  _mealResponse!.meal!.foods!.isEmpty
                  ? Center(child: Text('noData'.tr()))
                  : ListView.builder(
                itemCount: _mealResponse!.meal!.foods!.length,
                itemBuilder: (context, index) {
                  var food = _mealResponse!.meal!.foods![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            toBeginningOfSentenceCase(food.name),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (food.quantity != null)
                            Text(
                              '${'quantity'.tr()}: ${food.quantity}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          const SizedBox(height: 8),
                          if (food.observation != null &&
                              food.observation!.isNotEmpty)
                            Text(
                              '${'notes'.tr()}: ${food.observation}',
                              style: const TextStyle(fontSize: 16),
                            ),
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
}
