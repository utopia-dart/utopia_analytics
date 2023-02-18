import 'package:utopia_analytics/src/event.dart';

abstract class Adapter {
  bool _enabled = true;
  String userAgent = 'Utopia Dart Framework';
  String? clientIP;
  String endpoint = '';

  Adapter(
      {this.userAgent = 'Utopia Dart Framework',
      this.clientIP,
      this.endpoint = ''});

  final Map<String, String> headers = {};
  bool get enabled => _enabled;

  String getName();
  void enable() {
    _enabled = true;
  }

  void disable() {
    _enabled = false;
  }

  Future<bool> send(Event event);
  Future<bool> validate(Event event);
  Future<bool> createEvent(Event event) async {
    try {
      return await send(event);
    } on Exception catch (e) {
      logError(e);
      return false;
    }
  }

  dynamic call({
    required String method,
    String path = '',
    Map<String, String> headers = const {},
    Map<String, dynamic> params = const {},
  }) {}

  void logError(Exception e) {
    print(e.toString());
  }
}
