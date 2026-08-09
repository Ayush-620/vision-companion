import 'dart:typed_data';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../history/repository/history_repository.dart';
import '../models/detection.dart';
import '../services/detector_service.dart';
import '../services/speech_service.dart';
import 'detector_state.dart';

class DetectorCubit extends Cubit<DetectorState> {
  final DetectorService _detectorService;
  final SpeechService _speechService;
  final HistoryRepository _historyRepository;

  DateTime? _lastAnnouncement;

  static const Duration _announcementCooldown =
      Duration(seconds: 2);

  DetectorCubit({
    required DetectorService detectorService,
    required SpeechService speechService,
    required HistoryRepository historyRepository,
  })  : _detectorService = detectorService,
        _speechService = speechService,
        _historyRepository = historyRepository,
        super(const DetectorInitial());

  Future<void> initialize() async {
    try {
      await _speechService.initialize();
      await _detectorService.initialize();

      emit(const DetectorRunning());
    } catch (e) {
      emit(DetectorError(e.toString()));
      rethrow;
    }
  }

  Future<List<Detection>> detect({
    required Uint8List rgbBytes,
    required int imageWidth,
    required int imageHeight,
  }) async {
    try {
      final detections = await _detectorService.detect(
        rgbBytes: rgbBytes,
        imageWidth: imageWidth,
        imageHeight: imageHeight,
      );

      emit(DetectorResults(detections));

      await _announceDetections(detections);

      return detections;
    } catch (e) {
      emit(DetectorError(e.toString()));
      rethrow;
    }
  }

  Future<void> _announceDetections(
    List<Detection> detections,
  ) async {
    if (detections.isEmpty) {
      return;
    }

    final now = DateTime.now();

    // Announce at most once every 2 seconds.
    if (_lastAnnouncement != null &&
        now.difference(_lastAnnouncement!) <
            _announcementCooldown) {
      return;
    }

    final validDetections = detections
        .where((detection) => detection.confidence >= 0.65)
        .toList();

    if (validDetections.isEmpty) {
      return;
    }

    // Highest-confidence detection.
    validDetections.sort(
      (a, b) => b.confidence.compareTo(a.confidence),
    );

    final topDetection = validDetections.first;

    final confidence =
        (topDetection.confidence * 100).toStringAsFixed(0);

    final message =
        '${topDetection.label} detected, $confidence percent confidence';


    _lastAnnouncement = now;

    await FirebaseAnalytics.instance.logEvent(
  name: 'detection_completed',
  parameters: {
    'object': topDetection.label,
    'confidence': confidence,
  },
);

   // Haptic feedback.
await HapticFeedback.mediumImpact();

    // Existing voice output.
    await _speechService.speak(
      '${topDetection.label} detected',
    );

    // Existing Firestore history.
    try {
      await _historyRepository.saveHistory(
        featureType: 'detector',
        resultSummary: message,
      );
    } catch (_) {
      // History failure should not stop detection.
    }
  }

  Future<void> dispose() async {
    await _detectorService.dispose();
    _speechService.dispose();
    close();
  }
}