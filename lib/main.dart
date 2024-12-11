import 'package:flutter/material.dart';
import './ui/welcome.dart';
import './helper/user_info.dart';
import './ui/base.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var token = await UserInfo().getToken();
  await UserInfo().logout();
  runApp(MaterialApp(
    title: "Vigenesia",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(// Menetapkan latar belakang putih
      dialogBackgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: Colors.blue, // Warna utama aplikasi
    ),
    home: token == null ? const Welcome() : const Base(),
  ));
}