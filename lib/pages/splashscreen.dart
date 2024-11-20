import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_version/const/cfont.dart';
import 'package:mobile_version/pages/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _counter = 5; // Set waktu hitungan mundur

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Timer untuk hitungan mundur
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_counter == 1) {
        timer.cancel();
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
      } else {
        setState(() {
          _counter--;
        });
      }
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo.png',
              width: 180,
            ),
            SizedBox(height: 30),
            Text(
              """Aplikasi ekstrakurikuler MAN 2 Kulon Progo memudahkan siswa
mendaftar dan mengikuti kegiatan, serta membantu guru untuk
memantau aktivitas siswa""",
textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FontType.interMedium,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}