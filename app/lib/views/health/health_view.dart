import 'package:app/views/health/tabs/diet_tab.dart';
import 'package:app/views/health/tabs/workout_tab.dart';
import 'package:app/views/tasks/tabs/all_tasks_tab.dart';
import 'package:app/views/tasks/tabs/category_tab.dart';
import 'package:app/views/tasks/tabs/rules_tab.dart';
import 'package:flutter/material.dart';

import '../../config/design_system.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';

class HealthView extends StatefulWidget {
  const HealthView({super.key});

  @override
  TasksViewState createState() => TasksViewState();
}

class TasksViewState extends State<HealthView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'health',
          bottom: TabBar(
            labelColor: AppColors.onPrimary,
            tabs: [
              Tab(text: 'Treinos'),
              Tab(text: 'Dieta'),
            ],
          ),
        ),
        drawer: CustomDrawer(currentRoute: "/health"),
        body: TabBarView(
          children: [
            WorkoutTab(),
            DietTab(),
          ],
        ),
      ),
    );
  }
}
