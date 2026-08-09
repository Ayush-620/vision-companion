import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../l10n/app_localizations.dart';
import '../cubit/detector_cubit.dart';
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
  late final DetectorCubit _detectorCubit;

  List<Detection> _detections = [];

  bool _initializing = true;
  bool _processingFrame = false;
  bool _paused = false;

  String? _error;
  String _status = 'Starting camera...';

  @override
  void initState() {
    super.initState();

    _detectorCubit = getIt<DetectorCubit>();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      if (mounted) {
        setState(() {
          _status = 'Loading detector...';
        });
      }

      await _detectorCubit.initialize();

      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        throw Exception('No camera available.');
      }

      final camera = cameras.firstWhere(
        (camera) =>
            camera.lensDirection == CameraLensDirection.back,
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
        return;
      }

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

    _processingFrame = true;

    try {
      final rgbBytes = YuvConverter.convertToRgb(image);

      final detections = await _detectorCubit.detect(
        rgbBytes: rgbBytes,
        imageWidth: image.width,
        imageHeight: image.height,
      );

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      setState(() {
        _detections = detections;

        _status = detections.isEmpty
            ? l10n.noObjectsDetected
            : l10n.objectsDetected(detections.length);
      });

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
        final l10n = AppLocalizations.of(context)!;

        setState(() {
          _status = l10n.detectionError;
        });
      }
    } finally {
      _processingFrame = false;
    }
  }

  Future<void> _togglePause() async {
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _paused = !_paused;
      _status = _paused ? l10n.pauseDetection : l10n.detecting;
    });
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    _detectorCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_initializing) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: l10n.backToHome,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
          title: Text(l10n.liveObjectDetector),
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
          leading: IconButton(
            tooltip: l10n.backToHome,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
          title: Text(l10n.liveObjectDetector),
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

    if (controller == null ||
        !controller.value.isInitialized) {
      return Scaffold(
        body: Center(
          child: Text(l10n.cameraNotAvailable),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.backToHome,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        title: Text(l10n.liveObjectDetector),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Semantics(
            label: l10n.liveCameraFeed,
            image: true,
            child: CameraPreview(controller),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: DetectionPainter(
                  detections: _detections,
                  cameraAspectRatio:
                      controller.value.aspectRatio,
                ),
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
                        child: Semantics(
                          liveRegion: true,
                          label: _status,
                          child: Text(
                            _status,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 48,
                        child: Semantics(
                          button: true,
                          label: _paused
                              ? l10n.resumeDetection
                              : l10n.pauseDetection,
                          hint: _paused
                              ? l10n.resumeDetectionHint
                              : l10n.pauseDetectionHint,
                          child: FilledButton.icon(
                            onPressed: _togglePause,
                            icon: Icon(
                              _paused
                                  ? Icons.play_arrow
                                  : Icons.pause,
                            ),
                            label: Text(
                              _paused
                                  ? l10n.resume
                                  : l10n.pause,
                            ),
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