import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_config.dart';
import '../../config/design_system.dart';

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

  String get _storageKey => '${_storagePrefix}_${AppConfig.user?.id ?? 'guest'}';

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final preferences = await SharedPreferences.getInstance();
    final savedRecords = preferences.getString(_storageKey);

    if (savedRecords != null) {
      final decoded = jsonDecode(savedRecords) as Map<String, dynamic>;
      _records.addAll(decoded.map(
        (key, value) => MapEntry(
          key,
          _DailyRecord.fromJson(value as Map<String, dynamic>),
        ),
      ));
    }

    if (mounted) setState(() => _loading = false);
  }

  Future<void> _saveRecords() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _storageKey,
      jsonEncode(_records.map((key, value) => MapEntry(key, value.toJson()))),
    );
  }

  String _dateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  _DailyRecord _recordFor(DateTime date) =>
      _records[_dateKey(date)] ?? const _DailyRecord();

  Future<void> _updateRecord(
    DateTime date, {
    bool? cardio,
    bool? creatine,
  }) async {
    final current = _recordFor(date);
    setState(() {
      _records[_dateKey(date)] = current.copyWith(
        cardio: cardio,
        creatine: creatine,
      );
    });
    await _saveRecords();
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = DateUtils.dateOnly(pickedDate));
    }
  }

  List<DateTime> get _weekDates {
    final monday = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('Home'), automaticallyImplyLeading: false),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: false, label: Text('Diária')),
                      ButtonSegment(value: true, label: Text('Semanal')),
                    ],
                    selected: {_weeklyView},
                    onSelectionChanged: (selection) {
                      setState(() => _weeklyView = selection.first);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  tooltip: 'Selecionar data',
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today_outlined),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _weeklyView
                    ? '${DateFormat.MMMd().format(_weekDates.first)} – ${DateFormat.yMMMd().format(_weekDates.last)}'
                    : DateFormat.yMMMMd().format(_selectedDate),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _weeklyView
                ? ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: _weekDates.length,
                    itemBuilder: (context, index) => _DailyRecordCard(
                      date: _weekDates[index],
                      record: _recordFor(_weekDates[index]),
                      onCardioChanged: (value) =>
                          _updateRecord(_weekDates[index], cardio: value),
                      onCreatineChanged: (value) =>
                          _updateRecord(_weekDates[index], creatine: value),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: _DailyRecordCard(
                      date: _selectedDate,
                      record: _recordFor(_selectedDate),
                      onCardioChanged: (value) =>
                          _updateRecord(_selectedDate, cardio: value),
                      onCreatineChanged: (value) =>
                          _updateRecord(_selectedDate, creatine: value),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DailyRecordCard extends StatelessWidget {
  const _DailyRecordCard({
    required this.date,
    required this.record,
    required this.onCardioChanged,
    required this.onCreatineChanged,
  });

  final DateTime date;
  final _DailyRecord record;
  final ValueChanged<bool> onCardioChanged;
  final ValueChanged<bool> onCreatineChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.surfaceVariant,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              DateFormat.EEEE('pt_BR').format(date),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.directions_run, color: AppColors.primary),
            title: const Text('Cardio'),
            subtitle: Text(record.cardio ? 'Sim' : 'Não'),
            value: record.cardio,
            onChanged: onCardioChanged,
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: const Icon(Icons.medication_outlined, color: AppColors.primaryVariant),
            title: const Text('Creatina'),
            subtitle: Text(record.creatine ? 'Sim' : 'Não'),
            value: record.creatine,
            onChanged: onCreatineChanged,
          ),
        ],
      ),
    );
  }
}

class _DailyRecord {
  const _DailyRecord({this.cardio = false, this.creatine = false});

  final bool cardio;
  final bool creatine;

  factory _DailyRecord.fromJson(Map<String, dynamic> json) => _DailyRecord(
        cardio: json['cardio'] == true,
        creatine: json['creatine'] == true,
      );

  _DailyRecord copyWith({bool? cardio, bool? creatine}) => _DailyRecord(
        cardio: cardio ?? this.cardio,
        creatine: creatine ?? this.creatine,
      );

  Map<String, bool> toJson() => {'cardio': cardio, 'creatine': creatine};
}
