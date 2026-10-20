import 'package:flutter/material.dart';

import '../models/gif_item.dart';

import 'package:flutter/services.dart';

class GifDetailsScreen extends StatelessWidget {
  const GifDetailsScreen({super.key, required this.gif});

  final GifItem gif;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Copy GIF link',
            icon: const Icon(Icons.copy),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: gif.originalUrl));
            },
          ),
        ],

        title: Text(
          gif.title.trim().isEmpty ? 'Untitled GIF' : gif.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final gifRatio = gif.width / gif.height;
            final screenRatio = constraints.maxWidth / constraints.maxHeight;

            final imageWidth = gifRatio > screenRatio
                ? constraints.maxWidth
                : constraints.maxHeight * gifRatio;

            return Center(
              child: SizedBox(
                width: imageWidth,
                height: imageWidth / gifRatio,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    gif.originalUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              size: 48,
                              color: Colors.white54,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Unable to load GIF',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Powered by GIPHY',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: Colors.white54),
          ),
        ),
      ),
    );
  }
}
