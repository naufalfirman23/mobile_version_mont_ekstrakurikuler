import 'package:flutter/material.dart';
import 'package:mobile_version/pages/absen.dart';
import 'package:mobile_version/pages/akun.dart';
import 'package:mobile_version/pages/home.dart';

class MainPage extends StatefulWidget {
  
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int myIndex = 0;
  List<Widget> widgetList = [
    HomePage(),
    AbsensiPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(35.0), 
        child: AppBar(
          automaticallyImplyLeading: false, 
          backgroundColor: Color.fromARGB(255, 64, 80, 223), // Blue color
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner_outlined), label: 'Presensi'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: 'Akun'),
        ],
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        currentIndex: myIndex,
        selectedItemColor: Color.fromARGB(255, 64, 80, 223), // Color when selected (customizable)
        unselectedItemColor: Colors.black, // Color when not selected (customizable)
      ),
      body: widgetList[myIndex],
    );
  }
}

