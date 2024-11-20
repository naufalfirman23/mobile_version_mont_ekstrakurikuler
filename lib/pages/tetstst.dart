
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:mobile_version/const/cAlert.dart';
import 'package:mobile_version/const/capi.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class AddPrestasiPage extends StatefulWidget {
  @override
  _AddPrestasiPageState createState() => _AddPrestasiPageState();
}

class _AddPrestasiPageState extends State<AddPrestasiPage> {
  DateTime? selectedDate;
  final TextEditingController namaController = TextEditingController();
  final TextEditingController juaraController = TextEditingController();
  final TextEditingController bidangController = TextEditingController();
  File? selectedFile; // File yang dipilih

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Method untuk membuka file picker
  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'], // Ekstensi file
      );

      if (result != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
        });
      } else {
        print("File picker dibatalkan oleh pengguna");
      }
    } catch (e) {
      print("Error saat memilih file: $e");
    }
  }

  Future<void> _submitData() async {
    final AlertWidget alertWidget = AlertWidget();
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    if (namaController.text.isEmpty ||
        selectedDate == null ||
        juaraController.text.isEmpty ||
        bidangController.text.isEmpty ||
        selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Harap isi semua bidang dan unggah file")),
      );
      return;
    }

    final url = Uri.parse(ApiUri.baseUrl + ApiUri.addSertifikat);

    try {
      // Buat request multipart untuk upload file
      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $token' // Menambahkan Bearer Token
        ..fields['nama_perlombaan'] = namaController.text
        ..fields['tanggal_perlombaan'] = selectedDate!.toIso8601String()
        ..fields['juara_dicapai'] = juaraController.text
        ..fields['bidang_ekstrakurikuler'] = bidangController.text
        ..files.add(await http.MultipartFile.fromPath(
          'file_sertifikat',
          selectedFile!.path,
        ));

      // Kirim request
      final response = await request.send();

      if (response.statusCode == 200) {
        alertWidget.SuccessAlert(context, "Data Berhasil Ditambahkan");
        Navigator.pop(context);
      } else {
        final responseBody = await response.stream.bytesToString();
        alertWidget.ErrorAlert(context, "Data Gagal Ditambahkan $responseBody");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Prestasi Siswa',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Perlombaan Field
                    Text("Nama Perlombaan"),
                    SizedBox(height: 8),
                    TextField(
                      controller: namaController,
                      decoration: InputDecoration(
                        hintText: "Nama Perlombaan",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Tanggal Perlombaan Field with Calendar Picker
                    Text("Tanggal Perlombaan"),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: selectedDate == null
                                ? "Pilih Tanggal"
                                : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Juara yang Diraih Field
                    Text("Juara yang Diraih"),
                    SizedBox(height: 8),
                    TextField(
                      controller: juaraController,
                      decoration: InputDecoration(
                        hintText: "Juara yang Diraih",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Bidang Ekstrakurikuler Field
                    Text("Bidang Ekstrakurikuler"),
                    SizedBox(height: 8),
                    TextField(
                      controller: bidangController,
                      decoration: InputDecoration(
                        hintText: "Bidang Ekstrakurikuler",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Upload Sertifikat/Bukti Penghargaan Field
                    Text("Upload Sertifikat/Bukti Penghargaan"),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _pickFile,
                      child: Text(selectedFile == null
                          ? "Pilih File"
                          : "File: ${selectedFile!.path.split('/').last}"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    "TAMBAH",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}


// saya ingin fungsional pada kode anda diterapkan pada kode saya tanpa merubah tampilan