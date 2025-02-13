import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../config/helper.dart';
import '../../models/enums.dart';
import '../../models/finances/finances_model.dart';
import '../../models/tasks/category_model.dart';
import '../../view_models/category_viewmodel.dart';
import '../../view_models/finances_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_modal_delete.dart';
import '../../widgets/custom_text_field.dart';
import 'finances_view.dart';

class NewFinancialRuleView extends StatefulWidget {
  final int? id;

  const NewFinancialRuleView({super.key, this.id});

  @override
  NewFinancialViewState createState() => NewFinancialViewState();
}

class NewFinancialViewState extends State<NewFinancialRuleView> {
  final _formKey = GlobalKey<FormState>();
  final FinancesViewmodel _financesViewModel = FinancesViewmodel();
  final CategoryViewModel _categoryViewModel = CategoryViewModel();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  bool _income = false;
  bool _isEndDateDisabled = false;

  DropdownItem<Category>? _selectedCategory;
  DropdownItem<FrequencyTransaction>? _selectedFrequency;

  final List<DropdownItem<FrequencyTransaction>> _frequencies = FrequencyTransaction.values
      .map((frequency) => DropdownItem(
            label: frequency.label,
            value: frequency,
          ))
      .toList();

  @override
  initState() {
    super.initState();
    _categoryViewModel.fetchCategories('finances').then((_) async {
      if (widget.id != null) {
        await _loadTransactionData(widget.id!);
      }
    });
  }

  _loadTransactionData(int id) async {
    TransactionResponse? response = await _financesViewModel.getTransaction(id);

    if (response?.transaction != null) {
      setState(() {
        _titleController.text = response!.transaction!.title;
        _startDateController.text = formatDate(response.transaction!.startDate);
        _endDateController.text = formatDate(response.transaction!.endDate);
        _valueController.text = response.transaction!.value.toString();
        _income = response.transaction!.income;

        Category? category = _categoryViewModel.categories.value.firstWhere(
            (category) => category.title == response.transaction!.category);

        _selectedCategory = DropdownItem(
          label: response.transaction!.category,
          value: category,
        );

        _selectedFrequency = _frequencies.firstWhere((item) =>
            item.value ==
            FrequencyTransaction.values.firstWhere((frequency) =>
                frequency.label == response.transaction!.frequency));
      });
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    setState(() {
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate!);
    });
    }

  _deleteTransaction(int id) async {
    TransactionResponse? response = await _financesViewModel.deleteRule(id);
    _handlerResponse(response);
  }

  _handlerResponse(TransactionResponse? response) {
    if (response?.transaction != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const FinancesView(initialIndex: 1,),
      ));
    } else {
      if (!mounted) return;
      showErrorBar(context, response);
    }
  }

  _deleteTransactionDialog(id) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomModalDelete(
          title: "confirmDelete",
          onConfirm: () {
            _deleteTransaction(id);
          },
        );
      },
    );
  }

  _addRule() async {
    if (_formKey.currentState!.validate()) {
      TransactionResponse? response;
      if (widget.id == null) {
        response = await _financesViewModel.addRule(
          CreateTransactionRuleRequest(
            title: _titleController.text,
            categoryID: _selectedCategory!.value.id,
            startDate: _startDateController.text,
            endDate: _endDateController.text,
            frequency: _selectedFrequency!.value.label,
            value: double.parse(_valueController.text),
            income: _income,
            saving: false
          ),
        );
      } else {
        response = await _financesViewModel.editRule(
          widget.id!,
          UpdateTransactionRuleRequest(
            categoryID: _selectedCategory!.value.id,
            value: double.parse(_valueController.text),
            title: _titleController.text,
          ),
        );
      }
      _handlerResponse(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
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

            return Scaffold(
              appBar: AppBar(
                title: widget.id == null ? Text('add'.tr()) : Text('edit'.tr()),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _titleController,
                              labelText: 'title',
                              validator: requiredFieldValidator,
                            ),
                          ),
                          Expanded(
                              child: CheckboxListTile(
                            title: Text('income'.tr()),
                            value: _income,
                            onChanged: (newValue) {
                              setState(() {
                                _income = !_income;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ))
                        ],
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
                            child: CustomTextField(
                              controller: _startDateController,
                              labelText: 'startDate',
                              readOnly: true,
                              enable: widget.id == null,
                              onTap: () =>
                                  _selectDate(context, _startDateController),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              controller: _endDateController,
                              labelText: 'endDate',
                              enable: !_isEndDateDisabled && widget.id == null,
                              readOnly: true,
                              onTap: !_isEndDateDisabled
                                  ? () => _selectDate(context, _endDateController)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              Text(
                                'noEndDate'.tr(),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Switch(
                                value: _isEndDateDisabled,
                                onChanged: widget.id != null
                                    ? null
                                    : (value) {
                                  setState(() {
                                    _isEndDateDisabled = value;
                                    if (value) {
                                      _endDateController.clear();
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _valueController,
                              labelText: 'value',
                              keyboardType: TextInputType.numberWithOptions(),
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown(
                        labelText: 'frequency',
                        items: _frequencies,
                        selectedItem: _selectedFrequency,
                        onChanged: widget.id != null
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedFrequency = _frequencies.firstWhere(
                                      (item) => item.value == value);
                                });
                              },
                        validator: (value) =>
                            value == null ? 'selectAValue'.tr() : null,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          widget.id != null
                              ? Expanded(
                                  child: CustomButton(
                                      onPressed: () {
                                        _deleteTransactionDialog(widget.id);
                                      },
                                      isOutlined: true,
                                      text: 'delete'))
                              : Column(),
                          widget.id != null
                              ? const SizedBox(
                                  width: 20,
                                )
                              : Column(),
                          Expanded(
                              child: CustomButton(
                                  onPressed: _addRule, text: 'save')),
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
