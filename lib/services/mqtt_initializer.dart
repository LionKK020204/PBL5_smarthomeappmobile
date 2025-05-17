import 'package:flutter/material.dart';
import 'package:pbl5_smarthome/controllers/controllerGasleak.dart';
import 'package:provider/provider.dart';
import 'package:pbl5_smarthome/services/mqtt_service.dart';

import '../controllers/controllerFan.dart';
import '../controllers/controllerLight.dart';
import '../controllers/controllerTemp_Hum.dart';
import '../globals/globals.dart';

class MQTTInitializer {
  static final MQTTService mqttService = MQTTService(
    broker: '192.168.1.210',
    username: 'admin',
    password: '020204',
    clientId: 'flutter_app',
  );

  static Future<void> initialize() async {
    await mqttService.connect();
  }

  // Hàm này dùng để bọc app với Provider, giúp toàn bộ widget tree dùng được mqttService
  static Widget wrapWithProviders(Widget child) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalEnvironmentData()),
        Provider<MQTTService>.value(value: mqttService),
        ProxyProvider<MQTTService, ControllerTemperatureHumidity>(
          update: (_, mqtt, __) => ControllerTemperatureHumidity(mqtt),
        ),
        ProxyProvider<MQTTService, ControllerLight>(
          update: (_, mqtt, __) => ControllerLight(mqtt),
        ),
        ProxyProvider<MQTTService, ControllerFan>(
          update: (_, mqtt, __) => ControllerFan(mqtt),
        ),
        ProxyProvider<MQTTService, ControllerGasLeak>(
          update: (_, mqtt, __) => ControllerGasLeak(mqtt),
        ),
      ],
      child: child,
    );
    // return Provider<MQTTService>.value(
    //   value: mqttService,
    //   child: child,
    // );
  }
}
