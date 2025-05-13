import 'package:flutter/material.dart';
import 'package:pbl5_smarthome/core/app/app.dart';
import 'package:pbl5_smarthome/services/mqtt_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final mqttService = MQTTService(
    broker: '192.168.1.3',
    username: 'admin',
    password: '020204',
    clientId: 'flutter_app',
  );
  await mqttService.connect();
  runApp(const SmartHomeApp());
}
