import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_version/pages/login.dart'; // Pastikan path ini sesuai dengan project Anda

class AccountPage extends StatelessWidget {

  // Fungsi logout
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken'); // Menghapus token yang disimpan

    // Setelah logout, arahkan pengguna ke halaman login
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bagian "Ganti Kata Sandi"
              Text(
                'Ganti Kata Sandi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: TextButton(
                  onPressed: () {
                    // Tambahkan fungsi untuk mengganti kata sandi
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Ganti Kata Sandi',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Bagian "Keluar Akun"
              Text(
                'Keluar Akun',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 226, 35, 35),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                child: TextButton(
                  onPressed: () {
                    _logout(context); 
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Keluar Akun',
                      style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
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
}
