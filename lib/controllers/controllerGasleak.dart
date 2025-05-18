import '../services/mqtt_service.dart';
import 'package:flutter/material.dart';

class ControllerGasLeak extends ChangeNotifier {
  final MQTTService mqttService;

  ControllerGasLeak(this.mqttService) {
    _init();
  }

  double _gasValue = 0;

  double get gasValue => _gasValue;

  void _init() {
    if (!mqttService.isConnected) {
      print('⚠️ MQTT chưa kết nối, không thể nhận dữ liệu khí gas');
      return;
    }

    const topic = 'home/gas_leak';
    mqttService.subscribe(topic, (message) {
      try {
        final value = double.parse(message);
        _gasValue = value;
        notifyListeners(); // Cập nhật UI
      } catch (e) {
        print('❌ Không thể parse dữ liệu gas: $message');
      }
    });
  }
}
