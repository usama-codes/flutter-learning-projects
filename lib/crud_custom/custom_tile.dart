import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final Map<String, int> people;
  final int index;
  final Function(int) onEdit;
  final Function(int) onDelete;

  const Tile(this.people, this.index, this.onEdit, this.onDelete, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.green.shade900, width: 0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      leading: Icon(Icons.person),
      horizontalTitleGap: 30,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(people.keys.elementAt(index)),
          Text("${people.values.elementAt(index)}"),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: IconButton(
              onPressed: () => onEdit(index),
              icon: Icon(Icons.edit),
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () => onDelete(index),
            icon: Icon(Icons.delete),
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
