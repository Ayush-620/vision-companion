import 'package:go_router/go_router.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/app_localizations.dart';
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
        (camera) =>
            camera.lensDirection == CameraLensDirection.back,
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

      final l10n = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${l10n.captureImageError}: $e',
          ),
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
    final l10n = AppLocalizations.of(context)!;

    if (_initializing) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: l10n.backToHome,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
          title: Text(l10n.aiImageAnalyzer),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
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
          title: Text(l10n.aiImageAnalyzer),
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

    return BlocProvider(
      create: (_) => AnalyzerCubit(
        GroqVisionService(),
        getIt<HistoryRepository>(),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: l10n.backToHome,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
          title: Text(l10n.aiImageAnalyzer),
        ),
        body: BlocBuilder<AnalyzerCubit, AnalyzerState>(
          builder: (context, state) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Semantics(
                  label: l10n.cameraForImageAnalysis,
                  image: true,
                  child: CameraPreview(controller),
                ),

                if (state is AnalyzerProcessing)
                  Semantics(
                    liveRegion: true,
                    label: l10n.analyzingImagePleaseWait,
                    child: Container(
                      color: Colors.black54,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              l10n.analyzingImage,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
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
                        label: l10n.captureImageForAnalysis,
                        button: true,
                        hint: l10n.captureImageHint,
                        child: FilledButton.icon(
                          onPressed: () =>
                              _captureImage(context),
                          icon: const Icon(
                            Icons.camera_alt,
                          ),
                          label: Text(
                            l10n.analyzeImage,
                          ),
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
    final l10n = AppLocalizations.of(context)!;

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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.analysisResult,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Flexible(
                  child: SingleChildScrollView(
                    child: Semantics(
                      label: l10n.analysisResultLabel,
                      child: Text(result),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: Semantics(
                    button: true,
                    label: l10n.analyzeAnotherImage,
                    child: FilledButton(
                      onPressed: () {
                        context
                            .read<AnalyzerCubit>()
                            .reset();
                      },
                      child: Text(
                        l10n.analyzeAnotherImage,
                      ),
                    ),
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
    final l10n = AppLocalizations.of(context)!;

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
                Text(
                  l10n.analysisFailed,
                  style: const TextStyle(
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
                  child: Semantics(
                    button: true,
                    label: l10n.retryImageAnalysis,
                    child: FilledButton(
                      onPressed: () {
                        context
                            .read<AnalyzerCubit>()
                            .reset();
                      },
                      child: Text(l10n.retry),
                    ),
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