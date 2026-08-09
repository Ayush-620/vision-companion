import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Vision Companion'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name} 👋'**
  String welcome(Object name);

  /// No description provided for @chooseVisionTool.
  ///
  /// In en, this message translates to:
  /// **'Choose a vision tool to get started.'**
  String get chooseVisionTool;

  /// No description provided for @liveObjectDetector.
  ///
  /// In en, this message translates to:
  /// **'Live Object Detector'**
  String get liveObjectDetector;

  /// No description provided for @liveObjectDetectorDescription.
  ///
  /// In en, this message translates to:
  /// **'Use your camera to detect objects in real time.'**
  String get liveObjectDetectorDescription;

  /// No description provided for @startDetector.
  ///
  /// In en, this message translates to:
  /// **'Start Detector'**
  String get startDetector;

  /// No description provided for @aiImageAnalyzer.
  ///
  /// In en, this message translates to:
  /// **'AI Image Analyzer'**
  String get aiImageAnalyzer;

  /// No description provided for @aiImageAnalyzerDescription.
  ///
  /// In en, this message translates to:
  /// **'Capture an image and get an AI-powered description.'**
  String get aiImageAnalyzerDescription;

  /// No description provided for @analyzeImage.
  ///
  /// In en, this message translates to:
  /// **'Analyze Image'**
  String get analyzeImage;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @startingCamera.
  ///
  /// In en, this message translates to:
  /// **'Starting camera...'**
  String get startingCamera;

  /// No description provided for @loadingDetector.
  ///
  /// In en, this message translates to:
  /// **'Loading detector...'**
  String get loadingDetector;

  /// No description provided for @detecting.
  ///
  /// In en, this message translates to:
  /// **'Detecting...'**
  String get detecting;

  /// No description provided for @noObjectsDetected.
  ///
  /// In en, this message translates to:
  /// **'No objects detected'**
  String get noObjectsDetected;

  /// No description provided for @objectsDetected.
  ///
  /// In en, this message translates to:
  /// **'{count} objects detected'**
  String objectsDetected(Object count);

  /// No description provided for @cameraNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Camera is not available.'**
  String get cameraNotAvailable;

  /// No description provided for @detectionError.
  ///
  /// In en, this message translates to:
  /// **'Detection error'**
  String get detectionError;

  /// No description provided for @liveCameraFeed.
  ///
  /// In en, this message translates to:
  /// **'Live camera feed for object detection'**
  String get liveCameraFeed;

  /// No description provided for @resumeDetection.
  ///
  /// In en, this message translates to:
  /// **'Resume detection'**
  String get resumeDetection;

  /// No description provided for @pauseDetection.
  ///
  /// In en, this message translates to:
  /// **'Pause detection'**
  String get pauseDetection;

  /// No description provided for @resumeDetectionHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to resume object detection'**
  String get resumeDetectionHint;

  /// No description provided for @pauseDetectionHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to pause object detection'**
  String get pauseDetectionHint;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @cameraForImageAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Camera for image analysis'**
  String get cameraForImageAnalysis;

  /// No description provided for @captureImageForAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Capture image for AI analysis'**
  String get captureImageForAnalysis;

  /// No description provided for @captureImageHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to capture an image for AI analysis'**
  String get captureImageHint;

  /// No description provided for @analyzingImage.
  ///
  /// In en, this message translates to:
  /// **'Analyzing image...'**
  String get analyzingImage;

  /// No description provided for @analyzingImagePleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Analyzing image, please wait'**
  String get analyzingImagePleaseWait;

  /// No description provided for @analysisResult.
  ///
  /// In en, this message translates to:
  /// **'Analysis Result'**
  String get analysisResult;

  /// No description provided for @analysisResultLabel.
  ///
  /// In en, this message translates to:
  /// **'Analysis result'**
  String get analysisResultLabel;

  /// No description provided for @analyzeAnotherImage.
  ///
  /// In en, this message translates to:
  /// **'Analyze Another Image'**
  String get analyzeAnotherImage;

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed'**
  String get analysisFailed;

  /// No description provided for @retryImageAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Retry image analysis'**
  String get retryImageAnalysis;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @captureImageError.
  ///
  /// In en, this message translates to:
  /// **'Could not capture image'**
  String get captureImageError;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @visionCompanionUser.
  ///
  /// In en, this message translates to:
  /// **'Vision Companion User'**
  String get visionCompanionUser;

  /// No description provided for @noEmailAvailable.
  ///
  /// In en, this message translates to:
  /// **'No email available'**
  String get noEmailAvailable;

  /// No description provided for @openHistory.
  ///
  /// In en, this message translates to:
  /// **'Open history'**
  String get openHistory;

  /// No description provided for @openHistoryHint.
  ///
  /// In en, this message translates to:
  /// **'Double tap to view your detection and image analysis history'**
  String get openHistoryHint;

  /// No description provided for @there.
  ///
  /// In en, this message translates to:
  /// **'there'**
  String get there;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
