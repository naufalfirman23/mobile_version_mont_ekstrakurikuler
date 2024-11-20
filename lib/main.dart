import 'package:flutter/material.dart';
import 'package:mobile_version/const/cfont.dart';
import 'package:mobile_version/pages/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.remove();
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    theme: ThemeData(
      fontFamily: FontType.interReg,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
    ),
    initialRoute: '/',
  ));
}

class MyApp extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
    return SplashScreen();
  }
}
