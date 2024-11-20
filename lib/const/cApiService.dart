import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_version/const/capi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  // Ambil Token
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Ambil Data User
  Future<Map<String, dynamic>?> getDataUser() async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final Uri url = Uri.parse(ApiUri.baseUrl + ApiUri.user);

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); 
      } else {
        throw Exception('Gagal mendapatkan data siswa: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
  // Ambil Data Ekstrakurikuler
  Future<Map<String, dynamic>?> getDataEkskul(String endpoint) async {
    final String? token = await _getToken();

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final Uri url = Uri.parse(ApiUri.baseUrl + endpoint);
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization':
              'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal ambil data ekstra: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<int?> getIdSiswa() async {
    final dataUser = await getDataUser(); 

    if (dataUser != null) {
      return dataUser['id'];
    } else {
      return null;
    }
  }
  

}
