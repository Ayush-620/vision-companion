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
  String get liveObjectDetectorDescription => 'रीयल टाइम में वस्तुओं का पता लगाने के लिए अपने कैमरे का उपयोग करें।';

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
}
