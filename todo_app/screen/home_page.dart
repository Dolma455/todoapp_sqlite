import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:todo_sqlite/todo_app/controller/todo_helper.dart';
import 'package:todo_sqlite/todo_app/model/db_model.dart';
import 'package:todo_sqlite/todo_app/screen/items_list.dart';
import 'package:todo_sqlite/todo_app/screen/update_page.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    TodoHelper().getItems();
  }

  List<Items> selectedItems = [];
  List<int> clickedIndex = [];

  @override
  Widget build(BuildContext context) {
    log(selectedItems.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items Listt'),
      ),
      body: FutureBuilder(
        future: TodoHelper().getItems(),
        builder: (ctx, snap) {
          if (snap.hasData) {
            final itemData = snap.requireData;
            return itemData.isNotEmpty
                ? Consumer(builder: (context, value, child) {
                    return ListView.builder(
                      itemCount: itemData.length,
                      itemBuilder: (ctx, index) {
                        var item = itemData[index];
                        return InkWell(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => UpdateItemPage(
                                        items: item, id: item.id!)));
                          },
                          child: Card(
                            child: ListTile(
                              leading: Checkbox(
                                activeColor: Colors.green,
                                value: clickedIndex.contains(item.id),
                                onChanged: (bool? value) {
                                  TodoHelper().toggleCheckbox(
                                    item,
                                    selectedItems,
                                    clickedIndex,
                                    () {
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                              title: Text("${item.id} ${item.name}"),
                              subtitle: Text(item.description),
                              trailing: IconButton(
                                onPressed: () async {
                                  await TodoHelper().deleteItem(item.id!);
                                  setState(() {});
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  })
                : const Center(
                    child: Text("No Data Found"),
                  );
          } else {
            return const Text("No Data");
          }
        },
      ),
      floatingActionButton: Consumer<ItemsList>(
        builder: (context, ref, child) {
          return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            FloatingActionButton(
              heroTag: 'H002',
              onPressed: () async {
                final itemToDeleteIds =
                    selectedItems.map((item) => item.id!).toList();
                await TodoHelper().deleteMultipleItems(itemToDeleteIds);

                selectedItems.clear();

                setState(() {});
              },
              child: const Icon(Icons.delete),
            ),
            const Padding(padding: EdgeInsets.all(16)),
            FloatingActionButton(
              heroTag: 'H001',
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      String name = '';
                      String description = '';
                      return AlertDialog(
                        title: const Text("Add new fruit"),
                        content: SizedBox(
                          height: 200,
                          width: 200,
                          child: Column(children: [
                            const Text("title"),
                            TextField(
                              onChanged: (value) {
                                name = value;
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(12)),
                            const Text("Description"),
                            TextField(
                              onChanged: (value) {
                                description = value;
                              },
                            )
                          ]),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              Items item = Items(
                                id: UniqueKey().hashCode,
                                name: name,
                                description: description,
                              );
                              TodoHelper().addItem(item);
                              setState(() {});

                              if (!mounted) return;
                              Navigator.of(context).pop();
                            },
                            child: const Text('Add'),
                          )
                        ],
                      );
                    });
              },
              child: const Icon(Icons.add),
            ),
          ]);
        },
      ),
    );
  }
}
