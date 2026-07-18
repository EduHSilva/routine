import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_config.dart';
import '../../config/design_system.dart';
import '../../models/home_settings.dart';
import '../../services/home_settings_service.dart';
import '../user/user_profile.dart';
import 'fitness_settings_view.dart';
import 'workout_plan_view.dart';

class FitnessHomeTab extends StatefulWidget {
  const FitnessHomeTab({super.key});
  @override
  State<FitnessHomeTab> createState() => _FitnessHomeTabState();
}

class _FitnessHomeTabState extends State<FitnessHomeTab> {
  static const _storagePrefix = 'fitness_daily_records';
  final Map<String, _DailyRecord> _records = {};
  DateTime _selectedDate = DateUtils.dateOnly(DateTime.now());
  bool _weeklyView = false;
  bool _loading = true;
  HomeSettings _settings = const HomeSettings();
  String get _storageKey => '${_storagePrefix}_${AppConfig.user?.id ?? 'guest'}';

  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getString(_storageKey);
    if (saved != null) {
      final decoded = jsonDecode(saved) as Map<String, dynamic>;
      _records.addAll(decoded.map((key, value) => MapEntry(key, _DailyRecord.fromJson(value as Map<String, dynamic>))));
    }
    try { _settings = await HomeSettingsService().fetch(); } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }
  Future<void> _save() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, jsonEncode(_records.map((key, value) => MapEntry(key, value.toJson()))));
  }
  String _dateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
  _DailyRecord _recordFor(DateTime date) => _records[_dateKey(date)] ?? const _DailyRecord();
  Future<void> _update(DateTime date, _DailyRecord record) async {
    setState(() => _records[_dateKey(date)] = record);
    await _save();
    if (!DateUtils.isSameDay(date, DateTime.now())) return;
    try {
      await HomeSettingsService().saveTodayHistory(
        creatine: record.creatine,
        cardio: record.cardioMinutes,
      );
    } catch (_) {
      // O registro local permanece disponível caso a conexão falhe.
    }
  }
  List<DateTime> get _weekDates { final monday = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1)); return List.generate(7, (i) => monday.add(Duration(days: i))); }
  int get _weekCardio => _weekDates.fold(0, (total, date) => total + _recordFor(date).cardioMinutes);

  Future<void> _pickDate() async {
    final value = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (value != null) setState(() => _selectedDate = DateUtils.dateOnly(value));
  }
  Future<void> _editSettings() async {
    final value = await Navigator.push<HomeSettings>(context, MaterialPageRoute(builder: (_) => const FitnessSettingsView()));
    if (value != null) setState(() => _settings = value);
  }
  Future<void> _logout() async {
    await AppConfig.logout();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
  void _showActions() => showModalBottomSheet(context: context, builder: (sheetContext) => SafeArea(child: Wrap(children: [
    ListTile(leading: const Icon(Icons.edit_note), title: const Text('Criar plano manual'), onTap: () { Navigator.pop(sheetContext); Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkoutPlanView())); }),
    ListTile(leading: const Icon(Icons.auto_awesome), title: const Text('Criar plano por IA'), onTap: () { Navigator.pop(sheetContext); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A geração por IA será conectada à API.'))); }),
    ListTile(leading: const Icon(Icons.picture_as_pdf_outlined), title: const Text('Importar plano por PDF'), onTap: () { Navigator.pop(sheetContext); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A importação de PDF será processada pela API.'))); }),
  ])));

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(title: const Text('Home'), automaticallyImplyLeading: false, actions: [
        IconButton(tooltip: 'Preferências', onPressed: _editSettings, icon: const Icon(Icons.tune)),
        IconButton(tooltip: 'Perfil', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UserProfileView(id: AppConfig.user!.id))), icon: const Icon(Icons.account_circle_outlined)),
        IconButton(tooltip: 'Sair', onPressed: _logout, icon: const Icon(Icons.logout)),
      ]),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 4), child: Row(children: [
          Expanded(child: SegmentedButton<bool>(segments: const [ButtonSegment(value: false, label: Text('Diária')), ButtonSegment(value: true, label: Text('Semanal'))], selected: {_weeklyView}, onSelectionChanged: (v) => setState(() => _weeklyView = v.first))),
          const SizedBox(width: 12), IconButton(tooltip: 'Selecionar data', onPressed: _pickDate, icon: const Icon(Icons.calendar_today_outlined)),
        ])),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Align(alignment: Alignment.centerLeft, child: Text(_weeklyView ? '${DateFormat.MMMd().format(_weekDates.first)} – ${DateFormat.yMMMd().format(_weekDates.last)}' : DateFormat.yMMMMd().format(_selectedDate), style: Theme.of(context).textTheme.titleMedium))),
        if (_settings.showCardio) Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0), child: _CardioProgress(daily: _recordFor(_selectedDate).cardioMinutes, dailyGoal: _settings.dailyCardioMinutes, weekly: _weekCardio, weeklyGoal: _settings.weeklyCardioMinutes)),
        Expanded(child: _weeklyView ? ListView.builder(padding: const EdgeInsets.all(16), itemCount: _weekDates.length, itemBuilder: (_, i) => _DailyRecordCard(date: _weekDates[i], record: _recordFor(_weekDates[i]), showCardio: _settings.showCardio, showCreatine: _settings.creatineEnabled, onChanged: (record) => _update(_weekDates[i], record))) : Padding(padding: const EdgeInsets.all(16), child: _DailyRecordCard(date: _selectedDate, record: _recordFor(_selectedDate), showCardio: _settings.showCardio, showCreatine: _settings.creatineEnabled, onChanged: (record) => _update(_selectedDate, record)))),
      ]),
      floatingActionButton: FloatingActionButton(onPressed: _showActions, child: const Icon(Icons.add)),
    );
  }
}

