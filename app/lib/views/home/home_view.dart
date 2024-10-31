import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../view_models/home_viewmodel.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();
  final HomeViewModel _homeViewModel = HomeViewModel();

  void _search() {
    final query = _searchController.text;
    if (query.trim().isNotEmpty) _homeViewModel.searchGPT(query);
    _searchController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _homeViewModel.isLoading,
        builder: (context, isLoading, child) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ValueListenableBuilder<String>(
              valueListenable: _homeViewModel.searchValue,
              builder: (context, weekTasks, child) {
                return Scaffold(
                  appBar: const CustomAppBar(title: 'home'),
                  drawer: const CustomDrawer(currentRoute: '/home'),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  labelText: 'enterText'.tr(),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: _search,
                                icon: const Icon(Icons.search),
                                label: Text('search'.tr()),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ValueListenableBuilder<String>(
                            valueListenable: _homeViewModel.searchValue,
                            builder: (context, result, _) {
                              return Markdown(data: result);
                            },
                          ),
                        ),
                        const Divider(thickness: 2),
                        Text(
                          'pendingTasks'.tr(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading:
                                      const Icon(Icons.check_box_outline_blank),
                                  title: Text('Tarefa Pendente $index'),
                                  subtitle: const Text(
                                      'Descrição da tarefa pendente.'),
                                ),
                              );
                            },
                          ),
                        ),
                        const Divider(thickness: 2),
                        Text(
                          'nextMeal'.tr(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
              });
        });
  }
}
