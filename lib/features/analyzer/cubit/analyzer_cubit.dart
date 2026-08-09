import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/groq_vision_service.dart';
import 'analyzer_state.dart';

class AnalyzerCubit extends Cubit<AnalyzerState> {
  final GroqVisionService _service;

  AnalyzerCubit(this._service) : super(const AnalyzerIdle());

  Future<void> analyzeImage(Uint8List imageBytes) async {
    if (state is AnalyzerProcessing) {
      return;
    }

    emit(const AnalyzerProcessing());

    try {
      final result = await _service.analyzeImage(imageBytes);

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