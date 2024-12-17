import 'package:dio/dio.dart';
import '../helper/api_client.dart';
import '../model/motivasi.dart';

class MotivasiService {
  Future<List<Motivasi>> listData({String? searchQuery}) async {
  try {
    // Initialize the base URL
    String url = 'Motivasi';
    
    // Append search query if it's not null or empty
    if (searchQuery != null && searchQuery.isNotEmpty) {
      // If searchQuery is present, use `?` for the first parameter, `&` for additional ones
      url += '?search=$searchQuery';
    }
    
    final Response response = await ApiClient().get(url);
    print(response);  // Debug: Inspect the full response
    
    // Check if the response contains data and map it to a list of Motivasi objects
    if (response.data is Map<String, dynamic> && response.data.containsKey('data')) {
      final List data = response.data['data'];  // Extract data from the 'data' field
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
