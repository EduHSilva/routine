import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:routine/widgets/custom_text_field.dart';

class SupermarketTab extends StatefulWidget {
  const SupermarketTab({super.key});

  @override
  SupermarketTabState createState() => SupermarketTabState();
}

class SupermarketTabState extends State<SupermarketTab> {
  final List<Map<String, dynamic>> _items = [];
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addItem(String title) {
    setState(() {
      _items.add({'title': title, 'completed': false});
    });
  }

  void _showAddItemModal() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('add'.tr()),
          content: TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('cancel'.tr()),
            ),
            TextButton(
              onPressed: () {
                if (_titleController.text.trim().isNotEmpty) {
                  _addItem(_titleController.text.trim());
                  _titleController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text('add'.tr()),
            ),
          ],
        );
      },
    );
  }

  void _showPriceModal(int index) {
    final TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('insertPrice'),
          content: CustomTextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            labelText: 'price',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (priceController.text.trim().isNotEmpty) {
                  setState(() {
                    _items[index]['completed'] = true;
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supermarket'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _items.isEmpty
            ? const Center(child: Text('No items added yet.'))
            : ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];
            return ListTile(
              title: Text(
                item['title'],
                style: TextStyle(
                  decoration: item['completed']
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: Checkbox(
                value: item['completed'],
                onChanged: (value) {
                  if (!item['completed']) {
                    _showPriceModal(index);
                  }
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
