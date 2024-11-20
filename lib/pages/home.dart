import 'package:flutter/material.dart';
import 'package:mobile_version/pages/ekskul.dart';
import 'package:mobile_version/pages/info.dart';
import 'package:mobile_version/pages/prestasi.dart';
import 'package:mobile_version/const/cApiService.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  Map<String, dynamic>? userData;
  
  final ApiServices _userServices = ApiServices();
  
  Future<void> _fetchUserData() async {
    try {
      final response = await _userServices.getDataUser();

      setState(() {
        userData = response; 
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

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 64, 80, 223),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat datang di MANDAKU',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${userData?['nama'] ?? 'Tidak tersedia'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Search',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                    ),
                  ),
                  // Menu Section
                  Transform.translate(
                    offset: Offset(0, 40), // Menjorok ke bawah
                    child: Container(
                      width: double.infinity, // Lebar penuh layar
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 223, 233, 241),
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Menu',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildMenuItem(
                                'assets/img/ekstra.png',
                                'Ekstrakurikuler',
                                () {
                                  // Aksi yang dijalankan saat item "Ekstrakurikuler" di-tap
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Ekstrakurikuler()));
                                },
                              ),
                              _buildMenuItem(
                                'assets/img/prestasi.png',
                                'Prestasi',
                                () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PrestasiPage()));
                                },
                              ),
                              _buildMenuItem(
                                'assets/img/pengumuman.png',
                                'Pengumuman',
                                () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              InformasiPage()));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Profile Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profil Sekolah',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 200, // Tinggi kontainer
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3, // Jumlah gambar
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 223, 233, 241),
                              image: DecorationImage(
                                image: AssetImage(
                                  index == 0
                                      ? 'assets/img/school_profile.png'
                                      : index == 1
                                          ? 'assets/img/school_profile.png'
                                          : 'assets/img/school_profile.png', // Gambar berbeda
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Berita',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildNewsItem('Judul', 'Isi berita sedikit'),
                        SizedBox(width: 10),
                        _buildNewsItem('Judul', 'Isi berita sedikit'),
                        SizedBox(width: 10),
                        _buildNewsItem('Judul', 'Isi berita sedikit'),
                        SizedBox(width: 10),
                        _buildNewsItem('Judul', 'Isi berita sedikit'),
                        SizedBox(width: 10),
                        _buildNewsItem('Judul', 'Isi berita sedikit'),
                        SizedBox(width: 10),
                        _buildNewsItem('Judul', 'Isi berita sedikit'),
                        SizedBox(width: 10),
                        _buildNewsItem('Judul', 'Isi berita sedikit'),
                        SizedBox(width: 10),
                        _buildNewsItem('Judul', 'Isi berita sedikit'),
                        SizedBox(width: 10),
                        _buildNewsItem('Judul', 'Isi berita sedikit'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menu Item Builder with onTap
  Widget _buildMenuItem(String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              shape: BoxShape.rectangle,
              color: Color.fromARGB(255, 159, 181, 243),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // News Item Builder
  Widget _buildNewsItem(String title, String description) {
    return Container(
      width: 120,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.blue[700]),
          ),
        ],
      ),
    );
  }
}
