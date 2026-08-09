import 'package:flutter/foundation.dart';

@immutable
sealed class AnalyzerState {
  const AnalyzerState();
}

class AnalyzerIdle extends AnalyzerState {
  const AnalyzerIdle();
}

class AnalyzerProcessing extends AnalyzerState {
  const AnalyzerProcessing();
}

class AnalyzerResult extends AnalyzerState {
  final String result;

  const AnalyzerResult(this.result);
}

class AnalyzerError extends AnalyzerState {
  final String message;

  const AnalyzerError(this.message);
}