import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../services/mqtt_service.dart'; // hoặc đường dẫn chính xác của bạn
import '../globals/globals.dart'; // hoặc đường dẫn chính xác
import '../controllers/controllerTemp_Hum.dart';

void initializeEnvironmentListeners(BuildContext context) {
  final mqtt = context.read<MQTTService>();
  final env = context.read<GlobalEnvironmentData>();
  final controller = ControllerTemperatureHumidity(mqtt);

  controller.listenTemperature((value) {
    final temp = double.tryParse(value);
    if (temp != null) {
      env.updateTemperature(temp);
    }
  });

  controller.listenHumidity((value) {
    final hum = double.tryParse(value);
    if (hum != null) {
      env.updateHumidity(hum);
    }
  });
}
