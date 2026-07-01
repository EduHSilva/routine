import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import '../../../models/enums.dart';
import '../../../models/finances/finances_model.dart';
import '../../../models/tasks/category_model.dart';
import '../../../view_models/category_viewmodel.dart';
import '../../../view_models/finances_viewmodel.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';

class AddTransactionModal extends StatefulWidget {
  final Function()? onSave;

  const AddTransactionModal({super.key, this.onSave});

  @override
  AddTransactionModalState createState() => AddTransactionModalState();
}

class AddTransactionModalState extends State<AddTransactionModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final FinancesViewmodel _financesViewModel = FinancesViewmodel();
  final CategoryViewModel _categoryViewModel = CategoryViewModel();

  DropdownItem<Category>? _selectedCategory;
  bool _income = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _categoryViewModel.fetchCategories('finances');
  }

  _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      await _financesViewModel.addRule(CreateTransactionRuleRequest(
        title: _titleController.text,
        categoryID: _selectedCategory!.value.id,
        value: double.parse(_valueController.text),
        income: _income,
        saving: _saving,
        frequency: Frequency.unique.label,
      ));

      widget.onSave?.call();
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _financesViewModel.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ValueListenableBuilder<List<Category>>(
          valueListenable: _categoryViewModel.categories,
          builder: (context, categories, child) {
            final cat = categories
                .map((category) =>
                DropdownItem(label: category.title, value: category))
                .toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextField(
                        controller: _titleController,
                        labelText: 'title'.tr(),
                        validator: (value) =>
                        value!.isEmpty ? 'requiredField'.tr() : null,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _valueController,
                        labelText: 'value'.tr(),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                        value!.isEmpty ? 'requiredField'.tr() : null,
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown(
                        labelText: 'category',
                        items: cat,
                        selectedItem: _selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory =
                                cat.firstWhere((item) => item.value == value);
                          });
                        },
                        validator: (value) =>
                        value == null ? 'selectAValue'.tr() : null,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: Text('income'.tr()),
                              value: _income,
                              onChanged: (value) {
                                setState(() {
                                  _income = value!;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: Text('saving'.tr()),
                              value: _saving,
                              onChanged: (value) {
                                setState(() {
                                  _saving = value!;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'cancel'.tr(),
                              isOutlined: true,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomButton(
                              text: 'save'.tr(),
                              onPressed: _saveTransaction,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
