import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../models/detection.dart';

class DetectorService {
  Isolate? _isolate;
  SendPort? _sendPort;

  Future<void> initialize() async {
    final receivePort = ReceivePort();

    _isolate = await Isolate.spawn(
      _isolateEntry,
      receivePort.sendPort,
    );

    _sendPort = await receivePort.first as SendPort;
  }

  Future<List<Detection>> detect({
    required Uint8List imageBytes,
    required int imageWidth,
    required int imageHeight,
    required List<String> labels,
  }) async {
    if (_sendPort == null) {
      throw StateError('DetectorService has not been initialized.');
    }

    final responsePort = ReceivePort();

    _sendPort!.send({
      'replyPort': responsePort.sendPort,
      'imageBytes': imageBytes,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'labels': labels,
    });

    final result = await responsePort.first;

    responsePort.close();

    if (result is String) {
      throw Exception(result);
    }

    return (result as List)
        .map(
          (item) => Detection(
            classId: item['classId'] as int,
            label: item['label'] as String,
            confidence: item['confidence'] as double,
            boundingBox: Rect.fromLTWH(
              (item['left'] as num).toDouble(),
              (item['top'] as num).toDouble(),
              (item['width'] as num).toDouble(),
              (item['height'] as num).toDouble(),
            ),
          ),
        )
        .toList();
  }

  Future<void> dispose() async {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _sendPort = null;
  }

  static Future<void> _isolateEntry(SendPort mainSendPort) async {
    final receivePort = ReceivePort();

    mainSendPort.send(receivePort.sendPort);

    final modelData = await rootBundle.load(
      'assets/models/ssd_mobilenet_v1.tflite',
    );

    final interpreter = Interpreter.fromBuffer(
      modelData.buffer.asUint8List(),
    );

    await for (final message in receivePort) {
      try {
        final replyPort = message['replyPort'] as SendPort;
        final imageBytes = message['imageBytes'] as Uint8List;
        final imageWidth = message['imageWidth'] as int;
        final imageHeight = message['imageHeight'] as int;
        final labels = List<String>.from(message['labels'] as List);

        final input = _prepareInput(
          imageBytes,
          imageWidth,
          imageHeight,
        );

        final boxes = List.generate(
          1,
          (_) => List.generate(
            10,
            (_) => List.filled(4, 0.0),
          ),
        );

        final classes = List.generate(
          1,
          (_) => List.filled(10, 0.0),
        );

        final scores = List.generate(
          1,
          (_) => List.filled(10, 0.0),
        );

        final count = List.filled(1, 0.0);

        final outputs = <int, Object>{
          0: boxes,
          1: classes,
          2: scores,
          3: count,
        };

        interpreter.runForMultipleInputs(
          [input],
          outputs,
        );

        final detections = <Map<String, dynamic>>[];

        for (var i = 0; i < 10; i++) {
          final score = (scores[0][i] as num).toDouble();

          if (score < 0.50) {
            continue;
          }

          final classId = (classes[0][i] as num).toInt();

          final box = boxes[0][i];

          final top = (box[0] as num).toDouble();
          final left = (box[1] as num).toDouble();
          final bottom = (box[2] as num).toDouble();
          final right = (box[3] as num).toDouble();

          detections.add({
            'classId': classId,
            'label': classId < labels.length
                ? labels[classId]
                : 'Unknown',
            'confidence': score,
            'left': left.clamp(0.0, 1.0),
            'top': top.clamp(0.0, 1.0),
            'width': (right - left).clamp(0.0, 1.0),
            'height': (bottom - top).clamp(0.0, 1.0),
          });
        }

        replyPort.send(detections);
      } catch (e) {
        final replyPort = message['replyPort'] as SendPort;
        replyPort.send(e.toString());
      }
    }

    interpreter.close();
  }

  static Uint8List _prepareInput(
    Uint8List imageBytes,
    int width,
    int height,
  ) {
    // Temporary implementation.
    //
    // The camera plugin gives us YUV420 on Android.
    // We'll add the YUV420 → RGB conversion in the next checkpoint.
    //
    // For now this simply verifies that the isolate and TFLite
    // interpreter are correctly connected.

    return imageBytes;
  }
}