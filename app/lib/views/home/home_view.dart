import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'home'),
      drawer: const CustomDrawer(currentRoute: '/home'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'search'.tr(),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (query) {
                // Lógica de busca pode ser adicionada aqui
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Resultados da Busca:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 3, 
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.task_alt),
                    title: Text('Resultado $index'),
                    subtitle: const Text('Descrição do resultado.'),
                  );
                },
              ),
            ),
            const Divider(thickness: 2),
            Text(
              'pendingTasks'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 2, 
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.check_box_outline_blank),
                      title: Text('Tarefa Pendente $index'),
                      subtitle: const Text('Descrição da tarefa pendente.'),
                    ),
                  );
                },
              ),
            ),
            const Divider(thickness: 2),
            // Next Meal Section
            Text(
              'nextMealth'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Icon(Icons.restaurant_menu),
                title: Text('Refeição: Almoço'),
                subtitle: Text('Horário: 12:30 PM'),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
