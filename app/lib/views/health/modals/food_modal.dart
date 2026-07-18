import 'dart:async';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';

import '../../../models/health/diet_model.dart';
import '../../../view_models/diet_viewmodel.dart';

class FoodModal extends StatefulWidget {
  const FoodModal({super.key, required this.selectedFoods, required this.onSelected});

  final List<MealFood> selectedFoods;
  final ValueChanged<List<MealFood>> onSelected;

  @override
  State<FoodModal> createState() => _FoodModalState();
}

class _FoodModalState extends State<FoodModal> {
  final _dietViewModel = DietViewModel();
  final _searchController = TextEditingController();
  late List<MealFood> _selection;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _selection = widget.selectedFoods.map((food) =>
        MealFood(
        foodId: food.foodId,
        quantity: food.quantity,
        observation: food.observation,
        foodName: food.foodName)).toList();
    _dietViewModel.fetchFoods('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _search(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () =>
        _dietViewModel.fetchFoods(value.trim()));
  }

  MealFood? _selected(Food food) {
    for (final item in _selection) {
      if (item.foodId == food.id) return item;
    }
    return null;
  }

  void _toggle(Food food) =>
      setState(() {
        final current = _selected(food);
        if (current == null) {
          _selection.add(MealFood(foodId: food.id,
              quantity: 100,
              observation: '',
              foodName: food.name));
        } else {
          _selection.remove(current);
        }
      });

  @override
  Widget build(BuildContext context) =>
      SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery
              .of(context)
              .viewInsets
              .bottom),
          child: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height * .78,
            child: Column(children: [
              Row(children: [
                const Expanded(child: Text('Adicionar alimentos',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold))),
                IconButton(onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close))
              ]),
              const SizedBox(height: 8),
              TextField(controller: _searchController,
                  autofocus: true,
                  onChanged: _search,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Buscar alimento',
                      border: OutlineInputBorder())),
              const SizedBox(height: 8),
              ValueListenableBuilder<List<Food>>(
                valueListenable: _dietViewModel.foods,
                builder: (_, foods, __) =>
                    Expanded(
                      child: foods.isEmpty
                          ? const Center(
                          child: Text('Nenhum alimento encontrado.'))
                          : ListView.separated(
                        itemCount: foods.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemBuilder: (_, index) {
                          final food = foods[index];
                          final selected = _selected(food);
                          return Card(child: Padding(padding: const EdgeInsets
                              .symmetric(horizontal: 8, vertical: 4),
                              child: Column(children: [
                                ListTile(contentPadding: EdgeInsets.zero,
                                    title: Text(
                                        StringUtils.capitalize(food.name),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    trailing: IconButton(
                                        tooltip: selected == null
                                            ? 'Adicionar'
                                            : 'Remover',
                                        onPressed: () => _toggle(food),
                                        icon: Icon(selected == null ? Icons
                                            .add_circle_outline : Icons
                                            .check_circle,
                                            color: selected == null
                                                ? null
                                                : Theme
                                                .of(context)
                                                .colorScheme
                                                .primary))),
                                if (selected != null)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                    child: TextFormField(
                                      initialValue: selected.quantity.toString(),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) => selected.quantity =
                                          int.tryParse(value) ?? 0,
                                      decoration: const InputDecoration(
                                        labelText: 'Quantidade (g)',
                                        suffixText: 'g',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                              ])));
                        },
                      ),
                    ),
              ),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity,
                  child: FilledButton.icon(onPressed: () {
                    widget.onSelected(_selection);
                    Navigator.pop(context);
                  },
                      icon: const Icon(Icons.check),
                      label: Text('Confirmar (${_selection.length})'))),
            ]),
          ),
        ),
      );
}
