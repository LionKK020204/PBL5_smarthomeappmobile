import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/controllerLight.dart';
import '../../../../core/core.dart';
import '../../../../services/mqtt_service.dart';

class LightsAndTimerSwitchers extends StatefulWidget {
  const LightsAndTimerSwitchers({required this.room, super.key});

  final SmartRoom room;

  @override
  State<LightsAndTimerSwitchers> createState() => _LightsAndTimerSwitchersState();
}

class _LightsAndTimerSwitchersState extends State<LightsAndTimerSwitchers> {
  late bool isLightOn;
  late bool isTimerOn;
  late ControllerLight espController;

  @override
  void initState() {
    super.initState();
    isLightOn = widget.room.lights.isOn;
    isTimerOn = widget.room.timer.isOn;

    final mqttService = context.read<MQTTService>(); // 👈 lấy từ Provider
    espController = ControllerLight(mqttService);

    // getLightStatus();
  }

  Future<void> getLightStatus() async {
    espController.listenLightStatus(
      int.parse(widget.room.id),
          (status) {
        if (mounted) {
          setState(() {
            isLightOn = status.toUpperCase() == 'ON';
          });
        }
      },
    );
  }



  @override
  Widget build(BuildContext context) {

    return SHCard(
      childrenPadding: const EdgeInsets.all(12),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lights'),
            const SizedBox(height: 8),
            SHSwitcher(
              value: isLightOn,
              onChanged: (value) {
                setState(() {
                  isLightOn = value;
                });
                // Gửi tín hiệu đến ESP32
                // espController.toggleLight(value, int.parse(widget.room.id));
              },
              icon: const Icon(SHIcons.lightBulbOutline),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('Timer'),
                Spacer(),
                BlueLightDot(),
              ],
            ),
            const SizedBox(height: 8),
            SHSwitcher(
              icon: isTimerOn
                  ? const Icon(SHIcons.timer)
                  : const Icon(SHIcons.timerOff),
              value: isTimerOn,
              onChanged: (value) {
                setState(() {
                  isTimerOn = value;
                });
                // Gửi tín hiệu đến ESP32

              },
            ),
          ],
        ),
      ],
    );
  }
}

