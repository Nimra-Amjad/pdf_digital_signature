import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:signature/signature.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? exportedImage;

  SignatureController controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.grey,
  );

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 700,
                child: SfPdfViewer.asset('assets/Nimra Amjad.pdf'),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      signature();
                    },
                    child: const Text("Signature"),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  if (exportedImage != null)
                    Image.memory(
                      exportedImage!,
                      width: 80,
                      height: 100,
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
