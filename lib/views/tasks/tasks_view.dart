import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';

import '../../config/design_system.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';
import 'tabs/all_tasks_tab.dart';
import 'tabs/rules_tab.dart';

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
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'tasks',
          bottom: TabBar(
            labelColor: AppColors.onPrimary,
            tabs: [
              Tab(child: Text('week'.tr())),
              Tab(child: Text('rules'.tr())),
            ],
          ),
        ),
        drawer: CustomDrawer(currentRoute: "/tasks"),
        body: TabBarView(
          children: [
            AllTasksTab(),
            RulesTab(),
          ],
        ),
      ),
    );
  }
}
