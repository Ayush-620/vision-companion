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
}
