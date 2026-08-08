import 'dart:typed_data';

import 'package:camera/camera.dart';

class YuvConverter {
  static Uint8List convertToRgb(CameraImage image) {
    final width = image.width;
    final height = image.height;

    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final yBytes = yPlane.bytes;
    final uBytes = uPlane.bytes;
    final vBytes = vPlane.bytes;

    final yRowStride = yPlane.bytesPerRow;
    final uRowStride = uPlane.bytesPerRow;
    final uPixelStride = uPlane.bytesPerPixel ?? 1;
    final vRowStride = vPlane.bytesPerRow;
    final vPixelStride = vPlane.bytesPerPixel ?? 1;

    final rgb = Uint8List(width * height * 3);

    var outputIndex = 0;

    for (var y = 0; y < height; y++) {
      final yRowStart = y * yRowStride;
      final uvRow = y ~/ 2;

      for (var x = 0; x < width; x++) {
        final uvColumn = x ~/ 2;

        final yIndex = yRowStart + x;

        final uIndex =
            uvRow * uRowStride + uvColumn * uPixelStride;

        final vIndex =
            uvRow * vRowStride + uvColumn * vPixelStride;

        final yValue = yBytes[yIndex];
        final uValue = uBytes[uIndex];
        final vValue = vBytes[vIndex];

        final yAdjusted = yValue - 16;
        final uAdjusted = uValue - 128;
        final vAdjusted = vValue - 128;

        var r = (1.164 * yAdjusted) + (1.596 * vAdjusted);
        var g =
            (1.164 * yAdjusted) -
            (0.392 * uAdjusted) -
            (0.813 * vAdjusted);
        var b = (1.164 * yAdjusted) + (2.017 * uAdjusted);

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        rgb[outputIndex++] = r.toInt();
        rgb[outputIndex++] = g.toInt();
        rgb[outputIndex++] = b.toInt();
      }
    }

    return rgb;
  }
}