import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentHistory extends StatefulWidget {
  String name;
  List<DateTime> date;
  StudentHistory({super.key, required this.name, required this.date});

  @override
  State<StudentHistory> createState() => _StudentHistoryState();
}

class _StudentHistoryState extends State<StudentHistory> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(widget.name.toUpperCase()),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.date.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: ListTile(
                    tileColor: Colors.teal[100],
                    title: Text(
                        widget.date.elementAt(index).day.toString() +
                            "-" +
                            widget.date.elementAt(index).month.toString() +
                            "-" +
                            widget.date.elementAt(index).year.toString() +
                            " at " +
                            widget.date.elementAt(index).hour.toString() +
                            ":" +
                            widget.date.elementAt(index).minute.toString(),
                        style: TextStyle(
                            color: Colors.teal[900],
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500)),
                    trailing: Text(
                      "Present",
                      style: TextStyle(
                          color: Colors.teal[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp),
                    ),
                  ),
                );
              })),
        ],
      ),
    );
  }
}
