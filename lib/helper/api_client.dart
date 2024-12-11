import 'dart:io';
import 'package:dio/dio.dart';
const String baseUrl = 'http://10.0.2.2/vigenesia_api/';
// const String baseUrl = 'http://192.168.18.75/vigenesia_api/';

final Dio dio = Dio(BaseOptions(
    // baseUrl: 'http://192.168.18.77:3000/api/',
    baseUrl: baseUrl + 'index.php/api/',
    connectTimeout: const Duration(minutes: 1),
    receiveTimeout: const Duration(minutes: 1)));

class ApiClient {
  Future<Response> get(String path) async {
    try {
      final response = await dio.get(Uri.encodeFull(path));
      return response;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<Response> post(String path, dynamic data) async {
    try {
      print(Uri.encodeFull(path) + " check");
      final response = await dio.post(Uri.encodeFull(path), data: data);
      return response;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<Response> put(String path, dynamic data) async {
    try {
      final response = await dio.put(Uri.encodeFull(path), data: data);
      return response;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<Response> delete(String path) async {
    try {
      final response = await dio.delete(Uri.encodeFull(path));
      return response;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
  // Fungsi untuk upload gambar ke server
  Future<Response> uploadImage(String path, File imageFile) async {
    try {
      // Menyiapkan data untuk dikirimkan ke server
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imageFile.path, filename: 'img${DateTime.now().millisecondsSinceEpoch}.jpg'),
      });

      // Mengirim POST request dengan data gambar
      final response = await dio.post(Uri.encodeFull(path), data: formData);

      return response;
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
