# Utopia Analytics

Light & Fast Dart Analytics Library

[![Pub Package](https://img.shields.io/pub/v/utopia_analytics.svg?style=flat-square)](https://pub.dev/packages/utopia_analytics) [![Test](https://github.com/utopia-dart/utopia_analytics/actions/workflows/test.yml/badge.svg)](https://github.com/utopia-dart/utopia_analytics/actions/workflows/test.yml)

## Features

- Analytics
- Multiple Providers

## Getting started

Add dependency

```yaml
dependencies:
    utopia_analytics: <latest>
```

## Usage

Example

```dart
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
```

## Copyright and license

The MIT License (MIT) [https://www.opensource.org/licenses/mit-license.php](https://www.opensource.org/licenses/mit-license.php)
