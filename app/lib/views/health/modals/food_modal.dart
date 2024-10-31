import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:routine/widgets/custom_button.dart';

import '../../../models/health/diet_model.dart';
import '../../../view_models/diet_viewmodel.dart';
import '../../../widgets/custom_text_field.dart';


class FoodModal extends StatefulWidget {
  final List<Food> selectedFoods;
  final Function(List<Food>) onSelected;

  const FoodModal({super.key,
    required this.selectedFoods,
    required this.onSelected,
  });

  @override
  State<FoodModal> createState() => _FoodModalState();
}

class _FoodModalState extends State<FoodModal> {
  final DietViewModel _dietViewModel = DietViewModel();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _setSearchFilter(String searchText) {
      _dietViewModel.fetchFoods(searchText);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Food>>(
      valueListenable: _dietViewModel.foods,
      builder: (context, foods, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _searchController,
                labelText: 'search',
                onChanged: _setSearchFilter,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    var food = foods[index];
                    bool isSelected = widget.selectedFoods.contains(food);

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            food.img,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                          ),
                        ),
                        title: Text(StringUtils.capitalize(food.name), style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: IconButton(
                          icon: Icon(isSelected ? Icons.remove : Icons.add),
                          onPressed: () {
                            setState(() {
                              if (isSelected) {
                                widget.selectedFoods.remove(food);
                              } else {
                                widget.selectedFoods.add(food);
                              }
                            });
                            widget.onSelected(widget.selectedFoods);
                          },
                        ),
                      )
                    );
                  },
                ),
              ),

              CustomButton(
                onPressed: () => Navigator.pop(context),
                text: 'close'
              ),
            ],
          ),
        );
      },
    );
  }
}
