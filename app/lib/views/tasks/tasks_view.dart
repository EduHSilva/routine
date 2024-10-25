import 'package:app/views/tasks/tabs/all_tasks_tab.dart';
import 'package:app/views/tasks/tabs/category_tab.dart';
import 'package:app/views/tasks/tabs/rules_tab.dart';
import 'package:flutter/material.dart';

import '../../config/design_system.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';

class TasksView extends StatefulWidget {
  final int initialIndex;
  const TasksView({super.key, this.initialIndex = 0});

  @override
  TasksViewState createState() => TasksViewState();
}

class TasksViewState extends State<TasksView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: widget.initialIndex,
      child: const Scaffold(
        appBar: CustomAppBar(
          title: 'tasks',
          bottom: TabBar(
            labelColor: AppColors.onPrimary,
            tabs: [
              Tab(text: 'Semana'),
              Tab(text: 'Regras'),
              Tab(text: 'Categorias'),
            ],
          ),
        ),
        drawer: CustomDrawer(currentRoute: "/tasks"),
        body: TabBarView(
          children: [
            AllTasksTab(),
            RulesTab(),
            CategoryTab(),
          ],
        ),
      ),
    );
  }
}
