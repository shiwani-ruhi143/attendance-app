import 'package:flutter/material.dart';

class StudentHistory extends StatefulWidget {
  String name;
  List<DateTime> date;
  StudentHistory({super.key,required this.name,required this.date});

  @override
  State<StudentHistory> createState() => _StudentHistoryState();
}

class _StudentHistoryState extends State<StudentHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.date.length,itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: ListTile(
                tileColor: Colors.teal[100],
                title: Text(widget.date.elementAt(index).toString()),
                trailing: Text("Present"),
              ),
            );
          })),
        ],
      ),
    );
  }
}
