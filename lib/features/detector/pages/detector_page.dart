import '../services/speech_service.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../history/repository/history_repository.dart';
import '../services/detector_service.dart';
import '../services/yuv_converter.dart';
import '../models/detection.dart';
import '../widgets/detection_painter.dart';

class DetectorPage extends StatefulWidget {
  const DetectorPage({super.key});

  @override
  State<DetectorPage> createState() => _DetectorPageState();
}

class _DetectorPageState extends State<DetectorPage> {
  CameraController? _controller;
  DetectorService? _detectorService;

  List<Detection> _detections = [];

  bool _initializing = true;
  bool _processingFrame = false;
  bool _paused = false;

  String? _error;
  String _status = 'Starting camera...';

  final SpeechService _speechService = SpeechService();

  final HistoryRepository _historyRepository =
    getIt<HistoryRepository>();

final Map<String, DateTime> _lastSpoken = {};

static const Duration _speechCooldown = Duration(
  seconds: 3,
);

  // COCO labels used by SSD MobileNet.
  

  @override
  void initState() {
    super.initState();
    _initialize();
  }

   Future<void> _announceDetections(
  List<Detection> detections,
) async {
  if (detections.isEmpty || _paused) {
    return;
  }

  final now = DateTime.now();

  final objectsToSpeak = <String>[];

  for (final detection in detections) {
    if (detection.confidence < 0.65) {
      continue;
    }

    final label = detection.label;

    final lastTime = _lastSpoken[label];

    if (lastTime != null &&
        now.difference(lastTime) < _speechCooldown) {
      continue;
    }

    _lastSpoken[label] = now;

    objectsToSpeak.add(label);
  }

  if (objectsToSpeak.isEmpty) {
    return;
  }

  final uniqueObjects = objectsToSpeak.toSet().toList();

  final message = uniqueObjects.length == 1
    ? '${uniqueObjects.first} detected'
    : '${uniqueObjects.join(', ')} detected';

await _speechService.speak(message);
try {
  await _historyRepository.saveHistory(
    featureType: 'detector',
    resultSummary: message,
  );
} catch (e) {
  debugPrint('History save failed: $e');
}
await _historyRepository.saveHistory(
  featureType: 'detector',
  resultSummary: message,
);
}   

  Future<void> _initialize() async {
    try {
      setState(() {
        _status = 'Loading detector...';
      });

      await _speechService.initialize();

      final detectorService = DetectorService();
      await detectorService.initialize();

      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception('No camera available.');
      }

      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        await detectorService.dispose();
        return;
      }

      _detectorService = detectorService;
      _controller = controller;

      setState(() {
        _initializing = false;
        _status = 'Detecting...';
      });

      await controller.startImageStream(_processFrame);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _initializing = false;
      });
    }
  }

  Future<void> _processFrame(CameraImage image) async {
    if (_paused || _processingFrame) {
      return;
    }

    final detectorService = _detectorService;

    if (detectorService == null) {
      return;
    }

    _processingFrame = true;

    try {
      final rgbBytes = YuvConverter.convertToRgb(image);

      final detections = await detectorService.detect(
        rgbBytes: rgbBytes,
        imageWidth: image.width,
        imageHeight: image.height,
      );

      if (!mounted) return;

     setState(() {
  _detections = detections;

  _status = detections.isEmpty
      ? 'No objects detected'
      : '${detections.length} object(s) detected';
});
   
      await _announceDetections(detections);

      if (detections.isNotEmpty) {
        debugPrint(
          detections
              .map(
                (d) =>
                    '${d.label}: ${(d.confidence * 100).toStringAsFixed(1)}%',
              )
              .join(', '),
        );
      }
    } catch (e) {
      debugPrint('Detection error: $e');

      if (mounted) {
        setState(() {
          _status = 'Detection error';
        });
      }
    } finally {
      _processingFrame = false;
    }
  }

  Future<void> _togglePause() async {
    if (!mounted) return;

    setState(() {
      _paused = !_paused;
      _status = _paused ? 'Detection paused' : 'Detecting...';
    });
  }

 @override
void dispose() {
  _controller?.stopImageStream();
  _controller?.dispose();
  _detectorService?.dispose();
  _speechService.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Live Object Detector'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(_status),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Live Object Detector'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _error!,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return const Scaffold(
        body: Center(
          child: Text('Camera is not available.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Object Detector'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(controller),


           Positioned.fill(
    child: CustomPaint(
      painter: DetectionPainter(
  detections: _detections,
  cameraAspectRatio: controller.value.aspectRatio,
),
    ),
  ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: SafeArea(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _status,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 48,
                        child: FilledButton.icon(
                          onPressed: _togglePause,
                          icon: Icon(
                            _paused
                                ? Icons.play_arrow
                                : Icons.pause,
                          ),
                          label: Text(
                            _paused ? 'Resume' : 'Pause',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}