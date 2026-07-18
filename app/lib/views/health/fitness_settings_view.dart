import 'package:flutter/material.dart';

import '../../models/home_settings.dart';
import '../../services/home_settings_service.dart';

class FitnessSettingsView extends StatefulWidget {
  const FitnessSettingsView({super.key});
  @override
  State<FitnessSettingsView> createState() => _FitnessSettingsViewState();
}

class _FitnessSettingsViewState extends State<FitnessSettingsView> {
  final _service = HomeSettingsService();
  final _daily = TextEditingController();
  final _weekly = TextEditingController();
  bool _creatine = true;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    try {
      final settings = await _service.fetch();
      _daily.text = settings.dailyCardioMinutes.toString();
      _weekly.text = settings.weeklyCardioMinutes.toString();
      _creatine = settings.creatineEnabled;
    } catch (_) { _daily.text = '0'; _weekly.text = '0'; }
    if (mounted) setState(() => _loading = false);
  }
  Future<void> _save() async {
    setState(() => _saving = true);
    final settings = HomeSettings(dailyCardioMinutes: int.tryParse(_daily.text) ?? 0, weeklyCardioMinutes: int.tryParse(_weekly.text) ?? 0, creatineEnabled: _creatine);
    try { await _service.save(settings); if (mounted) Navigator.pop(context, settings); }
    catch (_) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não foi possível salvar as configurações.'))); }
    finally { if (mounted) setState(() => _saving = false); }
  }
  @override
  void dispose() { _daily.dispose(); _weekly.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Preferências de rotina')),
    body: _loading ? const Center(child: CircularProgressIndicator()) : ListView(padding: const EdgeInsets.all(16), children: [
      Text('Metas de cardio', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 8),
      TextField(controller: _daily, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Meta diária (minutos)', helperText: 'Use 0 para ocultar a seção de cardio.')),
      const SizedBox(height: 12), TextField(controller: _weekly, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Meta semanal (minutos)')),
      const SizedBox(height: 24), SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Exibir creatina na home'), value: _creatine, onChanged: (value) => setState(() => _creatine = value)),
      const SizedBox(height: 24), FilledButton.icon(onPressed: _saving ? null : _save, icon: const Icon(Icons.save_outlined), label: Text(_saving ? 'Salvando...' : 'Salvar preferências')),
    ]),
  );
}
