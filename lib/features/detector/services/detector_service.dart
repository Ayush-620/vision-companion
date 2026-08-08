import '../models/coco_labels.dart';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../models/detection.dart';

class DetectorService {
  Isolate? _isolate;
  SendPort? _sendPort;

  Future<void> initialize() async {
    // Load the model in the Flutter isolate.
    // rootBundle cannot be used directly inside a spawned isolate.
    final modelData = await rootBundle.load(
      'assets/models/ssd_mobilenet_v1.tflite',
    );

    final modelBytes = modelData.buffer.asUint8List();

    final receivePort = ReceivePort();

    await Isolate.spawn<Map<String, dynamic>>(
      _isolateEntry,
      {
        'sendPort': receivePort.sendPort,
        'modelBytes': modelBytes,
      },
    );

    _sendPort = await receivePort.first as SendPort;
  }

  Future<List<Detection>> detect({
    required Uint8List rgbBytes,
    required int imageWidth,
    required int imageHeight,
  }) async {
    final sendPort = _sendPort;

    if (sendPort == null) {
      throw StateError(
        'DetectorService has not been initialized.',
      );
    }

    final responsePort = ReceivePort();

    sendPort.send({
      'replyPort': responsePort.sendPort,
      'rgbBytes': rgbBytes,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
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

  static Future<void> _isolateEntry(
    Map<String, dynamic> args,
  ) async {
    final mainSendPort = args['sendPort'] as SendPort;
    final modelBytes = args['modelBytes'] as Uint8List;

    final receivePort = ReceivePort();

    mainSendPort.send(receivePort.sendPort);

    final interpreter = Interpreter.fromBuffer(modelBytes);

    await for (final message in receivePort) {
      try {
        final replyPort = message['replyPort'] as SendPort;
        final rgbBytes = message['rgbBytes'] as Uint8List;
        final imageWidth = message['imageWidth'] as int;
        final imageHeight = message['imageHeight'] as int;

        final input = _prepareInput(
          rgbBytes,
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

  if (score < 0.65) {
    continue;
  }

  final classId = (classes[0][i] as num).toInt();

  final box = boxes[0][i];

  // SSD MobileNet format:
  // [top, left, bottom, right]
  final top = (box[0] as num).toDouble();
  final left = (box[1] as num).toDouble();
  final bottom = (box[2] as num).toDouble();
  final right = (box[3] as num).toDouble();

  final width = right - left;
  final height = bottom - top;

  if (width <= 0 || height <= 0) {
    continue;
  }

  detections.add({
    'classId': classId,
    'label': cocoLabels[classId] ?? 'class_$classId',
    'confidence': score,
    'left': left.clamp(0.0, 1.0),
    'top': top.clamp(0.0, 1.0),
    'width': width.clamp(0.0, 1.0),
    'height': height.clamp(0.0, 1.0),
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
    Uint8List rgbBytes,
    int width,
    int height,
  ) {
    final source = img.Image(
  width: width,
  height: height,
);

var index = 0;

for (var y = 0; y < height; y++) {
  for (var x = 0; x < width; x++) {
    source.setPixelRgb(
      x,
      y,
      rgbBytes[index],
      rgbBytes[index + 1],
      rgbBytes[index + 2],
    );

    index += 3;
  }
}

final rotated = img.copyRotate(
  source,
  angle: 90,
);

final resized = img.copyResize(
  rotated,
  width: 300,
  height: 300,
  interpolation: img.Interpolation.nearest,
);

    final input = Uint8List(
      1 * 300 * 300 * 3,
    );

    index = 0;

    for (var y = 0; y < 300; y++) {
      for (var x = 0; x < 300; x++) {
        final pixel = resized.getPixel(x, y);

        input[index++] = pixel.r.toInt();
        input[index++] = pixel.g.toInt();
        input[index++] = pixel.b.toInt();
      }
    }

    return input;
  }
}