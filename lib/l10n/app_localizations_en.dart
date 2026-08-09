// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vision Companion';

  @override
  String welcome(Object name) {
    return 'Welcome, $name 👋';
  }

  @override
  String get chooseVisionTool => 'Choose a vision tool to get started.';

  @override
  String get liveObjectDetector => 'Live Object Detector';

  @override
  String get liveObjectDetectorDescription => 'Use your camera to detect objects in real time.';

  @override
  String get startDetector => 'Start Detector';

  @override
  String get aiImageAnalyzer => 'AI Image Analyzer';

  @override
  String get aiImageAnalyzerDescription => 'Capture an image and get an AI-powered description.';

  @override
  String get analyzeImage => 'Analyze Image';

  @override
  String get profile => 'Profile';

  @override
  String get signOut => 'Sign Out';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'Hindi';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get startingCamera => 'Starting camera...';

  @override
  String get loadingDetector => 'Loading detector...';

  @override
  String get detecting => 'Detecting...';

  @override
  String get noObjectsDetected => 'No objects detected';

  @override
  String objectsDetected(Object count) {
    return '$count objects detected';
  }

  @override
  String get cameraNotAvailable => 'Camera is not available.';

  @override
  String get detectionError => 'Detection error';

  @override
  String get liveCameraFeed => 'Live camera feed for object detection';

  @override
  String get resumeDetection => 'Resume detection';

  @override
  String get pauseDetection => 'Pause detection';

  @override
  String get resumeDetectionHint => 'Double tap to resume object detection';

  @override
  String get pauseDetectionHint => 'Double tap to pause object detection';

  @override
  String get resume => 'Resume';

  @override
  String get pause => 'Pause';

  @override
  String get cameraForImageAnalysis => 'Camera for image analysis';

  @override
  String get captureImageForAnalysis => 'Capture image for AI analysis';

  @override
  String get captureImageHint => 'Double tap to capture an image for AI analysis';

  @override
  String get analyzingImage => 'Analyzing image...';

  @override
  String get analyzingImagePleaseWait => 'Analyzing image, please wait';

  @override
  String get analysisResult => 'Analysis Result';

  @override
  String get analysisResultLabel => 'Analysis result';

  @override
  String get analyzeAnotherImage => 'Analyze Another Image';

  @override
  String get analysisFailed => 'Analysis failed';

  @override
  String get retryImageAnalysis => 'Retry image analysis';

  @override
  String get retry => 'Retry';

  @override
  String get captureImageError => 'Could not capture image';

  @override
  String get history => 'History';

  @override
  String get visionCompanionUser => 'Vision Companion User';

  @override
  String get noEmailAvailable => 'No email available';

  @override
  String get openHistory => 'Open history';

  @override
  String get openHistoryHint => 'Double tap to view your detection and image analysis history';

  @override
  String get there => 'there';
}
