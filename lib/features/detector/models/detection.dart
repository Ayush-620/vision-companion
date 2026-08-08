import 'dart:ui';

class Detection {
  final int classId;
  final String label;
  final double confidence;
  final Rect boundingBox;

  const Detection({
    required this.classId,
    required this.label,
    required this.confidence,
    required this.boundingBox,
  });
}