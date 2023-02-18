import 'package:utopia_analytics/utopia_analytics.dart';

void main() async {
  final pl = Plausible('utopiadart.dev', 'API_KEY',
      userAgent: 'Utopia Dart Framework');
  final event = Event(
    type: 'click',
    name: 'growth',
    url: 'https://utopiadart.dev/get-started',
  );
  await pl.createEvent(event);
}
