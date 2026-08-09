import '../models/detection.dart';

sealed class DetectorState {
  const DetectorState();
}

class DetectorInitial extends DetectorState {
  const DetectorInitial();
}

class DetectorRunning extends DetectorState {
  const DetectorRunning();
}

class DetectorResults extends DetectorState {
  final List<Detection> detections;

  const DetectorResults(this.detections);
}

class DetectorError extends DetectorState {
  final String message;

  const DetectorError(this.message);
}