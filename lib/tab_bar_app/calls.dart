import 'package:flutter/material.dart';

class Calls extends StatelessWidget {
  const Calls({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        spacing: 10,
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.black, width: 1),
            ),
            horizontalTitleGap: 80,
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.call, color: Colors.grey),
            ),
            title: Text('Lorem Ipsum'),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.black, width: 1),
            ),
            horizontalTitleGap: 80,
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.call, color: Colors.grey),
            ),
            title: Text('Lorem Ipsum'),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.black, width: 1),
            ),
            horizontalTitleGap: 80,
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.call, color: Colors.grey),
            ),
            title: Text('Lorem Ipsum'),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.black, width: 1),
            ),
            horizontalTitleGap: 80,
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.call, color: Colors.grey),
            ),
            title: Text('Lorem Ipsum'),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.black, width: 1),
            ),
            horizontalTitleGap: 80,
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.call, color: Colors.grey),
            ),
            title: Text('Lorem Ipsum'),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.black, width: 1),
            ),
            horizontalTitleGap: 80,
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(Icons.call, color: Colors.grey),
            ),
            title: Text('Lorem Ipsum'),
          ),
        ],
      ),
    );
  }
}
