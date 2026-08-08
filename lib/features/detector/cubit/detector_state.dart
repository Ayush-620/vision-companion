import '../models/detection.dart';

sealed class DetectorState {
  const DetectorState();
}

class DetectorInitial extends DetectorState {
  const DetectorInitial();
}

class DetectorLoading extends DetectorState {
  const DetectorLoading();
}

class DetectorRunning extends DetectorState {
  final List<Detection> detections;

  const DetectorRunning(this.detections);
}

class DetectorPaused extends DetectorState {
  final List<Detection> detections;

  const DetectorPaused(this.detections);
}

class DetectorError extends DetectorState {
  final String message;

  const DetectorError(this.message);
}