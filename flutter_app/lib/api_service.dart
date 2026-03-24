import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<String>> solve({
    required String letters,
    required int size,
    required bool repeats,
    required String dictionary,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/solve'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'letters': letters,
          'size': size,
          'repeats': repeats,
          'dictionary': dictionary,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<String>();
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? 'Failed to solve puzzle');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
