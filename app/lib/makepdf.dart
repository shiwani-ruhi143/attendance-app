import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class reportt extends StatefulWidget {
  List list;
  String clas;
  List rollList;
  reportt({required this.list, required this.clas, required this.rollList});
  @override
  State<reportt> createState() => _reporttState(list: list, clas: clas);
}

class _reporttState extends State<reportt> {
  List list;
  String clas;

  _reporttState({required this.list, required this.clas});
  final pdf = pw.Document();
  var marks;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pdf Document'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: PdfPreview(
        canChangeOrientation: false,
        canDebug: false,
        build: (format) => generateDocument(
          format,
        ),
      ),
    );
  }

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);
    final font1 = await PdfGoogleFonts.openSansRegular();
    final font2 = await PdfGoogleFonts.openSansBold();

    doc.addPage(
      pw.Page(        
        pageTheme: pw.PageTheme(
          pageFormat: format.copyWith(
            marginBottom: 0,
            marginLeft: 0,
            marginRight: 0,
            marginTop: 0,
          ),
          orientation: pw.PageOrientation.portrait,
          theme: pw.ThemeData.withFont(
            base: font1,
            bold: font2,
          ),
        ),
        build: (context) {
          return pw.Padding(
            // mainAxisAlignment: pw.MainAxisAlignment.center,
            padding: pw.EdgeInsets.symmetric(horizontal: 25.w,vertical: 10.h),
            child: pw.Column(
            children: [
              pw.SizedBox(
                height: 20,
              ),
              pw.Text(
                'Attendance Sheet',
                style: pw.TextStyle(
                  fontSize: 25.sp,
                ),
              ),
              pw.SizedBox(
                height: 20.h,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Row(children: [
                    pw.Text(
                      'Date :  ',
                      style: pw.TextStyle(
                        fontSize: 20.sp,
                      ),
                    ),
                    pw.Text(
                      DateTime.now().day.toString() +
                          "-" +
                          DateTime.now().month.toString() +
                          "-" +
                          DateTime.now().year.toString() +
                          " at " +
                          DateTime.now().hour.toString() +
                          ":" +
                          DateTime.now().minute.toString(),
                      style: pw.TextStyle(
                        fontSize: 20.sp,
                      ),
                    ),
                  ]),
                  pw.Row(
                    children: [
                      pw.Text(
                        'Class : ',
                        style: pw.TextStyle(
                          fontSize: 25,
                        ),
                      ),
                      pw.Text(
                        clas,
                        style: pw.TextStyle(
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Table(
                defaultColumnWidth: pw.FixedColumnWidth(120.0),
                border: pw.TableBorder.all(
                  style: pw.BorderStyle.solid,
                  width: 2,
                ),
                children: [
                  pw.TableRow(children: [
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            'Roll No',
                            style: pw.TextStyle(
                              fontSize: 20.sp,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ]),
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(
                            'Name',
                            style: pw.TextStyle(
                              fontSize: 20.sp,
                              fontWeight: pw.FontWeight.bold
                            ),
                          ),
                        ]),
                  ]),
                ],
              ),
              pw.ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return pw.Table(
                    defaultColumnWidth: pw.FixedColumnWidth(120.0),
                    border: pw.TableBorder.all(
                        // color: pw.Colors.black,
                        style: pw.BorderStyle.solid,
                        width: 2),
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Column(children: [
                            pw.Text(
                              widget.rollList[index],
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ]),
                          pw.Column(
                            children: [
                              pw.Text(
                                list[index],
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(fontSize: 20.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
            ),
          );
        },
      ),
    );

    return doc.save();
  }
}
