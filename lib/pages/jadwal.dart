import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobile_version/const/capi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JadwalPage extends StatefulWidget {
  final Map<String, dynamic> ekskulData;

  JadwalPage({required this.ekskulData});

  @override
  _JadwalPageState createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  late Future<List<dynamic>> apiData;

  @override
  void initState() {
    super.initState();
    apiData = fetchData(widget.ekskulData['id_ekstrakurikuler']);
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<List<dynamic>> fetchData(int idEkstrakurikuler) async {
    final String? token = await _getToken();
    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    // Menambahkan id_ekstrakurikuler sebagai query parameter
    final Uri url = Uri.parse(ApiUri.baseUrl + ApiUri.mysession).replace(queryParameters: {
      'id_ekstrakurikuler': idEkstrakurikuler.toString(),
    });

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);  // Decode response jika status code 200
      } else {
        throw Exception('Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ekskulData['nama_ekstrakurikuler']),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(),
            SizedBox(height: 16.0),
            Text(
              'Pertemuan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: apiData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data available'));
                  } else {
                    // Mendapatkan data pertemuan
                    final data = snapshot.data!;

                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        // Mengurutkan data berdasarkan `is_attended`
                        data.sort((a, b) => (b['is_attended'] ? 1 : 0).compareTo(a['is_attended'] ? 1 : 0));
                        final session = data[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 4.0),
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.grey[900]!),
                            color: Color.fromARGB(255, 254, 253, 255),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pertemuan ${session['pertemuan']}',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Tanggal: ${session['session_date']}',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                  ),
                                  Text(
                                    'Waktu: ${session['start_time']} - ${session['end_time']}',
                                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                              Icon(
                                session['is_attended'] ? Icons.check_circle : Icons.cancel,
                                color: session['is_attended'] ? Colors.green : Colors.red,
                                size: 24,
                              ),
                            ],
                          ),
                        );
                      },
                    );

                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 216, 224, 250),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          _buildInfoRow('Ekstrakurikuler', widget.ekskulData['nama_ekstrakurikuler']),
          _buildInfoRow('Guru Pembimbing', widget.ekskulData['nama_guru']),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey[900]!),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 16))),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.blue),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
