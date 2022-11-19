import 'package:app/add.dart';
import 'package:app/student_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'makepdf.dart';

class mainpage extends StatefulWidget {
  var uid;
  mainpage({required this.uid});
  @override
  State<mainpage> createState() => _mainpageState();
}

class _mainpageState extends State<mainpage> {
  CollectionReference ref = FirebaseFirestore.instance.collection('classes');
  Future getClass() async {
    DocumentReference d = ref.doc(widget.uid);
    DocumentSnapshot snapshot = await d.get();
    return snapshot['class'];
  }

  Future getYear() async {
    DocumentReference d = ref.doc(widget.uid);
    DocumentSnapshot snapshot = await d.get();
    return snapshot['year'];
  }

  String? branch;
  String? year;

  getClassValue() {
    getClass().then((value) {
      setState(() {
        branch = value;
      });
    });
  }

  getYearValue() {
    getYear().then((value) {
      setState(() {
        year = value;
      });
    });
    return year;
  }

  @override
  void initState() {
    // TODO: implement initState
    getClassValue();
    getYearValue();
    super.initState();
  }

  var temp = [];
  var rollList = [];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('classes')
        .doc(widget.uid)
        .collection('students')
        .orderBy('roll', descending: false)
        .snapshots();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => add(uid: widget.uid)));
        },
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 10.w, 0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => reportt(
                        list: temp,
                        clas: "${branch.toString().toUpperCase()} ${year.toString().toUpperCase()}",
                        rollList: rollList,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.file_download, size: 25.sp)),
          )
        ],
        backgroundColor: Colors.teal,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Attendance',
              style: TextStyle(
                fontSize: 18.sp,
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            if (branch != null) Text(branch!.toUpperCase()),
            SizedBox(
              width: 10.w,
            ),
            if (year != null) Text("${year!} year"),
            SizedBox(
              width: 25,
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.teal,
                  ),
                );
              }
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (_, index) {
                    List<int> date = [];
                    for (var value
                        in snapshot.data!.docChanges[index].doc['isPresent']) {
                      int tmpDate = value.toDate().day;
                      date.add(tmpDate);
                    }
                    bool isPresent = date.contains(DateTime.now().day);

                    if (isPresent) {
                      if (!rollList.contains(
                          snapshot.data!.docChanges[index].doc['roll'])) {
                        temp.add(snapshot.data!.docChanges[index].doc['name']
                            .toString()
                            .toUpperCase());
                        rollList
                            .add(snapshot.data!.docChanges[index].doc['roll']);
                      }
                    }

                    //_____________//

                    return InkWell(
                      onTap: () {
                        List<DateTime> date = [];
                        for (var value in snapshot
                            .data!.docChanges[index].doc['isPresent']) {
                          DateTime tmpDate = value.toDate();
                          date.add(tmpDate);
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentHistory(
                                      name: snapshot
                                          .data!.docChanges[index].doc['name'],
                                      date: date,
                                    )));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 8.h),
                        child: Card(
                          child: ListTile(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            tileColor: Color.fromARGB(255, 244, 244, 244),
                            leading: Text(
                                snapshot.data!.docChanges[index].doc['roll'] +
                                    ".",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.teal[700])),
                            title: Text(
                                snapshot.data!.docChanges[index].doc['name']
                                    .toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.teal[700])),
                            trailing: InkWell(
                              onTap: () async {
                                if (isPresent == false) {
                                  //try to add current date in array
                                  await snapshot
                                      .data!.docChanges[index].doc.reference
                                      .update({
                                    'isPresent':
                                        FieldValue.arrayUnion([DateTime.now()])
                                  });
                                  setState(() {
                                    isPresent = true;
                                  });
                                } else {
                                  //try to remove the current date in array
                                  setState(() {
                                    isPresent = false;
                                  });
                                }
                                if (!rollList.contains(snapshot
                                    .data!.docChanges[index].doc['roll'])) {
                                  temp.add(snapshot
                                      .data!.docChanges[index].doc['name']
                                      .toString()
                                      .toUpperCase());
                                  rollList.add(snapshot
                                      .data!.docChanges[index].doc['roll']);
                                }
                                // if (temp.contains(snapshot
                                //         .data!.docChanges[index].doc['name']) &&
                                //     rollList.contains(snapshot
                                //         .data!.docChanges[index].doc['roll'])) {
                                //   temp.remove(snapshot
                                //       .data!.docChanges[index].doc['name']);
                                //   rollList.remove(snapshot
                                //       .data!.docChanges[index].doc['roll']);
                                // } else {
                                //   temp.add(snapshot
                                //       .data!.docChanges[index].doc['name']);
                                //   rollList.add(snapshot
                                //       .data!.docChanges[index].doc['roll']);
                                // }
                              },
                              child: Container(
                                height: 40.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: isPresent ? Colors.teal:Colors.red ,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Center(
                                  child: Text(
                                    isPresent ? 'Present' : 'Mark Present',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 55.w),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        add(uid: widget.uid)));
                          },
                          icon: Icon(
                            Icons.add_circle,
                            color: Colors.grey,
                            size: 50.h,
                          )),
                      SizedBox(
                        height: 20.h,
                      ),
                      Center(
                          child: Text(
                        "No students added yet. Click add button to add students.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ))
                    ],
                  ),
                ),
              );
            }
          } else {
            return Center();
          }
        },
      ),
    );
  }
}
