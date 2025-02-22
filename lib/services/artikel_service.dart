import 'dart:io';

import 'package:dio/dio.dart';
import '../helper/api_client.dart';
import '../model/artikel.dart';

class ArtikelService {
  Future<List<Artikel>> listData({String? searchQuery}) async {
  try {
    // Initialize the base URL
    String url = 'artikel';
    
    // Append search query if it's not null or empty
    if (searchQuery != null && searchQuery.isNotEmpty) {
      // If searchQuery is present, use `?` for the first parameter, `&` for additional ones
      url += '?search=$searchQuery';
    }
    
    final Response response = await ApiClient().get(url);
    print(response);  // Debug: Inspect the full response
    
    // Check if the response contains data and map it to a list of Artikel objects
    if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
      final List data = response.data['data'];  // Extract data from the 'data' field
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

Future<List<Artikel>> listDataByUserId(String id_user, {String? searchQuery , String? id}) async {
  try {
    // Construct the API URL with optional search query
    String url = 'artikel/user?id_user=$id_user';
    if (searchQuery != null && searchQuery.isNotEmpty) {
      url += '&search=$searchQuery';  // Append search query to the URL if provided
    }
    if (id != null && id.isNotEmpty) {
      url += '&id=$id';  // Append search query to the URL if provided
    }

    // Send the GET request to the API to get the articles by user ID (and search query if available)
    final Response response = await ApiClient().get(url);
    print('Response: ${response.data}');  // Debug: Inspect the full response

    // Check if the response is a Map and contains the 'data' key
    if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
      final List<dynamic> data = response.data['data'];  // Extract the list of articles from the 'data' field

      // Check if data is empty
      if (data.isEmpty) {
        print('No articles found for this user.');
        return [];  // Return an empty list if no articles found
      }

      // Map the JSON data into a list of Artikel objects
      List<Artikel> result = data.map((json) => Artikel.fromJson(json)).toList();
      return result;
    } else {
      // If the response doesn't match the expected format, throw an exception
      throw Exception('Unexpected response format: ${response.data}');
    }
  } catch (e) {
    // Log the error and throw an exception with a meaningful message
    print("Error fetching data: $e");
    throw Exception('Error fetching articles for user $id_user: $e');
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
    print('update');
    var data = artikel.toJson();  // Convert Artikel object to JSON
    print(data);
    final Response response = await ApiClient().put('artikel?id= $id', data);
    Artikel result = Artikel.fromJson(response.data);  // Convert response to Artikel object
    return result;
  }

  Future<Artikel> getById(String id) async {
  // Memastikan URL benar dengan menambahkan '/' di antara 'artikel' dan ID
  final Response response = await ApiClient().get('artikel?id=$id'); 
  
  // Cek apakah status code dari respons API adalah 200 (OK)
  if (response.statusCode == 200) {
    // Pastikan respons data berada di dalam 'data' dan merupakan array
    if (response.data['status'] == 'success' && response.data['data'] is List && response.data['data'].isNotEmpty) {
      // Mengakses artikel pertama dalam array 'data'
      Artikel result = Artikel.fromJson(response.data['data'][0]);
      print(result);  // Menampilkan artikel yang berhasil diambil
      return result;
    } else {
      // Jika 'data' kosong atau tidak ada artikel yang ditemukan
      throw Exception('Artikel tidak ditemukan');
    }
  } else {
    // Jika status code tidak 200 (misalnya, 404, 500, dll)
    throw Exception('Gagal memuat data. Status Code: ${response.statusCode}');
  }
}


  Future<Map<String, dynamic>> delete(String id) async {
  // Create the query parameters
  final queryParameters = {
    'id_artikel': id,  // Send id_artikel as a query parameter
  };

  // Call the ApiClient's delete method with the query parameters
  final Response response = await ApiClient().delete('artikel?id_artikel=$id');
  
  if (response.statusCode == 200) {
    // Assuming the response contains a "status" and "message" in the "data" field
    Map<String, dynamic> result = {
      'status': response.data['status'],
      'message': response.data['data']['message'],
      'id': response.data['data']['id'], // The ID of the deleted resource
    };

    return result;
  } else {
    // In case of error, return an error message
    return {
      'status': 'error',
      'message': 'Failed to delete the resource.',
    };
  }
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
