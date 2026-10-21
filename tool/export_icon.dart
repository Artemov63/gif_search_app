import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gif_search_app/app_icon_painter.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Export app icon to PNG', () async {
    const imageSize = 1024.0;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final painter = AppIconPainter();

    painter.paint(canvas, const Size(imageSize, imageSize));

    final picture = recorder.endRecording();
    final image = await picture.toImage(1024, 1024);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Failed to export app icon');
    }

    final file = File('assets/app_icon.png');

    await file.writeAsBytes(byteData.buffer.asUint8List());

    image.dispose();
    picture.dispose();
  });
}
