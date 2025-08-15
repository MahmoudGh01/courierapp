import 'package:flutter/foundation.dart';

class Printer {
  static void debugPrint(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }
}
