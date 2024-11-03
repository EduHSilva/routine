import 'package:routine/views/categories/category_view.dart';
import 'package:routine/views/tasks/tasks_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../config/app_config.dart';
import '../../config/helper.dart';
import '../../models/tasks/category_model.dart';
import '../../view_models/category_viewmodel.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field.dart';

class NewCategoryView extends StatefulWidget {
  final int? id;

  const NewCategoryView({super.key, this.id});

  @override
  NewCategoryViewStateState createState() => NewCategoryViewStateState();
}

class NewCategoryViewStateState extends State<NewCategoryView> {
  final _formKey = GlobalKey<FormState>();
  final CategoryViewModel _categoryViewModel = CategoryViewModel();
  DropdownItem<String>? _selectedTypeCategory;

  final TextEditingController _titleController = TextEditingController();
  Color selectedColor = Colors.green;

  @override
  initState() {
    super.initState();
    if (widget.id != null) {
      _loadCategoryData(widget.id!);
    }
  }

  _loadCategoryData(int categoryId) async {
    CategoryResponse? response =
        await _categoryViewModel.getCategory(categoryId);

    if (response?.category != null) {
      setState(() {
        _titleController.text = response!.category!.title;
        selectedColor = hexaToColor(response.category?.color);
        _selectedTypeCategory = DropdownItem(
          label: response.category!.type,
          value: response.category!.type,
        );
      });
    }
  }

  _addCategory() async {
    if (_formKey.currentState!.validate()) {
      if (widget.id == null) {
        CategoryResponse? response = await _categoryViewModel.createCategory(
          _titleController.text,
          colorToHexa(selectedColor),
          _selectedTypeCategory!.value
        );
        _handleResponse(response);
      } else {
        CategoryResponse? response = await _categoryViewModel.editCategory(
          widget.id!,
          _titleController.text,
          colorToHexa(selectedColor),
        );
        _handleResponse(response);
      }
    }
  }

  _handleResponse(CategoryResponse? response) {
    if (response?.category != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryView(),
        ),
      );
    } else {
      showErrorBar(context, response);
    }
  }

  List<DropdownItem<String>> items = [DropdownItem(label: 'tasks', value: 'tasks'), DropdownItem(label: 'finances', value: 'finances')];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _categoryViewModel.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: AppBar(
            title: widget.id == null ? Text(
              'newCategory'.tr()) :  Text('editCategory'.tr()),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  CustomTextField(
                    controller: _titleController,
                    labelText: 'title',
                    validator: requiredFieldValidator,
                  ),
                  const SizedBox(height: 10),
                  CustomDropdown(
                    labelText: 'type',
                    items: items,
                    selectedItem: _selectedTypeCategory,
                    onChanged: widget.id == null ? (value) {
                      setState(() {
                        _selectedTypeCategory =
                            items.firstWhere((item) => item.value == value);
                      });
                    } : null,
                    validator: (value) =>
                    value == null ? 'selectAValue'.tr() : null,
                  ),
                  Text(
                    'color'.tr(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  MaterialPicker(
                    pickerColor: selectedColor,
                    onColorChanged: (Color color) {
                      setState(() {
                        AppConfig.getLogger().i(color);
                        selectedColor = color;
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _addCategory,
                    child: Text('save'.tr()),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
