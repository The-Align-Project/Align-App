import 'package:flutter/foundation.dart';
import '../models/focus_session.dart';

class FocusProvider with ChangeNotifier {
  final List<FocusSession> _sessions = [];
  bool _isTracking = false;
  DateTime? _currentSessionStart;

  bool get isTracking => _isTracking;
  List<FocusSession> get sessions => _sessions;
  DateTime? get currentSessionStart => _currentSessionStart;

  void startTracking() {
    _isTracking = true;
    _currentSessionStart = DateTime.now();
    notifyListeners();
  }

  void stopTracking() {
    if (_currentSessionStart != null) {
      _sessions.add(
        FocusSession(
          startTime: _currentSessionStart!,
          endTime: DateTime.now(),
          focusScore: _calculateFocusScore(),
          metrics: _collectMetrics(),
        ),
      );
    }
    _isTracking = false;
    _currentSessionStart = null;
    notifyListeners();
  }

  double _calculateFocusScore() {
    return 0.0;
  }

  Map<String, dynamic> _collectMetrics() {
    return {};
  }
}