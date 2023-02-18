import 'dart:convert';

import 'package:utopia_analytics/src/adapter.dart';
import 'package:utopia_analytics/src/event.dart';

class Plausible extends Adapter {
  final String _apiKey;
  final String domain;

  Plausible(this.domain, this._apiKey, {super.userAgent, super.clientIP}):super(endpoint: 'https://plausible.io/api');

  @override
  String getName() {
    return 'Plausible';
  }

  @override
  Future<bool> send(Event event) async {
    if (!enabled) {
      return false;
    }
    if (!await provisionGoal(event.type)) {
      return false;
    }

    final params = {
      'url': event.url,
      'props': event.props,
      'domain': domain,
      'name': event.type,
      'referrer': event.getProp('referrer'),
      'screen_width': event.getProp('screenWidth'),
    };

    final headers = {
      'X-Forwarded-For': clientIP ?? '',
      'User-Agent': userAgent,
      'Content-Type': 'application/json',
    };

    await call(method: 'POST', headers: headers, params: params);
    return true;
  }

  @override
  Future<bool> validate(Event event) async {
    if (!enabled) {
      return false;
    }
    if (event.type.isEmpty) {
      throw 'Event type is required';
    }
    if (event.url.isEmpty) {
      throw 'Event URL is required';
    }

    final validateURL =
        '$endpoint/v1/stats/aggregate?site_id=$domain&filters=${jsonEncode({
          "goal": event.name
        })}';
    final checkCreated = await call(method: 'GET', path: validateURL, headers: {
      'Content-Type': '',
      'Authorization': 'Bearer $_apiKey',
    },);
    final created = jsonDecode(checkCreated);

    if(created['results']?['visitors']?['value'] == null) {
      throw 'Failed to validate event';
    }
    return created['results']?['visitors']?['value'] > 0;
  }

  Future<bool> provisionGoal(String eventName) async {
    final params = {
      'site_id': domain,
      'goal_type': 'event',
      'event_name': eventName
    };

    final headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer $_apiKey',
    };

    await call(
      method: 'PUT',
      path: '/v1/sites/goals',
      headers: headers,
      params: params,
    );
    return true;
  }
}
