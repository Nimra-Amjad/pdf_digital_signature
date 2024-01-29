import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as p;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? exportedImage;
  double bottom = 0.0;
  double right = 0.0;

  SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.grey,
  );

  Future<void> makePDF() async {
    final pdf = p.Document();
    pdf.addPage(p.Page(build: (context) {
      return p.Column(children: [p.Text("Nimra Amjad")]);
    }));
    Directory? downloadsDirectory = await getExternalStorageDirectory();
    String path = '${downloadsDirectory!.path}/test12345.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    print("Path " + path);
    Fluttertoast.showToast(
        msg: "Downloaded",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void signature() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Signature'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Text('Draw your signature:'),
                Signature(
                  controller: controller,
                  width: 400,
                  height: 400,
                  backgroundColor: Colors.lightBlue[100]!,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                TextButton(
                  child: const Text('Clear'),
                  onPressed: () async {
                    controller.clear();
                  },
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    exportedImage = await controller.toPngBytes();
                    //API
                    setState(() {});
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    controller.clear();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 700,
                      child: SfPdfViewer.asset('assets/Nimra Amjad.pdf'),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    if (exportedImage != null)
                      Positioned(
                        bottom: bottom,
                        right: right,
                        child: GestureDetector(
                          onPanUpdate: (details) {
                            setState(() {
                              right = max(0, right - details.delta.dx);
                              bottom = max(0, bottom - details.delta.dy);
                            });
                          },
                          child: Image.memory(
                            exportedImage!,
                            width: 80,
                            height: 60,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        signature();
                      },
                      child: Text(exportedImage != null
                          ? "Edit Signature"
                          : "Signature"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        makePDF();
                      },
                      child: const Text("Download Pdf"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
