import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:khalti_client/khalti_client.dart';
import 'package:qrcode/generate.dart';
import 'package:qrcode/model/qr_code_model.dart';
import 'package:qrcode/utils/api_utils.dart';

import 'service/qr_code_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QrCodeService _qrCodeService = QrCodeService();
  KhaltiClient _flutterKhalti;
  final String _khaltiTestPublicKey = "test_public_key_5b9f8309f6b649fab4bba5fe7bb00b39";
  final String userId = "63010f021a61ffa0a58177da";

  @override
  void initState() {
    super.initState();
    _flutterKhalti = KhaltiClient.configure(
      publicKey: _khaltiTestPublicKey,
      paymentPreferences: [
        KhaltiPaymentPreference.KHALTI,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FutureBuilder<Response>(
                future: _qrCodeService.getQrAmountByUser(userId: userId),
                builder: (context, snapshot) {
                  var balance = 0;
                  if (snapshot.hasData) {
                    final response = snapshot.data;
                    if (response.statusCode >= 400) {
                      throw ApiUtils.handleHttpException(response);
                    }
                    final messageAndData = ApiUtils.getMessageAndSingleDataFromResponse(response);
                    final qrCodeModel = QrCodeModel.fromJson(messageAndData.data[0]);
                    return Text('Available Balance: ${qrCodeModel.amount} ');
                  } else if (snapshot.hasError) {
                    print('Error ${snapshot.error}');
                  }
                  return Text('Available Balance: $balance ');
                }),
            Image(image: NetworkImage("https://media.istockphoto.com/vectors/qr-code-scan-phone-icon-in-comic-style-scanner-in-smartphone-vector-vector-id1166145556")),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue, width: 3.0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () async {
                final codeScanner = await BarcodeScanner.scan();
                KhaltiProduct product = KhaltiProduct(
                  id: "test",
                  name: "QR Code Amount",
                  amount: double.parse(codeScanner.rawContent),
                );
                _flutterKhalti.startPayment(
                  product: product,
                  onSuccess: (data) async {
                    final amount = data['amount'];
                    final response = await _qrCodeService.updateQrAmount(userId: userId, amount: amount);
                    if (response.statusCode == 200) {
                      _qrCodeService.getQrAmountByUser(userId: userId);
                    } else {
                      BotToast.showText(text: 'Oops! Something Went Wrong');
                    }
                  },
                  onFailure: (data) {
                    print('Data $data');
                    BotToast.showText(text: 'Error');
                  },
                );
              },
              child: Text(
                "Scan QR CODE",
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            flatButton("Generate QR CODE", GeneratePage()),
          ],
        ),
      ),
    );
  }

  Widget flatButton(String text, Widget widget) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue, width: 3.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onPressed: () async {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
      },
      child: Text(
        text,
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }
}
