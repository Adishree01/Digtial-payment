import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrCodeResult = "Not Yet Scanned";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Result",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              qrCodeResult,
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20.0,
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.blue, width: 3.0), borderRadius: BorderRadius.circular(20.0)),
              ),
              onPressed: () async {
                final codeScanner = await BarcodeScanner.scan();
                setState(() {
                  qrCodeResult = codeScanner.rawContent;
                });
              },
              child: Text(
                "Open Scanner",
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

//its quite simple as that you can use try and catch staatements too for platform exception
}
