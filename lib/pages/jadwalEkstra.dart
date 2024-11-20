import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_version/const/capi.dart';
import 'dart:convert'; // Untuk memparsing JSON
import 'package:mobile_version/pages/jadwal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListEkskul extends StatefulWidget {
  @override
  _ListEkskulState createState() => _ListEkskulState();
}

class _ListEkskulState extends State<ListEkskul> {
  List<dynamic> _ekskulData = [];
  bool _isLoading = true;

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Fungsi untuk mengambil data dari API
  Future<void> fetchEkskulData() async {
    final String? token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }
    final Uri url = Uri.parse(ApiUri.baseUrl + ApiUri.myKelas);
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Tambahkan Bearer Token pada header
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _ekskulData = data['data'];
          _isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchEkskulData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Ekstrakurikuler"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: _ekskulData.length,
                itemBuilder: (context, index) {
                  final ekskul = _ekskulData[index];
                  bool isStatusZero = ekskul['status'] == "0"; // Menambahkan kondisi untuk status

                  return GestureDetector(
                    onTap: isStatusZero
                        ? null // Tidak bisa ditekan jika status = 0
                        : () {
                            // Navigasi ke halaman detail ketika item diklik
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JadwalPage(ekskulData: ekskul),
                              ),
                            );
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Bagian gambar
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              image: DecorationImage(
                                image: AssetImage('assets/img/prestasi.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          // Bagian teks
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ekskul['nama_ekstrakurikuler'] ?? 'Nama tidak ditemukan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Hari ${ekskul['jadwal_ekstrakurikuler'] ?? 'Tidak tersedia'}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                // Menambahkan kondisi status
                                if (isStatusZero)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      "Belum terkonfirmasi",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
