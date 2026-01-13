import 'package:dio/dio.dart';

class QuoteService {
  final Dio _dio = Dio();

  static const String _baseUrl =
      'https://quotableioapiexpress-js-proxy.vercel.app';

  Future<Map<String, dynamic>> getRandomQuote() async {
    try {
      final response = await _dio.get('$_baseUrl/api/quote');

      if (response.statusCode == 200 &&
          ((response.data is Map<String, dynamic> &&
                  (response.data as Map<String, dynamic>).isNotEmpty) ||
              (response.data is List && (response.data as List).isNotEmpty))) {
        final quoteData = response.data is List
            ? (response.data as List).first
            : response.data as Map<String, dynamic>;
        return {
          'id': quoteData['_id'] ?? '',
          'text': quoteData['content'] ?? '',
          'author': quoteData['author'] ?? 'Unknown',
          'category': (quoteData['tags'] as List?)?.isNotEmpty == true
              ? (quoteData['tags'] as List).first
              : 'Inspiration',
        };
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      throw Exception('Failed to fetch quote: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
