import 'package:easy_localization/easy_localization.dart';
import 'package:routine/views/finances/tabs/financial_resume_tab.dart';
import 'package:routine/views/finances/tabs/financial_rules_tab.dart';
import 'package:routine/views/health/tabs/diet_tab.dart';
import 'package:routine/views/health/tabs/workout_tab.dart';
import 'package:flutter/material.dart';

import '../../config/design_system.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';

class FinancesView extends StatefulWidget {
  final int initialIndex;

  const FinancesView({super.key, this.initialIndex = 0});

  @override
  FinancesViewState createState() => FinancesViewState();
}

class FinancesViewState extends State<FinancesView> {
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
          title: 'finances',
          bottom: TabBar(
            labelColor: AppColors.onPrimary,
            tabs: [
              Tab(child: Text('resume'.tr())),
              Tab(child: Text('rules'.tr())),
            ],
          ),
        ),
        drawer: CustomDrawer(currentRoute: "/finances"),
        body: TabBarView(
          children: [
            FinancialResumeTab(),
            FinancialRulesTab(),
          ],
        ),
      ),
    );
  }
}
