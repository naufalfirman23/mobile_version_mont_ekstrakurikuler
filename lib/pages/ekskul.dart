import 'package:flutter/material.dart';
import 'package:mobile_version/pages/jadwalEkstra.dart';
import 'package:mobile_version/pages/kehadiran.dart';
import 'package:mobile_version/pages/registEkskul.dart';
import 'package:mobile_version/pages/rekapNilai.dart';

class Ekstrakurikuler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ekstrakurikuler'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Aksi untuk tombol kembali
          },
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter, // Menempatkan di atas
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 216, 224, 250),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Supaya background tidak full ke bawah
              children: [
                ListTile(
                  leading: Icon(Icons.app_registration, color: Colors.red),
                  title: Text('Pendaftaran Ekstrakurikuler'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PendaftaranEkstrakurikuler()));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.orange),
                  title: Text('Kehadiran Siswa'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => KehadiranPage()));

                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.assessment, color: Colors.purple),
                  title: Text('Rekap Nilai'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RekapNilaiPage()));
                    // Navigasi ke halaman Rekap Nilai
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.card_membership, color: Colors.blue),
                  title: Text('Kartu Ekstrakurikuler'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigasi ke halaman Kartu Ekstrakurikuler
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.schedule, color: Colors.green),
                  title: Text('Jadwal Ekstrakurikuler'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ListEkskul()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// void main() {
//   runApp(MaterialApp(
//     home: Ekstrakurikuler(),
//   ));
// }
