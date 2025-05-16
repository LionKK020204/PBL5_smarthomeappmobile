import '../services/mqtt_service.dart';

class ControllerTemperatureHumidity {
  final MQTTService mqttService;

  ControllerTemperatureHumidity(this.mqttService);

  /// Lắng nghe nhiệt độ từ cảm biến chung cho cả nhà
  void listenTemperature(Function(String) onTemperatureUpdate) {
    if (!mqttService.isConnected) {
      print('⚠️ MQTT chưa kết nối, không thể nhận nhiệt độ');
      return;
    }
    const topic = 'home/temperature';
    mqttService.subscribe(topic, onTemperatureUpdate);
  }

  /// Lắng nghe độ ẩm từ cảm biến chung cho cả nhà
  void listenHumidity(Function(String) onHumidityUpdate) {
    if (!mqttService.isConnected) {
      print('⚠️ MQTT chưa kết nối, không thể nhận độ ẩm');
      return;
    }
    const topic = 'home/humidity';
    mqttService.subscribe(topic, onHumidityUpdate);
  }
}
