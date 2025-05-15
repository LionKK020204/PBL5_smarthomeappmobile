library globals;
import 'package:flutter/foundation.dart';

class GlobalEnvironmentData extends ChangeNotifier {
  double _temperature = 0.0;
  double _humidity = 0.0;

  double get temperature => _temperature;
  double get humidity => _humidity;

  void updateTemperature(double temp) {
    _temperature = temp;
    notifyListeners();
  }

  void updateHumidity(double hum) {
    _humidity = hum;
    notifyListeners();
  }
}


String esp32ID = '192.168.1.5';