import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_version/const/cAlert.dart';
import 'package:mobile_version/const/capi.dart';
import 'package:mobile_version/const/cfont.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AbsensiPage extends StatefulWidget {
  @override
  _AbsensiPageState createState() => _AbsensiPageState();
}

class _AbsensiPageState extends State<AbsensiPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final AlertWidget alertWidget = AlertWidget();
  QRViewController? controller;
  String? scannedCode;
  bool isLoading = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> sendAbsenceCode(String code) async {
    final String? token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    try {
      final Uri url =
          Uri.parse(ApiUri.baseUrl + ApiUri.absen).replace(queryParameters: {
        'attendance_code': code.toString(),
      }); // Ganti URL ini dengan API Anda.
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final dynamic responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        alertWidget.SuccessAlert(context, responseData['message']);
      } else {
        alertWidget.ErrorAlert(context, responseData['message']);
      }
    } catch (e) {
      alertWidget.ErrorAlert(context, "Terjadi kesalahan: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'Scan QR Code',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(30),
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Input Kode Presensi',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Kode Presensi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (value) {
                setState(() {
                  scannedCode = value;
                });
              },
            ),
            SizedBox(height: 20),
            if (scannedCode != null && scannedCode!.isNotEmpty)
              Text(
                'Scanned Code: $scannedCode',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (scannedCode != null && scannedCode!.isNotEmpty) {
                        sendAbsenceCode(scannedCode!);
                      } else {
                        alertWidget.ErrorAlert(
                            context, "Kode Absen Tidak Boleh Kosong");
                      }
                    },
              child: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'KIRIM',
                      style: TextStyle(
                        fontFamily: FontType.interBold,
                        fontSize: 14,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 64, 80, 223),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scannedCode != scanData.code) {
        setState(() {
          scannedCode = scanData.code;
        });
        sendAbsenceCode(scanData.code ?? '');
      }
    });
  }
}
