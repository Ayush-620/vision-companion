import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/analyzer_cubit.dart';
import '../cubit/analyzer_state.dart';
import '../services/groq_vision_service.dart';
import '../../../core/di/injection.dart';
import '../../history/repository/history_repository.dart';

class AnalyzerPage extends StatefulWidget {
  const AnalyzerPage({super.key});

  @override
  State<AnalyzerPage> createState() => _AnalyzerPageState();
}

class _AnalyzerPageState extends State<AnalyzerPage> {
  CameraController? _controller;

  bool _initializing = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
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
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _initializing = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _initializing = false;
      });
    }
  }

 Future<void> _captureImage(BuildContext context) async {
  final controller = _controller;

  if (controller == null || !controller.value.isInitialized) {
    return;
  }

  final cubit = context.read<AnalyzerCubit>();

  if (cubit.state is AnalyzerProcessing) {
    return;
  }

  try {
    final image = await controller.takePicture();
    final bytes = await image.readAsBytes();

    if (!mounted) return;

    await cubit.analyzeImage(bytes);
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not capture image: $e'),
      ),
    );
  }
}

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_initializing) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('AI Image Analyzer'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('AI Image Analyzer'),
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

    return BlocProvider(
      create: (_) => AnalyzerCubit(
       GroqVisionService(),
       getIt<HistoryRepository>(),
     ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Image Analyzer'),
        ),
        body: BlocBuilder<AnalyzerCubit, AnalyzerState>(
          builder: (context, state) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(controller),

                if (state is AnalyzerProcessing)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Analyzing image...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (state is AnalyzerResult)
                  _buildResultPanel(
                    context,
                    state.result,
                  ),

                if (state is AnalyzerError)
                  _buildErrorPanel(
                    context,
                    state.message,
                  ),

                if (state is AnalyzerIdle)
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 32,
                    child: SafeArea(
                      child: Semantics(
                        label: 'Capture image for AI analysis',
                        button: true,
                        child: FilledButton.icon(
                          onPressed: () => _captureImage(context),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Analyze Image'),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultPanel(
    BuildContext context,
    String result,
  ) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: SafeArea(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analysis Result',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(result),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      context.read<AnalyzerCubit>().reset();
                    },
                    child: const Text('Analyze Another Image'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorPanel(
    BuildContext context,
    String message,
  ) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: SafeArea(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 40,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Analysis failed',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      context.read<AnalyzerCubit>().reset();
                    },
                    child: const Text('Retry'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}