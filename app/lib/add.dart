import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class add extends StatefulWidget {
  var uid;
  add({required this.uid});
  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  TextEditingController name = TextEditingController();
  TextEditingController div = TextEditingController();
  TextEditingController rolln = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection('classes');
  // DocumentReference documentReference = ref.doc(widget.uid);
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

  Class() {
    getClass().then((value) {
      setState(() {
        branch = value;
      });
    });
    return branch;
  }

  Year() {
    getYear().then((value) {
      setState(() {
        year = value;
      });
    });
    return year;
  }

  var ww = 'IT 1st';
  List<String> options = ["IT", "CSE", "ECE", "Mech"];
  var _currentItemSelected = "IT";
  var rool = "IT";
  List<String> options1 = ["1st", "2nd", "3rd", "4th"];
  var _currentItemSelected1 = "1st";
  var rool1 = "1st";

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.teal,
          centerTitle: true,
          title: Text(
            'Student Data',
            style: TextStyle(fontSize: 20.sp),
          )),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(30.r),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              TextField(
                textAlign: TextAlign.center,
                controller: name,
                textCapitalization: TextCapitalization.values.first,
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                  // enabledBorder: OutlineInputBorder(
                  //     borderSide: BorderSide(color: Colors.teal,width: 2.w),
                  //     borderRadius: BorderRadius.circular(10.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2.w),
                      borderRadius: BorderRadius.circular(10.r)),
                  // errorBorder: OutlineInputBorder(
                  //     borderSide: BorderSide(color: Colors.teal),
                  //     borderRadius: BorderRadius.circular(10.r)),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              TextField(
                textAlign: TextAlign.center,
                controller: rolln,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2.w),
                      borderRadius: BorderRadius.circular(10.r)),
                  hintText: 'Roll Number',
                ),
              ),
              SizedBox(
                height: 35.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text('Class :   ' + Class().toString(),
                          style: TextStyle(fontSize: 15.sp)),
                      // DropdownButton<String>(
                      //   borderRadius: BorderRadius.circular(10.r),
                      //   dropdownColor: Colors.teal[300],
                      //   isDense: true,
                      //   isExpanded: false,
                      //   iconEnabledColor: Colors.teal,
                      //   focusColor: Colors.teal,
                      //   items: options.map((String dropDownStringItem) {
                      //     return DropdownMenuItem<String>(
                      //       value: dropDownStringItem,
                      //       child: Text(
                      //         dropDownStringItem,
                      //         style: TextStyle(
                      //           color: Color.fromARGB(255, 11, 0, 0),
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 20.sp,
                      //         ),
                      //       ),
                      //     );
                      //   }).toList(),
                      //   onChanged: (newValueSelected) {
                      //     setState(() {
                      //       _currentItemSelected = newValueSelected!;
                      //       rool = newValueSelected;
                      //       ww = "";
                      //       ww = _currentItemSelected +
                      //           " " +
                      //           _currentItemSelected1;
                      //     });
                      //     print(ww);
                      //   },
                      //   value: _currentItemSelected,
                      // ),
                    ],
                  ),
                  SizedBox(
                    width: 35,
                  ),
                  Row(
                    children: [
                      Text(
                        'Year :   ' + Year().toString(),
                        style: TextStyle(fontSize: 15.sp),
                      ),
                      // DropdownButton<String>(
                      //   borderRadius: BorderRadius.circular(10.r),
                      //   dropdownColor: Colors.teal[300],
                      //   isDense: true,
                      //   isExpanded: false,
                      //   iconEnabledColor: Colors.teal,
                      //   focusColor: Colors.teal,
                      //   items: options1.map((String dropDownStringItem) {
                      //     return DropdownMenuItem<String>(
                      //       value: dropDownStringItem,
                      //       child: Text(
                      //         dropDownStringItem,
                      //         style: TextStyle(
                      //           color: Color.fromARGB(255, 0, 0, 0),
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 20.sp,
                      //         ),
                      //       ),
                      //     );
                      //   }).toList(),
                      //   onChanged: (newValueSelected1) {
                      //     setState(() {
                      //       _currentItemSelected1 = newValueSelected1!;
                      //       rool1 = newValueSelected1;
                      //       ww = "";
                      //       ww = _currentItemSelected +
                      //           " " +
                      //           _currentItemSelected1;
                      //     });
                      //     print(ww);
                      //   },
                      //   value: _currentItemSelected1,
                      // ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  print(widget.uid);
                  // ref.doc(widget.uid).update({
                  //   'class': ww,
                  // });
                  ref.doc(widget.uid).collection('students').add({
                    'name': name.text,
                    'roll': rolln.text,
                    'isPresent': true,
                  })
                    ..whenComplete(() {
                      Fluttertoast.showToast(
                        msg: "Added",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.teal[300],
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      setState(() {
                        name.clear();
                        rolln.clear();
                      });
                    });
                },
                child: Text(
                  'Add Student',
                  style: TextStyle(
                    fontSize: 18.sp,
                    // fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
