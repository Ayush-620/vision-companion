import 'dart:typed_data';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/groq_vision_service.dart';
import '../../history/repository/history_repository.dart';
import 'analyzer_state.dart';

class AnalyzerCubit extends Cubit<AnalyzerState> {
  final GroqVisionService _service;
  final HistoryRepository _historyRepository;

  AnalyzerCubit(
    this._service,
    this._historyRepository,
  ) : super(const AnalyzerIdle());

  Future<void> analyzeImage(Uint8List imageBytes) async {
    if (state is AnalyzerProcessing) {
      return;
    }

    emit(const AnalyzerProcessing());

    try {
      final result = await _service.analyzeImage(imageBytes);

      await FirebaseAnalytics.instance.logEvent(
  name: 'image_analyzed',
);

      await _historyRepository.saveHistory(
        featureType: 'analyzer',
        resultSummary: result,
     );

      emit(AnalyzerResult(result));
    } catch (e) {
      emit(
        AnalyzerError(
          e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void reset() {
    emit(const AnalyzerIdle());
  }
}