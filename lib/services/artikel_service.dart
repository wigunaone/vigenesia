import 'dart:io';

import 'package:dio/dio.dart';
import '../helper/api_client.dart';
import '../model/artikel.dart';

class ArtikelService {
  Future<List<Artikel>> listData() async {
    try {
      final Response response = await ApiClient().get('artikel');
      print(response);  // Debug: Inspect the full response
      
      // Check if response.data is a Map and contains the 'data' key
      if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
        final List data = response.data['data'];  // Extract the list from the 'data' field
        
        // Map the JSON data into a list of Artikel objects
        List<Artikel> result = data.map((json) => Artikel.fromJson(json)).toList();
        
        return result;
      } else {
        throw Exception('Unexpected response format: ${response.data}');
      }
    } catch (e) {
      print("Error fetching data: $e");
      throw Exception('Error fetching data: $e');
    }
  }
  Future<Artikel> save(Artikel artikel) async {
    print(artikel);
    var data = artikel.toJson();  // Convert Artikel object to JSON
    final Response response = await ApiClient().post('artikel', data);
    Artikel result = Artikel.fromJson(response.data);  // Convert response to Artikel object
    return result;
  }

  Future<Artikel> update(Artikel artikel, String id) async {
    var data = artikel.toJson();  // Convert Artikel object to JSON
    final Response response = await ApiClient().put('artikel/$id', data);
    Artikel result = Artikel.fromJson(response.data);  // Convert response to Artikel object
    return result;
  }

  Future<Artikel> getById(String id) async {
    final Response response = await ApiClient().get('artikel/$id');
    Artikel result = Artikel.fromJson(response.data);  // Convert response to Artikel object
    return result;
  }

  Future<Artikel> delete(String id) async {
    final Response response = await ApiClient().delete('artikel/$id');
    Artikel result = Artikel.fromJson(response.data);  // Convert response to Artikel object
    return result;
  }
  Future<String?> uploadImage(File image) async {
    try {
      String url = 'artikel/upload'; // Endpoint API untuk upload gambar

      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
      });

      // Mengirim POST request untuk upload gambar
      Response response = await ApiClient().post(url, formData);

      // Mengecek apakah status code 201 (Created)
      if (response.statusCode == 201) {
        // Mengambil nama file gambar dari response
        String imageName = response.data['name'];
        return imageName;
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception('Error uploading image: $e');
    }
  }
}
