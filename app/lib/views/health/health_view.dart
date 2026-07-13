import 'package:flutter/material.dart';

import 'fitness_home_tab.dart';
import 'tabs/diet_tab.dart';
import 'tabs/workout_tab.dart';

class HealthView extends StatefulWidget {
  final int initialIndex;

  const HealthView({super.key, this.initialIndex = 0});

  @override
  HealthViewState createState() => HealthViewState();
}

class HealthViewState extends State<HealthView> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    const pages = [FitnessHomeTab(), DietTab(), WorkoutTab()];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.restaurant_outlined), selectedIcon: Icon(Icons.restaurant), label: 'Diet'),
          NavigationDestination(icon: Icon(Icons.fitness_center_outlined), selectedIcon: Icon(Icons.fitness_center), label: 'Workouts'),
        ],
      ),
    );
  }
}
