import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbl5_smarthome/services/mqtt_service.dart';

import '../globals/globals.dart';

class MQTTInitializer {
  static final MQTTService mqttService = MQTTService(
    broker: '192.168.1.3',
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
      ],
      child: child,
    );
    // return Provider<MQTTService>.value(
    //   value: mqttService,
    //   child: child,
    // );
  }
}
