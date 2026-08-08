import 'package:flutter/material.dart';

import '../models/detection.dart';

class DetectionPainter extends CustomPainter {
  final List<Detection> detections;
  final double cameraAspectRatio;

  DetectionPainter({
    required this.detections,
    required this.cameraAspectRatio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Camera image aspect ratio.
    //
    // Example:
    // 640 / 480 = 1.333
    //
    // The phone preview is portrait, so the camera image
    // has to be scaled and cropped to fill the screen.
    final cameraWidth = size.width;
    final cameraHeight = cameraWidth / cameraAspectRatio;

    double scale;
    double offsetX = 0;
    double offsetY = 0;

    if (cameraHeight < size.height) {
      // Height needs to fill the screen.
      scale = size.height / cameraHeight;

      final scaledWidth = cameraWidth * scale;

      offsetX = (size.width - scaledWidth) / 2;
    } else {
      scale = 1;
    }

    for (final detection in detections) {
      final box = detection.boundingBox;

      // Convert normalized coordinates into camera-image coordinates.
      var left = box.left * cameraWidth;
      var top = box.top * cameraHeight;
      var width = box.width * cameraWidth;
      var height = box.height * cameraHeight;

      // Apply the same scaling/cropping used by the preview.
      left = left * scale + offsetX;
      top = top * scale + offsetY;
      width *= scale;
      height *= scale;

      final rect = Rect.fromLTWH(
        left,
        top,
        width,
        height,
      );

      canvas.drawRect(rect, paint);

      final label =
          '${detection.label} '
          '${(detection.confidence * 100).toStringAsFixed(0)}%';

      textPainter.text = TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );

      textPainter.layout();

      final labelTop = rect.top - textPainter.height;

      canvas.drawRect(
        Rect.fromLTWH(
          rect.left,
          labelTop,
          textPainter.width + 6,
          textPainter.height + 2,
        ),
        Paint(),
      );

      textPainter.paint(
        canvas,
        Offset(
          rect.left + 3,
          labelTop,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant DetectionPainter oldDelegate,
  ) {
    return oldDelegate.detections != detections ||
        oldDelegate.cameraAspectRatio != cameraAspectRatio;
  }
}