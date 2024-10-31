import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:routine/views/health/health_view.dart';
import 'package:routine/widgets/custom_button.dart';

import '../../config/helper.dart';
import '../../models/health/diet_model.dart';
import '../../view_models/diet_viewmodel.dart';
import '../../widgets/custom_text_field.dart';
import 'modals/food_modal.dart';

class NewMealView extends StatefulWidget {
  final int? id;

  const NewMealView({super.key, this.id});

  @override
  NewMealViewState createState() => NewMealViewState();
}

class NewMealViewState extends State<NewMealView> {
  final _formKey = GlobalKey<FormState>();
  final DietViewModel _dietViewModel = DietViewModel();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();


  List<Food> _selectedFoods = [];

  @override
  initState() {
    super.initState();
    if (widget.id != null) {
      _loadMealData(widget.id!);
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        controller.text = pickedTime.format(context);
      });
    }
  }

  _removeFood(Food food) {
    setState(() {
      _selectedFoods.remove(food);
    });
  }

  _loadMealData(int id) async {
    MealResponse? response = await _dietViewModel.getMeal(id);

    if (response?.meal != null) {
      setState(() {
        _nameController.text = response!.meal!.name;
        _timeController.text = response.meal!.hour;
        _selectedFoods = response.meal!.foods ?? [];
      });
    }
  }

  _handlerResponse(MealResponse? response) {
    if (response?.meal != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HealthView(
            initialIndex: 1,
          ),
        ),
      );
    } else {
      if (!mounted) return;
      showErrorBar(context, response);
    }
  }

  _addMeal() async {
    if (_formKey.currentState!.validate()) {
      MealResponse? response;
      if (widget.id == null) {
        response = await _dietViewModel.addMeal(CreateMealRequest(
          name: _nameController.text,
          hour: _timeController.text,
          foods: _selectedFoods,
        ));
      } else {
        response = await _dietViewModel.editMeal(
          widget.id!,
          UpdateMealRequest(
            name: _nameController.text,
            hour: _timeController.text,
            foods: _selectedFoods,
          ),
        );
      }
      _handlerResponse(response);
    }
  }

  void _openFoodModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: FoodModal(
                onSelected: (selectedFoods) {
                  setState(() {
                    _selectedFoods = selectedFoods;
                  });
                },
                selectedFoods: _selectedFoods,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.id == null ? Text('add'.tr()) : Text('edit'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                widget.id == null ? 'newMeal'.tr() : 'editMeal'.tr(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child:
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'name',
                    validator: requiredFieldValidator,
                  )),
                  const SizedBox(width: 10),
                  Expanded(child:
                  CustomTextField(
                    controller: _timeController,
                    labelText: 'startTime'.tr(),
                    readOnly: true,
                    onTap: () =>
                        _selectTime(context, _timeController),
                  ),),
                ],
              ),
              const SizedBox(height: 24),
              CustomButton(
                onPressed: () => _openFoodModal(context),
                text: 'addFood',
                isOutlined: true,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _selectedFoods.isEmpty
                    ? Center(child: Text('noData'.tr()))
                    : ListView.builder(
                        itemCount: _selectedFoods.length,
                        itemBuilder: (context, index) {
                          var food = _selectedFoods[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        food.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.remove,
                                            color: Colors.redAccent),
                                        onPressed: () => _removeFood(food),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  CustomTextField(
                                    initialValue: food.quantity?.toString(),
                                    labelText: 'quantity',
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      setState(() {
                                        food.quantity =
                                            int.tryParse(value) ?? 0;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  CustomTextField(
                                    initialValue: food.observation,
                                    labelText: 'notes',
                                    onChanged: (value) {
                                      setState(() {
                                        food.observation = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _addMeal,
                text: 'save',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