class _CardioProgress extends StatelessWidget {
  const _CardioProgress({required this.daily, required this.dailyGoal, required this.weekly, required this.weeklyGoal});
  final int daily; final int dailyGoal; final int weekly; final int weeklyGoal;
  @override Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Progresso de cardio', style: TextStyle(fontWeight: FontWeight.bold)),
    if (dailyGoal > 0) _Progress(label: 'Hoje: $daily / $dailyGoal min', value: daily / dailyGoal),
    if (weeklyGoal > 0) _Progress(label: 'Semana: $weekly / $weeklyGoal min', value: weekly / weeklyGoal),
  ])));
}
class _Progress extends StatelessWidget { const _Progress({required this.label, required this.value}); final String label; final double value; @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(top: 8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label), LinearProgressIndicator(value: value < 0 ? 0 : value > 1 ? 1 : value)])); }

class _DailyRecordCard extends StatelessWidget {
  const _DailyRecordCard({required this.date, required this.record, required this.showCardio, required this.showCreatine, required this.onChanged});
  final DateTime date; final _DailyRecord record; final bool showCardio; final bool showCreatine; final ValueChanged<_DailyRecord> onChanged;
  Future<void> _recordCardio(BuildContext context) async {
    final controller = TextEditingController(text: record.cardioMinutes > 0 ? record.cardioMinutes.toString() : '');
    final minutes = await showDialog<int>(context: context, builder: (_) => AlertDialog(title: const Text('Registrar cardio'), content: TextField(controller: controller, autofocus: true, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Minutos')), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), FilledButton(onPressed: () => Navigator.pop(context, int.tryParse(controller.text) ?? 0), child: const Text('Salvar'))]));
    if (minutes != null) onChanged(record.copyWith(cardioMinutes: minutes));
  }
  Future<void> _timer(BuildContext context) async {
    final minutes = await showDialog<int>(
      context: context,
      builder: (_) => const _CardioTimerDialog(),
    );
    if (minutes != null && minutes > 0) {
      onChanged(record.copyWith(cardioMinutes: record.cardioMinutes + minutes));
    }
  }
  @override Widget build(BuildContext context) => Card(clipBehavior: Clip.antiAlias, child: Column(children: [
    Container(width: double.infinity, color: AppColors.surfaceVariant, padding: const EdgeInsets.all(12), child: Text(DateFormat.EEEE('pt_BR').format(date), style: const TextStyle(fontWeight: FontWeight.bold))),
    ListTile(leading: const Icon(Icons.fitness_center, color: AppColors.primary), title: const Text('Treino do dia'), subtitle: Text(record.workoutDone ? 'Concluído' : 'Adicione o treino do seu plano'), trailing: Checkbox(value: record.workoutDone, onChanged: (v) => onChanged(record.copyWith(workoutDone: v ?? false))), onTap: () => onChanged(record.copyWith(workoutDone: !record.workoutDone))),
    if (showCardio) ...[const Divider(height: 1), SwitchListTile(secondary: IconButton(tooltip: 'Registrar com timer', icon: const Icon(Icons.timer_outlined, color: AppColors.primary), onPressed: () => _timer(context)), title: const Text('Cardio'), subtitle: Text(record.cardioMinutes > 0 ? '${record.cardioMinutes} min' : 'Não'), value: record.cardioMinutes > 0, onChanged: (value) => value ? _recordCardio(context) : onChanged(record.copyWith(cardioMinutes: 0)))],
    if (showCreatine) ...[const Divider(height: 1), SwitchListTile(secondary: const Icon(Icons.medication_outlined, color: AppColors.primaryVariant), title: const Text('Creatina'), subtitle: Text(record.creatine ? 'Sim' : 'Não'), value: record.creatine, onChanged: (v) => onChanged(record.copyWith(creatine: v)))],
  ]));
}
class _DailyRecord { const _DailyRecord({this.cardioMinutes = 0, this.creatine = false, this.workoutDone = false}); final int cardioMinutes; final bool creatine; final bool workoutDone; factory _DailyRecord.fromJson(Map<String, dynamic> json) => _DailyRecord(cardioMinutes: (json['cardioMinutes'] as num?)?.toInt() ?? (json['cardio'] == true ? 1 : 0), creatine: json['creatine'] == true, workoutDone: json['workoutDone'] == true); _DailyRecord copyWith({int? cardioMinutes, bool? creatine, bool? workoutDone}) => _DailyRecord(cardioMinutes: cardioMinutes ?? this.cardioMinutes, creatine: creatine ?? this.creatine, workoutDone: workoutDone ?? this.workoutDone); Map<String, dynamic> toJson() => {'cardioMinutes': cardioMinutes, 'creatine': creatine, 'workoutDone': workoutDone}; }

class _CardioTimerDialog extends StatefulWidget {
  const _CardioTimerDialog();
  @override
  State<_CardioTimerDialog> createState() => _CardioTimerDialogState();
}

class _CardioTimerDialogState extends State<_CardioTimerDialog> {
  final _watch = Stopwatch();
  Timer? _ticker;
  @override
  void dispose() { _ticker?.cancel(); super.dispose(); }
  void _toggle() {
    setState(() {
      if (_watch.isRunning) { _watch.stop(); _ticker?.cancel(); }
      else { _watch.start(); _ticker = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {})); }
    });
  }
  @override
  Widget build(BuildContext context) {
    final seconds = _watch.elapsed.inSeconds;
    return AlertDialog(
      title: const Text('Timer de cardio'),
      content: Text('${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}', style: Theme.of(context).textTheme.displaySmall),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        OutlinedButton.icon(onPressed: _toggle, icon: Icon(_watch.isRunning ? Icons.pause : Icons.play_arrow), label: Text(_watch.isRunning ? 'Pausar' : 'Iniciar')),
        FilledButton(onPressed: () => Navigator.pop(context, (seconds / 60).ceil()), child: const Text('Salvar')),
      ],
    );
  }
}
