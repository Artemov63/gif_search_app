import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:gif_search_app/services/giphy_service.dart';

void main() {
  test('Returns GIF URLs from a successful response', () async {
    final mockClient = MockClient((request) async {
      return http.Response('''
        {
          "data": [
            {
              "images": {
  "fixed_width": {
    "url": "https://example.com/cat.gif",
    "width": "200",
    "height": "150"
  },
  "original": {
    "url": "https://example.com/cat-original.gif"
  }
}
            }
          ]
        }
        ''', 200);
    });

    final service = GiphyService(client: mockClient);

    final urls = await service.searchGifs('cats', 0);

    expect(urls.length, 1);
    expect(urls.first.url, 'https://example.com/cat.gif');
    expect(urls.first.width, 200);
    expect(urls.first.height, 150);
    expect(urls.first.originalUrl, 'https://example.com/cat-original.gif');

    service.dispose();
  });
  test('Throws exception when API returns 429', () async {
    final mockClient = MockClient((request) async {
      return http.Response('Too Many Requests', 429);
    });

    final service = GiphyService(client: mockClient);

    await expectLater(service.searchGifs('cats', 0), throwsException);

    service.dispose();
  });
  test('Returns empty list when no GIFs found', () async {
    final mockClient = MockClient((request) async {
      return http.Response('{"data": []}', 200);
    });

    final service = GiphyService(client: mockClient);

    final urls = await service.searchGifs('unknown', 0);

    expect(urls, isEmpty);

    service.dispose();
  });
}
