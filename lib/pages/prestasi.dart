import 'package:flutter/material.dart';
import 'package:mobile_version/pages/add_prestasi.dart';
import 'package:mobile_version/pages/list_prestasi.dart';

class PrestasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prestasi'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 216, 224, 250),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.dashboard_customize_rounded, color: Color.fromARGB(255, 9, 209, 89)),
                  title: Text('Tambah Prestasi'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddPrestasiPage()));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.list_alt, color: Colors.orange),
                  title: Text('Daftar Prestasi'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ListPrestasiPage()));

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
