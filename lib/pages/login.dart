import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_version/const/cAlert.dart';
import 'package:mobile_version/const/capi.dart';
import 'package:mobile_version/const/cfont.dart';
import 'package:mobile_version/pages/mainPage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AlertWidget alertWidget = AlertWidget();

  bool _isLoading = false;

  Future<void> _login() async {
    final String nis = _studentIdController.text;
    final String password = _passwordController.text;

    final Uri url = Uri.parse(ApiUri.baseUrl + ApiUri.login);
    setState(() {
      _isLoading = true;
    });
    try {
      final http.Response response = await http.post(
        url,
        body: jsonEncode(<String, String>{'nis': nis, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);
        final String accessToken = responseData['token'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      } else {
        final dynamic responseData = jsonDecode(response.body);
        final String errorMessage = responseData['error'];
        alertWidget.ErrorAlert(context, errorMessage);


      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    if (accessToken != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Wrap the entire body in a SingleChildScrollView
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                // Logo
                Image.asset(
                  'assets/img/logo.png', // Path to logo
                  width: 150,
                ),
                SizedBox(height: 20),
                // School name and description text
                Text(
                  'MAN 2 KULON PROGO',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: FontType.interSemiBold,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Aplikasi ekstrakurikuler MAN 2 Kulon Progo memudahkan siswa '
                  'mendaftar dan mengikuti kegiatan, serta membantu guru untuk '
                  'memantau aktivitas siswa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 30),
                // Input fields
                TextField(
                  controller: _studentIdController,
                  decoration: InputDecoration(
                    labelText: 'No Induk Siswa',
                    hintText: 'No Induk Siswa',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Color.fromARGB(255, 64, 80, 223),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
