import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class ImageMaskingPainter extends CustomPainter {

  final List<List<Offset>> paths;
  final ui.Image unColoredImage;
  final ui.Image coloredImage;

  ImageMaskingPainter({required this.paths, required this.unColoredImage, required this.coloredImage});


  @override
  void paint(Canvas canvas, Size size) {

    // Draw the bottom image first
    Rect dstRect = Rect.fromPoints(Offset.zero, Offset(size.width, size.height));
    canvas.drawImageRect(
        coloredImage, Rect.fromLTWH(0, 0, coloredImage.width.toDouble(), coloredImage.height.toDouble()), dstRect, Paint());

    // Draw the top image
    canvas.saveLayer(Rect.largest, Paint());
    Rect srcRect = Rect.fromLTWH(0, 0, unColoredImage.width.toDouble(), unColoredImage.height.toDouble());
    canvas.drawImageRect(unColoredImage, srcRect, dstRect, Paint());

    // Draw all paths
    for (List<Offset> path in paths) {
      Path pathToDraw = Path();
      if (path.isNotEmpty) {
        pathToDraw.moveTo(path.first.dx, path.first.dy);
        for (Offset point in path) {
          pathToDraw.lineTo(point.dx, point.dy);
        }
      }

        Paint erasePaint = Paint()
          ..blendMode = BlendMode.clear
          ..strokeWidth = 40
          ..style = PaintingStyle.stroke;
        //Platform check due to blur effect is not properly work on iOS/Web
        if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
          erasePaint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0); // Apply a blur effect for Android
        }
        canvas.drawPath(pathToDraw, erasePaint);
    }

    // Restore canvas to remove blend mode
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}


