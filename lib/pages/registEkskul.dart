import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_version/const/cAlert.dart';
import 'package:mobile_version/const/cApiService.dart';
import 'package:mobile_version/const/capi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendaftaranEkstrakurikuler extends StatefulWidget {
  @override
  _PendaftaranEkstrakurikulerState createState() =>
      _PendaftaranEkstrakurikulerState();
}

class _PendaftaranEkstrakurikulerState
    extends State<PendaftaranEkstrakurikuler> {
  final AlertWidget alertWidget = AlertWidget();
  bool isLoading = true;
  Map<String, dynamic>? dataClass;
  final ApiServices _apiServices = ApiServices();
  String? selectedEkstrakurikuler;
  int? selectedEkstrakurikulerId;
  int? selectedTeacherId;
  List<dynamic> ekstrakurikulerList = [];

  @override
  void initState() {
    super.initState();
    fetchDataEkskul();
  }

  Future<void> fetchDataEkskul() async {
    try {
      final response = await _apiServices.getDataEkskul(ApiUri.kelasEkstra);
      setState(() {
        dataClass = response;
        ekstrakurikulerList = dataClass!['ekstrakurikuler'];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Terjadi kesalahan: $e'),
      ));
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> daftarEkstrakurikuler() async {
    int? idSiswa = await _apiServices.getIdSiswa();
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    if (idSiswa != null) {
      final String message =
          'Apakah Anda yakin ingin mendaftar ekstrakurikuler ini?';

      // Tampilkan dialog konfirmasi
      alertWidget.showConfirmationDialog(
        context,
        message,
        () async {
          final url = Uri.parse(
              ApiUri.baseUrl + ApiUri.daftarkelasEkstra); // Endpoint POST
          final payload = {
            'id_siswa': idSiswa,
            'id_guru': selectedTeacherId,
            'id_ekstrakurikuler': selectedEkstrakurikulerId,
          };

          try {
            final response = await http.post(
              url,
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
              body: jsonEncode(payload),
            );

            if (response.statusCode == 200) {
              alertWidget.SuccessAlert(
                  context, "Berhasil Melakukan Pendaftaran");
            } else {
              final dynamic responseData = jsonDecode(response.body);
              final String errorMessage = responseData['error'];
              alertWidget.ErrorAlert(context, errorMessage);
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Terjadi kesalahan: $e')),
            );

            print("ANJING $e");
          }
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ID Siswa tidak ditemukan!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendaftaran Ekstrakurikuler'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih salah satu ekstrakurikuler untuk mendaftar:',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Pilih Ekstrakurikuler',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextButton(
                              onPressed: () {
                                _showEkstrakurikulerDialog(context);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  selectedEkstrakurikuler ??
                                      'Pilih Ekstrakurikuler',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: selectedEkstrakurikuler != null
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: selectedEkstrakurikuler != null
                            ? () => daftarEkstrakurikuler()
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 120, vertical: 12),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'DAFTAR',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showEkstrakurikulerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Ekstrakurikuler'),
          content: SingleChildScrollView(
            child: Column(
              children: ekstrakurikulerList.map((ekstra) {
                return ListTile(
                  title: Text(ekstra['name']),
                  subtitle: Text(ekstra['jadwal']),
                  onTap: () {
                    setState(() {
                      selectedEkstrakurikuler = ekstra['name'];
                      selectedEkstrakurikulerId = ekstra['id'];
                      selectedTeacherId = ekstra['teacher_id'];
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
