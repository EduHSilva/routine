import 'package:easy_localization/easy_localization.dart';
import 'package:routine/views/health/tabs/diet_tab.dart';
import 'package:routine/views/health/tabs/workout_tab.dart';
import 'package:flutter/material.dart';

import '../../config/design_system.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';
class HealthView extends StatefulWidget {
  final int initialIndex;

  const HealthView({super.key, this.initialIndex = 0});

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
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'health',
          bottom: TabBar(
            labelColor: AppColors.onPrimary,
            tabs: [
              Tab(child: Text('workout'.tr())),
              Tab(child: Text('meals'.tr())),
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
