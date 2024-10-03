import 'dart:convert';
import 'package:http/http.dart' as http;

class PixaApi {
  final String _baseUrl = 'https://pixabay.com/api/';

  // This function takes the API key, query, and page number as input
  Future<Map<String, dynamic>> getImages({
    required String apiKey,
    required String query,
    required int page,
  }) async {
    // Building the query parameters for the GET request
    final Map<String, String> queryParams = {
      'key': apiKey,
      'q': query,
      'page': page.toString(),
    };

    // Constructing the complete URL
    final Uri url = Uri.parse(_baseUrl).replace(queryParameters: queryParams);

    try {
      // Making the HTTP GET request
      final response = await http.get(url);

      // Checking for a successful response
      if (response.statusCode == 200) {
        // Parsing the JSON response
        return jsonDecode(response.body);
      } else {
        // Throwing an error if the request fails
        throw Exception('Failed to load images: ${response.statusCode}');
      }
    } catch (e) {
      // Handling any errors
      throw Exception('Error fetching images: $e');
    }
  }
}
