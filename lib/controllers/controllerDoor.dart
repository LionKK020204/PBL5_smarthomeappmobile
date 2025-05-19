import 'package:flutter/cupertino.dart';

import '../services/mqtt_service.dart';

class ControllerDoor extends ChangeNotifier {
  final MQTTService mqttService;
  bool _isDoorOpen = false;

  ControllerDoor(this.mqttService);

  /// Mở hoặc khóa cửa
  Future<void> toggleDoor(bool isOpen) async {
    if (!mqttService.isConnected) {
      print('⚠️ MQTT chưa kết nối, không thể gửi tín hiệu mở/khóa cửa');
      return;
    }

    final message = isOpen ? 'OPEN' : 'LOCK';
    mqttService.publish(_controlTopic, message);
    print('📤 Gửi tín hiệu: $message đến topic $_controlTopic');
  }

  /// Lắng nghe trạng thái cửa từ thiết bị nhận diện khuôn mặt
  void listenDoorStatus(Function(String) onStatusUpdate) {
    if (!mqttService.isConnected) {
      print('⚠️ MQTT chưa kết nối, không thể lắng nghe trạng thái cửa');
      return;
    }

    mqttService.subscribe(_statusTopic, (message) {
      _isDoorOpen = message.trim().toUpperCase() == 'OPEN';
      onStatusUpdate(message);
    });

    print('📥 Đang lắng nghe trạng thái cửa tại topic $_statusTopic');
  }

  /// Lấy trạng thái hiện tại của cửa
  bool get isDoorOpen => _isDoorOpen;

  // ===== Topics =====
  static const String _controlTopic = 'home/mainDoor/control';
  static const String _statusTopic = 'home/mainDoor/status';
}
