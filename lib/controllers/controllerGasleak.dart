import '../services/mqtt_service.dart';

class ControllerGasLeak {
  final MQTTService mqttService;

  ControllerGasLeak(this.mqttService);

  /// Lắng nghe dữ liệu rò rỉ khí gas từ cảm biến chung
  void listenGasLeak(Function(String) onGasLeakUpdate) {
    if (!mqttService.isConnected) {
      print('⚠️ MQTT chưa kết nối, không thể nhận dữ liệu khí gas');
      return;
    }

    const topic = 'home/gas_leak'; // Đổi topic nếu hệ thống bạn sử dụng khác
    mqttService.subscribe(topic, onGasLeakUpdate);
  }
}
