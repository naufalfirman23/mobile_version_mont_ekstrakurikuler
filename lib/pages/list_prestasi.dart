import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_version/const/capi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prestasi {
  final int id;
  final int idUser;
  final String namaPerlombaan;
  final String tanggalPerlombaan;
  final String juaraDicapai;
  final String bidangEkstrakurikuler;
  final String fileSertifikat;

  Prestasi({
    required this.id,
    required this.idUser,
    required this.namaPerlombaan,
    required this.tanggalPerlombaan,
    required this.juaraDicapai,
    required this.bidangEkstrakurikuler,
    required this.fileSertifikat,
  });

  factory Prestasi.fromJson(Map<String, dynamic> json) {
    return Prestasi(
      id: json['id'] ?? 0,
      idUser: json['id_user'] ?? 0,
      namaPerlombaan: json['nama_perlombaan'] ?? 'Tidak tersedia',
      tanggalPerlombaan: json['tanggal_perlombaan'] ?? 'Tidak tersedia',
      juaraDicapai: json['juara_dicapai'] ?? 'Tidak tersedia',
      bidangEkstrakurikuler: json['bidang_ekstrakurikuler'] ?? 'Tidak tersedia',
      fileSertifikat: json['file_sertifikat'] ?? '',
    );
  }
}

class ListPrestasiPage extends StatefulWidget {
  @override
  _ListPrestasiPageState createState() => _ListPrestasiPageState();
}

class _ListPrestasiPageState extends State<ListPrestasiPage> {
  List<Prestasi> dataPrestasi = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> fetchData() async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }
    final String apiUrl = ApiUri.baseUrl + ApiUri.prestasi;
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['data'] != null) {
          setState(() {
            dataPrestasi = (jsonResponse['data'] as List)
                .map((item) => Prestasi.fromJson(item))
                .toList();
            isLoading = false;
          });
        } else {
          throw Exception('Data tidak ditemukan');
        }
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Prestasi"),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : dataPrestasi.isEmpty
              ? Center(child: Text("Tidak ada data"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: dataPrestasi.length,
                    itemBuilder: (context, index) {
                      final prestasi = dataPrestasi[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPrestasiPage(prestasi: prestasi),
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
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage('assets/img/prestasi.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      prestasi.namaPerlombaan,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      prestasi.juaraDicapai,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      prestasi.bidangEkstrakurikuler,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
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

class DetailPrestasiPage extends StatelessWidget {
  final Prestasi prestasi;

  DetailPrestasiPage({required this.prestasi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Prestasi"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prestasi.namaPerlombaan,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text(
              "Tanggal: ${prestasi.tanggalPerlombaan}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              "Juara yang diraih:",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "${prestasi.juaraDicapai}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              "Bidang: ${prestasi.bidangEkstrakurikuler}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            prestasi.fileSertifikat.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: InteractiveViewer(
                            child: Image.network(
                              ApiUri.baseUrl.replaceFirst('/api', '') +
                                  'storage/' +
                                  prestasi.fileSertifikat,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    "Gambar tidak tersedia",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          ApiUri.baseUrl.replaceFirst('/api', '') +
                              'storage/' +
                              prestasi.fileSertifikat,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                "Gambar tidak tersedia",
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : Text("Sertifikat tidak tersedia"),
          ],
        ),
      ),
    );
  }
}
