import 'dart:convert';
import 'package:dio/dio.dart';
import '../helper/user_info.dart';
import '../helper/api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  // Fungsi login yang mengirimkan request ke API
  Future<bool> login(String email, String password) async {
    bool isLogin = false;

    try {
      // Menyiapkan payload untuk dikirimkan ke API
      final payload = {
        'email': email,
        'password': password,
      };
      print("Login data: $payload");

      // Mengirimkan request POST ke endpoint login API
      final response = await _apiClient.post('auth', payload) ;
      // Mengecek jika response adalah map dan mengandung key 'data'
      if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
        // Jika statusnya "success"
        if (response.data['status'] == "success") {
          final data = response.data['data'];

          // Menyimpan data token, userID, dan email di SharedPreferences
          await UserInfo().setToken(data['token']);
          await UserInfo().setUserID(data['idUser'].toString());
          await UserInfo().setEmail(data['email']);  // Simpan email

          isLogin = true; // Set isLogin to true after successful login
        }
      }
    
    } catch (e) {
      print('Error during login: $e');
    }
    return isLogin;
    
  }

  // Fungsi register (opsional, jika diperlukan)
  Future<bool> register(String nama, String email, String password) async {
    bool isRegistered = false;
    final payload = {
      'nama': nama,
      'email': email,  // Gunakan email untuk registrasi
      'password': password,
    };
    // Mengirimkan request POST ke endpoint login API
      final response = await _apiClient.post('auth/register', payload) ;
      // Mengecek jika response adalah map dan mengandung key 'data'
      if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
        // Jika statusnya "success"
        if (response.data['status'] == "success") {
          final data = response.data['data'];

          // Menyimpan data token, userID, dan email di SharedPreferences
          // await UserInfo().setToken(data['token']);
          // await UserInfo().setUserID(data['idUser'].toString());
          // await UserInfo().setEmail(data['email']);  // Simpan email

          isRegistered = true; // Set isLogin to true after successful login
        }
      }
    
    return isRegistered;
  }
}
