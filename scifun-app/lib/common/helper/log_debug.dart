import 'package:flutter/foundation.dart';

void logD(Object? message) {
  if (kDebugMode) {
    print(message);
  }
}
