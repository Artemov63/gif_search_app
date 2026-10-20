import 'package:http/http.dart' as http;

import 'dart:convert';

import '../models/gif_item.dart';

class GiphyService {
  GiphyService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String apiKey = String.fromEnvironment('GIPHY_API_KEY');

  Future<List<GifItem>> searchGifs(String query, int offset) async {
    final isTrending = query.trim().isEmpty;

    final url = Uri.https(
      'api.giphy.com',
      isTrending ? '/v1/gifs/trending' : '/v1/gifs/search',
      {
        'api_key': apiKey,
        if (!isTrending) 'q': query,
        'limit': '25',
        'offset': offset.toString(),
      },
    );

    final response = await _client.get(url);
    if (response.statusCode != 200) {
      throw Exception('GIPHY API error: ${response.statusCode}');
    }

    final jsonData = jsonDecode(response.body);
    final gifs = jsonData['data'];

    return [
      for (final gif in gifs)
        GifItem(
          url: gif['images']['fixed_width']['url'] as String,
          originalUrl: gif['images']['original']['url'] as String,
          title: gif['title'] as String? ?? 'Untitled GIF',
          width: int.parse(gif['images']['fixed_width']['width']),
          height: int.parse(gif['images']['fixed_width']['height']),
        ),
    ];
  }

  void dispose() {
    _client.close();
  }
}
