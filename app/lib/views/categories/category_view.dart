import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../config/helper.dart';
import '../../models/tasks/category_model.dart';
import '../../view_models/category_viewmodel.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_modal_delete.dart';
import '../../widgets/filter_card.dart';
import 'new_category_view.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  CategoryViewState createState() => CategoryViewState();
}

class CategoryViewState extends State<CategoryView> {
  final CategoryViewModel _categoryViewModel = CategoryViewModel();
  String _selectedType = 'all';

  @override
  initState() {
    super.initState();
    _fetchCategories();
  }

  _setFilter(value) {
    _selectedType = value;
    _fetchCategories();
  }

  _fetchCategories() {
    _categoryViewModel.fetchCategories(_selectedType);
  }

  _deleteCategoryDialog(Category category) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomModalDelete(
          title: "confirmDelete",
          onConfirm: () {
            _categoryViewModel.deleteCategory(category.id).then((response) {
              _handleResponse(response);
            });
          },
        );
      },
    );
  }

  _handleResponse(CategoryResponse? response) {
    if (response?.category != null) {
      _fetchCategories();
    } else {
      if (!mounted) return;
      showErrorBar(context, response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _categoryViewModel.isLoading,
      builder: (context, isLoading, child) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ValueListenableBuilder<List<Category>>(
          valueListenable: _categoryViewModel.categories,
          builder: (context, categories, child) {
            return Scaffold(
              appBar: CustomAppBar(
                title: 'categories',
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewCategoryView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              drawer: CustomDrawer(currentRoute: "/categories"),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFilterCard('all', 'all'),
                        _buildFilterCard('tasks', 'tasks'),
                        _buildFilterCard('finances', 'finances')
                      ],
                    )
                  ),
                  Expanded(
                    child: categories.isEmpty
                        ? Center(child: Text('noData'.tr()))
                        : ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: Container(
                              width: 3.0,
                              height: double.infinity,
                              color: hexaToColor(category.color),
                            ),
                            title: category.system ? Text(category.title.tr()) : Text(category.title),
                            subtitle: Text(category.type.tr()), // Display type here
                            trailing: !category.system
                                ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NewCategoryView(
                                                id: category.id),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteCategoryDialog(category);
                                  },
                                ),
                              ],
                            )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterCard(String type, String label) {
    return FilterCard(
      value: type,
      label: label,
      isSelected: _selectedType == type,
      onTap: _setFilter,
    );
  }
}
