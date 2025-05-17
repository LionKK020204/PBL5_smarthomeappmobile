import '../services/mqtt_service.dart';

class ControllerLight {
  final MQTTService mqttService;

  ControllerLight(this.mqttService);

  Future<void> toggleLight(bool isOn, int roomId) async {
    if (!mqttService.isConnected) {
      print('⚠️ MQTT chưa kết nối, không thể gửi tín hiệu');
      return;
    }
    final topic = _topicForControl(roomId);
    final message = isOn ? 'ON' : 'OFF';
    mqttService.publish(topic, message);
  }

  void listenLightStatus(int roomId, Function(String) onStatusUpdate) {
    if (!mqttService.isConnected) {
      print('⚠️ MQTT chưa kết nối, không thể gửi tín hiệu');
      return;
    }
    final topic = _topicForStatus(roomId);
    mqttService.subscribe(topic, onStatusUpdate);
  }

  /// 💡 Gửi độ sáng đèn: brightness từ 0 đến 100
  Future<void> setLightBrightness(int roomId, int brightness) async {
    if (!mqttService.isConnected) {
      print('⚠️ MQTT chưa kết nối, không thể gửi độ sáng');
      return;
    }

    if (brightness < 0 || brightness > 100) {
      print('⚠️ Độ sáng phải nằm trong khoảng 0 - 100');
      return;
    }

    final topic = _topicForBrightness(roomId);
    mqttService.publish(topic, brightness.toString());
    print('📤 Gửi độ sáng đèn: $brightness đến $topic');
  }

  String _topicForControl(int roomId) => 'home/room$roomId/light';
  String _topicForStatus(int roomId) => 'home/room$roomId/light/status';
  String _topicForBrightness(int roomId) => 'home/room$roomId/light/brightness';
}
