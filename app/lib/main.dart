import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'add.dart';
import 'package:firebase_core/firebase_core.dart';
import 'mainpage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.teal,
          scaffoldBackgroundColor: Colors.teal[50],
          indicatorColor: Colors.teal,
        ),
        debugShowCheckedModeBanner: false,
        title: 'Attendance app',
        home: Splash());
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 4),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home())));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 100.h),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "ATTENDANCE MANAGER",
                style: TextStyle(
                    fontSize: 25.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30.h,
              ),
              Image.asset(
                'assets/images/pic.png',
                height: 300.h,
              ),
              SizedBox(height: 50.h,),
              Text(
                '"Attend Today, Achieve Tomorrow"',
                style: TextStyle(color: Colors.white,fontSize: 15.sp),
              ),

              // SizedBox(height: 130.h,),
            ],
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController className = TextEditingController();
  TextEditingController branch = TextEditingController();
  TextEditingController year = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dialog(context);
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          backgroundColor: Color(0xFF009688),
          title: Text(
            'Manage Attendance',
            style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("classes").snapshots(),
          builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong!!"),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.teal,
                  ),
                );
              }
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListTile(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          tileColor: Color.fromARGB(255, 224, 223, 223),
                          title: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => mainpage(
                                          uid: snapshot.data!.docChanges[index]
                                              .doc.id)));
                            },
                            child: Row(
                              children: [
                                Text(
                                  snapshot
                                      .data!.docChanges[index].doc['className']
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.teal[700]),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                snapshot.data!.docChanges[index].doc['class']
                                    .toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                    color: Colors.teal[700]),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                snapshot.data!.docChanges[index].doc['year']
                                    .toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                    color: Colors.teal[700]),
                              ),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              print(snapshot.data!.docChanges[index].doc.id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => add(
                                          uid: snapshot.data!.docChanges[index]
                                              .doc.id)));
                            },
                            child: Text("Add students"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal),
                          ),
                        ),
                      );
                    }));
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
                              dialog(context);
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
                          "No classes created yet. Click add button to create new class.",
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
          })),
    );
  }

  Future<dynamic> dialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: Text(
              "Create Class",
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: className,
                  decoration: InputDecoration(
                      hintText: 'Name', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: branch,
                  decoration: InputDecoration(
                      hintText: 'Branch', border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: year,
                  decoration: InputDecoration(
                      hintText: 'Year', border: OutlineInputBorder()),
                )
              ],
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () async {
                    DocumentReference documentReference =
                        await FirebaseFirestore.instance
                            .collection("classes")
                            .add({
                      'className': className.text,
                      'count': 0,
                      'class': branch.text,
                      'year': year.text,
                      // 'uuid' : ''
                    });
                    //  await documentReference.update({
                    //     'uuid' : documentReference.id
                    //   });
                    setState(() {
                      className.clear();
                      branch.clear();
                      year.clear();
                      print(className.text);
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Save")),
            ],
          );
        }));
  }
}
