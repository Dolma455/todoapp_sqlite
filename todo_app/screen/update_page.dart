import 'package:flutter/material.dart';
import 'package:todo_sqlite/todo_app/controller/todo_helper.dart';
import 'package:todo_sqlite/todo_app/model/db_model.dart';
import 'package:todo_sqlite/todo_app/screen/home_page.dart';

class UpdateItemPage extends StatefulWidget {
  const UpdateItemPage({
    super.key,
    required this.items,
    required this.id,
  });
  final Items items;
  final int id;

  @override
  State<UpdateItemPage> createState() => _UpdateItemPageState();
}

class _UpdateItemPageState extends State<UpdateItemPage> {
  late String desc;
  late int id;
  TextEditingController textController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = widget.items.description;
    titleController.text = widget.items.name;
    desc = widget.items.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: titleController,
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: textController,
            onChanged: (newDescription) {
              setState(() {
                desc = newDescription;
              });
            },
          ),
          TextButton(
            onPressed: () async {
              await TodoHelper().updateItems(
                titleController.text,
                desc,
                widget.id,
              );
              // await TodoHelperr().getItems();
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const ItemsPage(),
                ),
              );
            },
            child: Text("Update".toUpperCase()),
          ),
        ],
      ),
    );
  }
}
