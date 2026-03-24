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
    final http.Response response;
    try {
      response = await http.post(
        Uri.parse('$baseUrl/api/solve'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'letters': letters,
          'size': size,
          'repeats': repeats,
          'dictionary': dictionary,
        }),
      );
    } catch (e) {
      // Only transport-level I/O errors (e.g. SocketException) reach here.
      throw Exception('Network error: $e');
    }

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.cast<String>();
    } else {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(data['error'] ?? 'Failed to solve puzzle');
    }
  }
}
