import 'package:flutter/material.dart';
import './home_screen.dart';
import './login_screen.dart';
import './url_screen.dart';
import './patient_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/url': (context) => UrlScreen(),
        '/patient': (context) => PatientScreen(patientId: "",),
      },
    );
  }
}
