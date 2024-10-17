import 'package:app/views/tasks/tabs/all_tasks_tab.dart';
import 'package:app/views/tasks/tabs/category_tab.dart';
import 'package:app/views/tasks/tabs/rules_tab.dart';
import 'package:flutter/material.dart';

import '../../config/design_system.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

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
    return const DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Tasks',
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
