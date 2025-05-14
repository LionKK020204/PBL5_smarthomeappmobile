import '../services/mqtt_service.dart';

class ControllerFan {
  final MQTTService mqttService;

  ControllerFan(this.mqttService);

  Future<void> toggleFan(bool isOn, int roomId) async {
    if (!mqttService.isConnected) {
      print('⚠️ MQTT chưa kết nối, không thể gửi tín hiệu');
      return;
    }
    final topic = _topicForControl(roomId);
    final message = isOn ? 'ON' : 'OFF';
    mqttService.publish(topic, message);
  }

  void listenFanStatus(int roomId, Function(String) onStatusUpdate) {
    if (!mqttService.isConnected) {
      print('⚠️ MQTT chưa kết nối, không thể nhận tín hiệu');
      return;
    }
    final topic = _topicForStatus(roomId);
    mqttService.subscribe(topic, onStatusUpdate);
  }

  /// 🌀 Gửi tốc độ quạt: speed từ 0 đến 100
  Future<void> setFanSpeed(int roomId, int speed) async {
    if (!mqttService.isConnected) {
      print('⚠️ MQTT chưa kết nối, không thể gửi tốc độ quạt');
      return;
    }

    if (speed < 0 || speed > 100) {
      print('⚠️ Tốc độ quạt phải nằm trong khoảng 0 - 100');
      return;
    }

    final topic = _topicForSpeed(roomId);
    mqttService.publish(topic, speed.toString());
    print('📤 Gửi tốc độ quạt: $speed đến $topic');
  }

  String _topicForControl(int roomId) => 'home/room$roomId/fan';
  String _topicForStatus(int roomId) => 'home/room$roomId/fan/status';
  String _topicForSpeed(int roomId) => 'home/room$roomId/fan/speed';
}
