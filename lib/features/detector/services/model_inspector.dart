import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

Future<void> inspectModel() async {
  final data = await rootBundle.load(
    'assets/models/ssd_mobilenet_v1.tflite',
  );

  final interpreter = Interpreter.fromBuffer(
    data.buffer.asUint8List(),
  );

  print('===== TFLITE MODEL =====');

  print('Input tensors:');
  for (final tensor in interpreter.getInputTensors()) {
    print(
      'name=${tensor.name}, '
      'shape=${tensor.shape}, '
      'type=${tensor.type}',
    );
  }

  print('Output tensors:');
  for (final tensor in interpreter.getOutputTensors()) {
    print(
      'name=${tensor.name}, '
      'shape=${tensor.shape}, '
      'type=${tensor.type}',
    );
  }

  print('========================');

  interpreter.close();
}