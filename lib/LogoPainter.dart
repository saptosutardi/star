import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class LogoPainter extends CustomPainter {
  final ImageProvider image;
  final int count;

  LogoPainter({required this.image, this.count = 50});

  @override
  void paint(Canvas canvas, Size size) async {
    final paint = Paint();
    final random = Random();
    final imageStream = image.resolve(const ImageConfiguration());
    final completer = Completer<ImageInfo>();
    final listener = ImageStreamListener((info, _) => completer.complete(info));

    imageStream.addListener(listener);
    final imageInfo = await completer.future;
    final logo = imageInfo.image;

    for (int i = 0; i < count; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final rect = Rect.fromLTWH(x, y, 30, 30); // Ukuran logo bisa disesuaikan
      canvas.drawImageRect(logo, Rect.fromLTWH(0, 0, logo.width.toDouble(), logo.height.toDouble()), rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
