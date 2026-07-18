import 'dart:convert';

import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../models/health/workout_model.dart';
import '../../view_models/workout_viewmodel.dart';

/// Visual weekly planner: each weekday points to one workout in the library.
class WorkoutPlanView extends StatefulWidget {
  const WorkoutPlanView({super.key});

  @override
  State<WorkoutPlanView> createState() => _WorkoutPlanViewState();
}

class _WorkoutPlanViewState extends State<WorkoutPlanView> {
  final _viewModel = WorkoutViewModel();
  final Map<int, Workout?> _workoutByDay = {for (var day = 1; day <= 7; day++) day: null};
  bool _saving = false;
  static const _weekdays = ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'];

  @override
  void initState() { super.initState(); _viewModel.fetchWorkouts(); }
  @override
  void dispose() { super.dispose(); }

  Future<void> _save() async {
    setState(() => _saving = true);
    final days = List.generate(7, (index) {
          final dayOfWeek = index + 1;
          return {
            'dayOfWeek': dayOfWeek,
            'workoutId': _workoutByDay[dayOfWeek]?.id,
          };
        })
        .toList();
    try {
      final client = await AppConfig.getHttpClient();
      final response = await client.put(
        Uri.parse('${AppConfig.apiUrl}/fitness/workouts/week'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'days': days}),
      );
      if (response.statusCode < 200 || response.statusCode >= 300) throw Exception();
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não foi possível salvar o plano.')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Criar plano manual')),
    body: ValueListenableBuilder<bool>(
      valueListenable: _viewModel.isLoading,
      builder: (context, loading, _) {
        if (loading) return const Center(child: CircularProgressIndicator());
        return ValueListenableBuilder<List<Workout>>(
          valueListenable: _viewModel.workouts,
          builder: (context, workouts, _) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Distribua seus treinos nos dias da semana.', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              ...List.generate(7, (index) {
                final day = index + 1;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: DropdownButtonFormField<Workout?>(
                      value: _workoutByDay[day],
                      decoration: InputDecoration(labelText: _weekdays[index], border: InputBorder.none),
                      hint: const Text('Dia de descanso'),
                      items: [
                        const DropdownMenuItem<Workout?>(value: null, child: Text('Dia de descanso')),
                        ...workouts.map((workout) => DropdownMenuItem(value: workout, child: Text(workout.name))),
                      ],
                      onChanged: (workout) => setState(() => _workoutByDay[day] = workout),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              FilledButton.icon(onPressed: _saving ? null : _save, icon: const Icon(Icons.save_outlined), label: Text(_saving ? 'Salvando...' : 'Salvar plano')),
            ],
          ),
        );
      },
    ),
  );
}
