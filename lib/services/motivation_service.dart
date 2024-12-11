import 'package:dio/dio.dart';
import '../helper/api_client.dart';
import '../model/motivasi.dart';

class MotivasiService {
  Future<List<Motivasi>> listData() async {
    try {
      final Response response = await ApiClient().get('motivasi');
      print(response);  // Debug: Inspect the full response
      
      // Check if response.data is a Map and contains the 'data' key
      if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
        final List data = response.data['data'];  // Extract the list from the 'data' field
        
        // Map the JSON data into a list of Motivasi objects
        List<Motivasi> result = data.map((json) => Motivasi.fromJson(json)).toList();
        
        return result;
      } else {
        throw Exception('Unexpected response format: ${response.data}');
      }
    } catch (e) {
      print("Error fetching data: $e");
      throw Exception('Error fetching data: $e');
    }
  }
  Future<Motivasi> save(Motivasi motivasi) async {
    var data = motivasi.toJson();  // Convert Motivasi object to JSON
    final Response response = await ApiClient().post('motivasi', data);
    Motivasi result = Motivasi.fromJson(response.data);  // Convert response to Motivasi object
    return result;
  }

  Future<Motivasi> update(Motivasi motivasi, String id) async {
    var data = motivasi.toJson();  // Convert Motivasi object to JSON
    final Response response = await ApiClient().put('motivasi/$id', data);
    Motivasi result = Motivasi.fromJson(response.data);  // Convert response to Motivasi object
    return result;
  }

  Future<Motivasi> getById(String id) async {
    final Response response = await ApiClient().get('motivasi/$id');
    Motivasi result = Motivasi.fromJson(response.data);  // Convert response to Motivasi object
    return result;
  }

  Future<Motivasi> delete(String id) async {
    final Response response = await ApiClient().delete('motivasi/$id');
    Motivasi result = Motivasi.fromJson(response.data);  // Convert response to Motivasi object
    return result;
  }
}
