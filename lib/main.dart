import 'package:flutter/material.dart';
import 'package:pbl5_smarthome/core/app/app.dart';
import 'package:pbl5_smarthome/services/mqtt_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MQTTInitializer.initialize();
  runApp(
      MQTTInitializer.wrapWithProviders(
        const SmartHomeApp(),
      ),
  );
}
