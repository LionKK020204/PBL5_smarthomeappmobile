import '../services/mqtt_service.dart';
import 'package:flutter/material.dart';
import '../globals/globals.dart'; // chứa navigatorKey

class ControllerGasLeak extends ChangeNotifier {
  final MQTTService mqttService;

  ControllerGasLeak(this.mqttService) {
    _init();
  }

  double _gasValue = 0;
  bool _hasShownWarning = false;

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
        notifyListeners(); // cập nhật UI

        // ⚠️ Kiểm tra cảnh báo
        if (_gasValue > 500 && !_hasShownWarning) {
          _hasShownWarning = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final context = navigatorKey.currentContext;
            if (context != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    '⚠️ Cảnh báo: Nồng độ khí gas vượt ngưỡng an toàn!',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 4),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                ),
              );
            }
          });
        } else if (_gasValue <= 500 && _hasShownWarning) {
          _hasShownWarning = false;
        }
      } catch (e) {
        print('❌ Không thể parse dữ liệu gas: $message');
      }
    });
  }
}
