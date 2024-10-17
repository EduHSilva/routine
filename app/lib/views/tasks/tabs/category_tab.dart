import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../config/helper.dart';
import '../../../models/tasks/category_model.dart';
import '../../../viewmodels/category_viewmodel.dart';
import '../../../widgets/custom_modal_delete.dart';
import '../new_category_view.dart';

class CategoryTab extends StatefulWidget {
  const CategoryTab({super.key});

  @override
  CategoryTabState createState() => CategoryTabState();
}

class CategoryTabState extends State<CategoryTab> {
  final CategoryViewModel _categoryViewModel = CategoryViewModel();

  @override
  initState() {
    super.initState();
    _categoryViewModel.fetchCategories();
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
      _categoryViewModel.fetchCategories();
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
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text('categories'.tr()),
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
              body: categories.isEmpty
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
                            title: Text(category.title.tr()),
                            trailing: !category.system ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NewCategoryView(
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
                            ) : null,
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
