import 'package:routine/views/tasks/tasks_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../view_models/tasks_viewmodel.dart';
import '../../config/helper.dart';
import '../../models/enums.dart';
import '../../models/tasks/category_model.dart';
import '../../models/tasks/task_model.dart';
import '../../view_models/category_viewmodel.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_text_field.dart';

class NewTaskView extends StatefulWidget {
  final int? id;

  const NewTaskView({super.key, this.id});

  @override
  NewTaskViewState createState() => NewTaskViewState();
}

class NewTaskViewState extends State<NewTaskView> {
  final _formKey = GlobalKey<FormState>();
  final TasksViewModel _tasksViewModel = TasksViewModel();
  final CategoryViewModel _categoryViewModel = CategoryViewModel();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  DropdownItem<Category>? _selectedCategory;
  DropdownItem<Priority>? _selectedPriority;
  DropdownItem<Frequency>? _selectedFrequency;

  final List<DropdownItem<Priority>> _priorities = Priority.values
      .map((priority) => DropdownItem(
            label: priority.label,
            value: priority,
          ))
      .toList();

  final List<DropdownItem<Frequency>> _frequencies = Frequency.values
      .map((frequency) => DropdownItem(
            label: frequency.label,
            value: frequency,
          ))
      .toList();

  @override
  initState() {
    super.initState();
    _categoryViewModel.fetchCategories().then((_) {
      if (widget.id != null) {
        _loadTaskData(widget.id!);
      }
    });
  }

  _loadTaskData(int id) async {
    TaskResponse? response = await _tasksViewModel.getTask(id);

    if (response?.task != null) {
      setState(() {
        _titleController.text = response!.task!.title;
        _startDateController.text = formatDate(response.task!.dateStart!);
        _endDateController.text = formatDate(response.task!.dateEnd!);
        _startTimeController.text = response.task!.startTime;
        _endTimeController.text = response.task!.endTime;

        Category? category = _categoryViewModel.categories.value.firstWhere(
            (category) => category.title == response.task!.category);

        _selectedCategory = DropdownItem(
          label: response.task!.category,
          value: category,
        );

        _selectedPriority = _priorities.firstWhere((item) =>
            item.value ==
            Priority.values.firstWhere(
                (priority) => priority.label == response.task!.priority));

        _selectedFrequency = _frequencies.firstWhere((item) =>
            item.value ==
            Frequency.values.firstWhere(
                (frequency) => frequency.label == response.task!.frequency));
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
    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
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

  _addRule() async {
    if (_formKey.currentState!.validate()) {
      TaskResponse? response;
      if (widget.id == null) {
        if (_formKey.currentState!.validate()) {
           response = await _tasksViewModel.addRule(CreateTaskRequest(
            title: _titleController.text,
            categoryID: _selectedCategory!.value.id,
            dateStart: _startDateController.text,
            dateEnd: _endDateController.text,
            frequency: _selectedFrequency!.value.label,
            priority: _selectedPriority!.value.label,
            startTime: _startTimeController.text,
            endTime: _endTimeController.text,
          ));
        }
      } else {
        response = await _tasksViewModel.editTaskRule(
            widget.id!,
            UpdateTaskRequest(
                priority: _selectedPriority!.value.label,
                categoryID: _selectedCategory!.value.id,
                title: _titleController.text));
      }
      _handlerResponse(response);
    }
  }

  _handlerResponse(TaskResponse? response) {
    if (response?.task != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TasksView(initialIndex: 1),
        ),
      );
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
            final cat = categories
                .map((category) =>
                    DropdownItem(label: category.title, value: category))
                .toList();

            return Scaffold(
              appBar: AppBar(
                title: Text('add'.tr()),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'newTask'.tr(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        controller: _titleController,
                        labelText: 'title',
                        validator: requiredFieldValidator,
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
                            value == null ? 'Select a category' : null,
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
                              enable: widget.id == null,
                              readOnly: true,
                              onTap: () =>
                                  _selectDate(context, _endDateController),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _startTimeController,
                              labelText: 'startTime',
                              enable: widget.id == null,
                              readOnly: true,
                              onTap: () =>
                                  _selectTime(context, _startTimeController),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              controller: _endTimeController,
                              enable: widget.id == null,
                              labelText: 'endTime',
                              readOnly: true,
                              onTap: () =>
                                  _selectTime(context, _endTimeController),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomDropdown(
                        labelText: 'priority',
                        items: _priorities,
                        selectedItem: _selectedPriority,
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = _priorities
                                .firstWhere((item) => item.value == value);
                          });
                        },
                        validator: (value) =>
                            value == null ? 'selectAValue'.tr() : null,
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
                      ElevatedButton(
                        onPressed: _addRule,
                        child: Text('save'.tr()),
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
