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
  String _topicForControl(int roomId) => 'home/room$roomId/light';
  String _topicForStatus(int roomId) => 'home/room$roomId/light/status';
}
