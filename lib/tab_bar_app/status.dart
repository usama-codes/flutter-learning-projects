import 'package:flutter/material.dart';

class Status extends StatelessWidget {
  const Status({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        spacing: 10,
        children: [
          Row(
            // spacing: 25,
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200,
                      width: 70,
                      child: Text("Status"),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200,
                      width: 70,
                      child: Text("Status"),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200,
                      width: 70,
                      child: Text("Status"),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Column(
              spacing: 10,
              children: [
                ListTile(
                  title: Center(child: Text("Lorem ipsum")),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                ListTile(
                  title: Center(child: Text("Lorem ipsum")),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                ListTile(
                  title: Center(child: Text("Lorem ipsum")),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                ListTile(
                  title: Center(child: Text("Lorem ipsum")),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                ListTile(
                  title: Center(child: Text("Lorem ipsum")),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
