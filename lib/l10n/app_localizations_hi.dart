// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'विज़न कंपैनियन';

  @override
  String welcome(Object name) {
    return 'स्वागत है, $name 👋';
  }

  @override
  String get chooseVisionTool => 'शुरू करने के लिए कोई विज़न टूल चुनें।';

  @override
  String get liveObjectDetector => 'लाइव ऑब्जेक्ट डिटेक्टर';

  @override
  String get liveObjectDetectorDescription => 'रियल टाइम में वस्तुओं का पता लगाने के लिए अपने कैमरे का उपयोग करें।';

  @override
  String get startDetector => 'डिटेक्टर शुरू करें';

  @override
  String get aiImageAnalyzer => 'AI इमेज एनालाइज़र';

  @override
  String get aiImageAnalyzerDescription => 'एक तस्वीर लें और उसका AI द्वारा विवरण प्राप्त करें।';

  @override
  String get analyzeImage => 'तस्वीर का विश्लेषण करें';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get hindi => 'हिंदी';

  @override
  String get backToHome => 'होम पर वापस जाएँ';

  @override
  String get startingCamera => 'कैमरा शुरू हो रहा है...';

  @override
  String get loadingDetector => 'डिटेक्टर लोड हो रहा है...';

  @override
  String get detecting => 'पता लगाया जा रहा है...';

  @override
  String get noObjectsDetected => 'कोई वस्तु नहीं मिली';

  @override
  String objectsDetected(Object count) {
    return '$count वस्तुएँ मिलीं';
  }

  @override
  String get cameraNotAvailable => 'कैमरा उपलब्ध नहीं है।';

  @override
  String get detectionError => 'डिटेक्शन में त्रुटि';

  @override
  String get liveCameraFeed => 'ऑब्जेक्ट डिटेक्शन के लिए लाइव कैमरा फ़ीड';

  @override
  String get resumeDetection => 'डिटेक्शन फिर से शुरू करें';

  @override
  String get pauseDetection => 'डिटेक्शन रोकें';

  @override
  String get resumeDetectionHint => 'ऑब्जेक्ट डिटेक्शन फिर से शुरू करने के लिए दो बार टैप करें';

  @override
  String get pauseDetectionHint => 'ऑब्जेक्ट डिटेक्शन रोकने के लिए दो बार टैप करें';

  @override
  String get resume => 'फिर से शुरू करें';

  @override
  String get pause => 'रोकें';

  @override
  String get cameraForImageAnalysis => 'इमेज विश्लेषण के लिए कैमरा';

  @override
  String get captureImageForAnalysis => 'AI विश्लेषण के लिए तस्वीर लें';

  @override
  String get captureImageHint => 'AI विश्लेषण के लिए तस्वीर लेने हेतु दो बार टैप करें';

  @override
  String get analyzingImage => 'तस्वीर का विश्लेषण किया जा रहा है...';

  @override
  String get analyzingImagePleaseWait => 'तस्वीर का विश्लेषण किया जा रहा है, कृपया प्रतीक्षा करें';

  @override
  String get analysisResult => 'विश्लेषण परिणाम';

  @override
  String get analysisResultLabel => 'विश्लेषण परिणाम';

  @override
  String get analyzeAnotherImage => 'एक और तस्वीर का विश्लेषण करें';

  @override
  String get analysisFailed => 'विश्लेषण विफल हुआ';

  @override
  String get retryImageAnalysis => 'तस्वीर का विश्लेषण फिर से करें';

  @override
  String get retry => 'फिर से प्रयास करें';

  @override
  String get captureImageError => 'तस्वीर लेने में समस्या हुई';

  @override
  String get history => 'इतिहास';

  @override
  String get visionCompanionUser => 'विज़न कंपैनियन उपयोगकर्ता';

  @override
  String get noEmailAvailable => 'ईमेल उपलब्ध नहीं है';

  @override
  String get openHistory => 'इतिहास खोलें';

  @override
  String get openHistoryHint => 'अपनी डिटेक्शन और इमेज विश्लेषण का इतिहास देखने के लिए दो बार टैप करें';

  @override
  String get there => 'आप';
}
